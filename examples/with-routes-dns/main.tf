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

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "accepter"
  region = var.aws_region
}

# VPC Peering with route management and DNS
module "vpc_peering" {
  source = "../../"

  providers = {
    aws.accepter = aws.accepter
  }

  connections = {
    "app-to-data" = {
      requester_vpc_id                = var.requester_vpc_id
      accepter_vpc_id                 = var.accepter_vpc_id
      auto_accept                     = true
      allow_remote_vpc_dns_resolution = true
      manage_routes                   = true
      requester_route_table_ids       = var.requester_route_table_ids
      accepter_route_table_ids        = var.accepter_route_table_ids
      requester_destination_cidrs     = var.requester_destination_cidrs
      accepter_destination_cidrs      = var.accepter_destination_cidrs
    }
  }

  tags = module.tags.tags
}
