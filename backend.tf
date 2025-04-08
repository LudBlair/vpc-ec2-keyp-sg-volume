terraform {
  backend "s3" {
    bucket = "lbwk07-terraform-state-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}