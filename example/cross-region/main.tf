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
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu_west"
  region = "us-east-2"
}


# VPC Peering using the module
module "vpc_peering" {
  source = "../../"

  providers = {
    aws = aws.us_east
  }

  peering_connections = {
    "us-east-to-eu-west" = {
      requester_vpc_id = "vpc-0e6c09980580ecbf6"
      accepter_vpc_id  = "vpc-098e55c8fafbdab0e"
      peer_region      = "us-east-2"
      auto_accept      = true
    }
  }

  tags = module.tags.tags
}

# Accepter resource in the peer region (us-east-2)
resource "aws_vpc_peering_connection_accepter" "peer_region" {
  provider                  = aws.eu_west
  vpc_peering_connection_id = module.vpc_peering.peering_connection_ids["us-east-to-eu-west"]
  auto_accept               = true

  tags = {
    Name        = "cross-region-peering-accepter"
    Environment = "production"
    Project     = "cross-region-peering"
    ManagedBy   = "terraform"
  }
}
