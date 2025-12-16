terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.6"

  environment = terraform.workspace
  project     = "terraform-aws-arc-sns"

  extra_tags = {
    Example = "True"
  }
}

# VPC Peering using the module with existing VPCs
# Note: Using different VPC IDs for demonstration
# In real usage, ensure both VPCs exist in the same region and account
module "vpc_peering" {
  source = "../../"

  peering_connections = {
    "web-to-db" = {
      requester_vpc_id = "vpc-0e6c09980580ecbf6" # us-east-1 VPC
      accepter_vpc_id  = "vpc-0c2174e558f2678c8" # Replace with your second VPC ID (must be different)
      auto_accept      = true
    }
  }

  tags = module.tags.tags
}
