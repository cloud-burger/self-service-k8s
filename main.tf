module "global_variables" {
  source      = "./modules/global_variables"
  environment = var.environment
}

data "aws_instance" "ec2" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = ["NG-cloud-burger"]
  }

  depends_on = [aws_eks_node_group.cluster_node_group]
}

data "terraform_remote_state" "database_state" {
  backend = "s3"

  config = {
    bucket = "cloud-burger-state"
    key    = "prod/database.tfstate"
    region = "us-east-2"
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
    region = "us-east-2"
  }
}
