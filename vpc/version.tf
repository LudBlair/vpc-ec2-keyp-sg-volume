terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.79.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "lbwk07-terraform-state-bucket"
    key    = "QA/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}