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
  alias  = "us_east_2"
  region = "us-east-2"
}

# Cross-Region VPC Peering
module "vpc_peering" {
  source = "../../"

  providers = {
    aws          = aws.us_east
    aws.accepter = aws.us_east_2
  }

  connections = {
    "main" = {
      requester_vpc_id                          = "vpc-0e6c09980580ecbf6"
      accepter_vpc_id                           = "vpc-098e55c8fafbdab0e"
      peer_region                               = "us-east-2"
      requester_allow_remote_vpc_dns_resolution = true
      accepter_allow_remote_vpc_dns_resolution  = true
    }
  }

  tags = module.tags.tags
}
