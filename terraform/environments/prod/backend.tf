terraform {
  backend "s3" {
    bucket       = "terraform-state-aurelia-253260001114-ap-south-1"
    key          = "prod/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
