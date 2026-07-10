#!/usr/bin/env bash
set -euo pipefail

# Generates a CA, server certificate, and client certificate for AWS Client VPN
# mutual authentication using easy-rsa, then uploads the server and client
# certificates to ACM. Based on:
# https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/client-auth-mutual-enable.html
#
# Requires easy-rsa to already be installed (e.g. `sudo dnf install easy-rsa`).
# Run this once, locally. Not part of the Terraform apply itself.

if ! command -v easyrsa >/dev/null 2>&1; then
  echo "Error: easyrsa not found on PATH. Install it first." >&2
  exit 1
fi

REGION="ap-south-1"
CLIENT_NAME="aurelia-client-1"
WORK_DIR="$(pwd)/pki-work"
OUTPUT_DIR="$(pwd)/certs"

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

easyrsa init-pki
easyrsa build-ca nopass
easyrsa --san=DNS:server build-server-full server nopass
easyrsa build-client-full "$CLIENT_NAME" nopass

mkdir -p "$OUTPUT_DIR"
cp pki/ca.crt "$OUTPUT_DIR/"
cp pki/issued/server.crt "$OUTPUT_DIR/"
cp pki/private/server.key "$OUTPUT_DIR/"
cp "pki/issued/${CLIENT_NAME}.crt" "$OUTPUT_DIR/"
cp "pki/private/${CLIENT_NAME}.key" "$OUTPUT_DIR/"

cd "$OUTPUT_DIR"

echo "Uploading server certificate to ACM..."
SERVER_CERT_ARN=$(aws acm import-certificate \
  --region "$REGION" \
  --certificate fileb://server.crt \
  --private-key fileb://server.key \
  --certificate-chain fileb://ca.crt \
  --query CertificateArn --output text)

echo "Uploading client certificate to ACM..."
CLIENT_CERT_ARN=$(aws acm import-certificate \
  --region "$REGION" \
  --certificate "fileb://${CLIENT_NAME}.crt" \
  --private-key "fileb://${CLIENT_NAME}.key" \
  --certificate-chain fileb://ca.crt \
  --query CertificateArn --output text)

echo ""
echo "Done. Certificates and keys are in: $OUTPUT_DIR"
echo "Keep ${CLIENT_NAME}.crt and ${CLIENT_NAME}.key safe - you need them to configure the VPN client."
echo ""
echo "Server certificate ARN: $SERVER_CERT_ARN"
echo "Client certificate ARN: $CLIENT_CERT_ARN"
echo ""
echo "Use the server certificate ARN for the Client VPN endpoint's server_certificate_arn."
