#!/usr/bin/env bash
set -euo pipefail

# Promote the image tag currently running in dev to prod by opening a PR that
# bumps helm/<service>/values-prod.yaml to match values-dev.yaml. Merging the PR
# is the approval gate; prod ArgoCD then deploys the identical digest.

SERVICE="${1:-}"
[ -n "$SERVICE" ] || { echo "usage: promote.sh <service>" >&2; exit 1; }

DEV="helm/$SERVICE/values-dev.yaml"
PROD="helm/$SERVICE/values-prod.yaml"
[ -f "$DEV" ] && [ -f "$PROD" ] || { echo "missing values files for $SERVICE" >&2; exit 1; }

devtag=$(grep -m1 '^  tag:' "$DEV" | awk '{print $2}')
prodtag=$(grep -m1 '^  tag:' "$PROD" | awk '{print $2}')
[ -n "$devtag" ] || { echo "no image tag found in $DEV" >&2; exit 1; }

migtag=$(grep -m1 '^    tag:' "$DEV" | awk '{print $2}' || true)

if [ "$devtag" = "$prodtag" ] && { [ -z "${migtag:-}" ] || [ "$migtag" = "$(grep -m1 '^    tag:' "$PROD" | awk '{print $2}')" ]; }; then
  echo "$SERVICE is already at dev tag $devtag in prod - nothing to promote"
  exit 0
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "working tree not clean - commit or stash first" >&2
  exit 1
fi

branch="promote/$SERVICE-${devtag:0:12}"
git switch -c "$branch"

sed -i "s|^  tag: .*|  tag: $devtag|" "$PROD"
[ -n "${migtag:-}" ] && sed -i "s|^    tag: .*|    tag: $migtag|" "$PROD"

git add "$PROD"
git commit -m "promote: $SERVICE $devtag to prod"
git push -u origin "$branch"

gh pr create --base master --head "$branch" \
  --title "Promote $SERVICE to prod ($devtag)" \
  --body "Promotes the image validated in dev (\`$devtag\`) to prod - identical digest, no rebuild. Merging deploys it to the prod cluster via ArgoCD."

git switch master
echo "PR opened. Review + merge to deploy $SERVICE $devtag to prod."
