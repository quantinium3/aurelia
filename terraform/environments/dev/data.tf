data "aws_secretsmanager_secret" "image_updater_git_key" {
  name = "aurelia/image-updater/git-ssh-key"
}

data "aws_acm_certificate" "vpn_server" {
  domain = "server"
  types  = ["IMPORTED"]
}

data "aws_route53_zone" "public" {
  name         = "himanshusolo.dev"
  private_zone = false
}
