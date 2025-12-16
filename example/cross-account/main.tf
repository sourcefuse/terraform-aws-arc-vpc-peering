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
  alias  = "requester"
  region = "us-east-1"
  # Configure with requester account credentials
}

# Provider for accepter account (Option 2: with cross-account role)
provider "aws" {
  alias  = "accepter"
  region = "us-east-1"

  # Option 2: Assume cross-account role in accepter account
  assume_role {
    role_arn = "arn:aws:iam::630470746897:role/test-vpc"
  }
}

# Data sources to get existing VPCs
# data "aws_vpc" "requester" {
#   provider = aws.requester
#   id       = var.requester_vpc_id
# }

# data "aws_vpc" "accepter" {
#   provider = aws.accepter
#   id       = var.accepter_vpc_id
# }

# VPC Peering using the module (runs in requester account)
module "vpc_peering" {
  source = "../../"

  providers = {
    aws = aws.requester
  }

  peering_connections = {
    "prod-to-shared" = {
      requester_vpc_id = var.requester_vpc_id
      accepter_vpc_id  = var.accepter_vpc_id
      peer_owner_id    = var.accepter_account_id
      auto_accept      = false
    }
  }

  tags = module.tags.tags
}

# Option 2: Accepter resource using cross-account role
resource "aws_vpc_peering_connection_accepter" "accepter" {
  count = var.use_cross_account_role ? 1 : 0

  provider                  = aws.accepter
  vpc_peering_connection_id = module.vpc_peering.peering_connection_ids["prod-to-shared"]
  auto_accept               = true

  tags = {
    Name        = "cross-account-peering-accepter"
    Environment = "production"
    Project     = "cross-account-peering"
    ManagedBy   = "terraform"
  }
}
