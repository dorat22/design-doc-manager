provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-east-1"
}

module "dev" {
  source = "../modules/base"
  env    = "dev"
}
