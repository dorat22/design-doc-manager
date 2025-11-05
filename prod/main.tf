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
