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

provider "aws" {
  alias  = "accepter"
  region = "us-east-1"
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

# Single Account VPC Peering
module "vpc_peering" {
  source = "../../"

  providers = {
    aws.accepter = aws.accepter
  }

  connections = {
    "main" = {
      requester_vpc_id                = "vpc-0e6c09980580ecbf6"
      accepter_vpc_id                 = "vpc-0c2174e558f2678c8"
      allow_remote_vpc_dns_resolution = false
    }
  }

  tags = module.tags.tags
}
