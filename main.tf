data "aws_availability_zones" "available" {
  # Do not include local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "global_variables" {
  source      = "./modules/global_variables"
  environment = var.environment
}

provider "aws" {
  region = module.global_variables.aws_region
}

terraform {
  backend "s3" {
    bucket = "cloud-burger-states"
    key    = "prod/eks.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.34"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.22"
    }
  }
}
