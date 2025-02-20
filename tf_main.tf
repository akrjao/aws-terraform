terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = var.aws_region.code
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}