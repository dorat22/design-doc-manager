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

module "dev" {
  source = "../modules/base"
  env    = "dev"
}
