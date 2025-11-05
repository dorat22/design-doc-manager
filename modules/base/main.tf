provider "aws" {
  region = "us-east-1"
}

resource "random_id" "bucket" {
  byte_length = 8
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "${var.project}-${var.env}-bucket"
  tags = {
    "project" = var.project
    "env"     = var.env
  }
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_ecr_repository" "main" {
  name = "${var.project}-${var.env}-repo"
  tags = {
    "project" = var.project
    "env"     = var.env
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_execution" {
  name               = "${var.project}-${var.env}-lambda-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name = "${var.project}-${var.env}-s3-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:ListBucket", "s3:*Object"]
          Effect   = "Allow"
          Resource = "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}"
        },
      ]
    })
  }

  tags = {
    "project" = var.project
    "env"     = var.env
  }
}

resource "aws_lambda_function" "api" {
  function_name = "${var.project}-${var.env}-api-function"
  role          = aws_iam_role.lambda_execution.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.main.repository_url}:latest"

  tags = {
    "project" = var.project
    "env"     = var.env
  }

  architectures = ["arm64"] # NB(dor): Graviton support for better price/performance
}

resource "aws_lambda_function_url" "api" {
  function_name      = aws_lambda_function.api.function_name
  authorization_type = "NONE" # FIXME(dor): Not production ready, needs to use a proper auth system
}



