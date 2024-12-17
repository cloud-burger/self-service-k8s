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

data "terraform_remote_state" "database_state" {
  backend = "s3"

  config = {
    bucket = "cloud-burger-state"
    key    = "prod/database.tfstate"
    region = "us-east-1"
  }
}

locals {
  aws_vpc_id            = data.terraform_remote_state.database_state.outputs.vpc_id
  aws_public_subnet_id  = data.terraform_remote_state.database_state.outputs.public_subnet_id
  aws_public_subnet2_id = data.terraform_remote_state.database_state.outputs.public_subnet2_id
  aws_private_subnet_id = data.terraform_remote_state.database_state.outputs.private_subnet_id
  aws_rds_public_sg_id  = data.terraform_remote_state.database_state.outputs.rds_public_sg_id
}

provider "aws" {
  region = module.global_variables.aws_region
}

terraform {
  backend "s3" {
    bucket = "cloud-burger-state"
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
