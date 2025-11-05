provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = ""
    key     = ""
    region  = ""
    profile = ""
  }
}

module "prod" {
  source = "../modules/base"
  env    = "prod"
}
