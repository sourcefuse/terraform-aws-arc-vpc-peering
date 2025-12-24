terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.6"

  environment = terraform.workspace
  project     = "terraform-aws-arc-vpc-peering"

  extra_tags = {
    Example = "True"
  }
}

# Provider for requester account
provider "aws" {
  region = "us-east-1"
}

# Provider for accepter account
provider "aws" {
  alias  = "accepter"
  region = "us-east-1"
  assume_role {
    role_arn = var.accepter_aws_assume_role_arn
  }
}

# Cross-Account VPC Peering
module "vpc_peering" {
  source = "../../"

  providers = {
    aws.accepter = aws.accepter
  }

  connections = {
    "main" = {
      requester_vpc_id                = var.requester_vpc_id
      accepter_vpc_id                 = var.accepter_vpc_id
      peer_owner_id                   = "630470746897"
      allow_remote_vpc_dns_resolution = true
    }
  }

  tags = module.tags.tags
}
