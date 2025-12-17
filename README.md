![Module Structure](./static/terraform-aws-arc-vpc-peering.png)

# [terraform-aws-arc-vpc-peering](https://github.com/sourcefuse/terraform-aws-arc-vpc-peering)

<a href="https://github.com/sourcefuse/terraform-aws-arc-vpc-peering/releases/latest"><img src="https://img.shields.io/github/release/sourcefuse/terraform-aws-arc-vpc-peering.svg?style=for-the-badge" alt="Latest Release"/></a> <a href="https://github.com/sourcefuse/terraform-aws-arc-vpc-peering/commits"><img src="https://img.shields.io/github/last-commit/sourcefuse/terraform-aws-arc-vpc-peering.svg?style=for-the-badge" alt="Last Updated"/></a> ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

[![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=sourcefuse_terraform-aws-arc-vpc-peering&token=6f397a571887a0cf7b2d8435f88fc1e6cc58d0c7)](https://sonarcloud.io/summary/new_code?id=sourcefuse_terraform-aws-arc-vpc-peering)

## Overview

SourceFuse AWS Reference Architecture (ARC) Terraform module for managing AWS VPC Peering connections.

## Features

- **Single Module Design**: Handles both requester and accepter sides automatically
- **Multi-Account Support**: Cross-account VPC peering with automatic accepter handling
- **Multi-Region Support**: Cross-region VPC peering capabilities  
- **Automatic Route Management**: Optional route table updates for seamless connectivity
- **DNS Resolution**: Configurable DNS resolution across peered VPCs
- **Flexible Configuration**: Both simple and advanced input patterns
- **Production Ready**: Comprehensive validation, error handling, and best practices
- **Security Best Practices**: Encryption, tagging, and protection settings
- **High Availability**: Multi-AZ route table support
- **Conditional Resources**: Smart resource creation based on configuration

## Usage Patterns

### Simple Cross-Account Peering

```hcl
module "vpc_peering" {
  source = "sourcefuse/arc-vpc-peering/aws"

  providers = {
    aws.accepter = aws.accepter
  }

  connections = {
    "main" = {
      requester_vpc_id                          = "vpc-12345678"
      accepter_vpc_id                           = "vpc-87654321"
      accepter_aws_assume_role_arn              = "arn:aws:iam::123456789012:role/CrossAccountRole"
      requester_allow_remote_vpc_dns_resolution = true
      accepter_allow_remote_vpc_dns_resolution  = true
    }
  }

  # Standard naming
  namespace   = "eg"
  environment = "prod"
  stage       = "staging"
  name        = "app"

  tags = {
    Project = "MyProject"
  }
}
```

### Advanced Multi-Connection Pattern

```hcl
module "vpc_peering" {
  source = "sourcefuse/arc-vpc-peering/aws"

  providers = {
    aws.accepter = aws.accepter
  }

  connections = {
    "web-to-app" = {
      requester_vpc_id = "vpc-web123"
      accepter_vpc_id  = "vpc-app456"
      auto_accept      = true

      manage_routes = true
      requester_route_table_ids = ["rtb-web123"]
      accepter_route_table_ids  = ["rtb-app456"]
      requester_destination_cidrs = ["10.2.0.0/16"]
      accepter_destination_cidrs  = ["10.1.0.0/16"]

      allow_remote_vpc_dns_resolution = true
    }

    "app-to-db" = {
      requester_vpc_id = "vpc-app456"
      accepter_vpc_id  = "vpc-db789"
      peer_owner_id    = "123456789012"
      auto_accept      = false

      manage_routes = true
      requester_route_table_ids = ["rtb-app456"]
      accepter_route_table_ids  = ["rtb-db789"]
      requester_destination_cidrs = ["10.3.0.0/16"]
      accepter_destination_cidrs  = ["10.2.0.0/16"]
    }
  }

  tags = {
    Environment = "production"
    Project     = "multi-tier-architecture"
  }
}
```

## Provider Configuration

### Same Account, Same Region
```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "accepter"
  region = "us-east-1"
}
```

### Cross-Region
```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "accepter"
  region = "us-west-2"
}
```

### Cross-Account
```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "accepter"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::123456789012:role/CrossAccountRole"
  }
}
```

## Examples

The `examples/` directory contains complete, working examples:

- **[single-account](./examples/single-account/)**: Basic same-account VPC peering
- **[cross-account](./examples/cross-account/)**: Cross-account peering with IAM roles
- **[cross-region](./examples/cross-region/)**: Cross-region VPC connectivity
- **[with-routes-dns](./examples/with-routes-dns/)**: Full-featured peering with route management and DNS

## Migration Guide

This module provides a simple interface for VPC peering across different scenarios:

```hcl
# Simple same-account peering
module "vpc_peering" {
  source = "sourcefuse/arc-vpc-peering/aws"

  connections = {
    "main" = {
      requester_vpc_id = "vpc-12345678"
      accepter_vpc_id  = "vpc-87654321"
    }
  }

  tags = {
    Environment = "production"
  }
}

# Cross-account peering
module "vpc_peering" {
  source = "sourcefuse/arc-vpc-peering/aws"

  providers = {
    aws.accepter = aws.accepter
  }

  connections = {
    "main" = {
      requester_vpc_id             = "vpc-12345678"
      accepter_vpc_id              = "vpc-87654321"
      accepter_aws_assume_role_arn = "arn:aws:iam::123456789012:role/CrossAccountRole"
    }
  }

  tags = {
    Environment = "production"
  }
}
```

## Security Best Practices

- **Least Privilege**: Only create routes for specific CIDR blocks that need connectivity
- **Cross-Account IAM**: Ensure proper IAM roles for cross-account peering
- **Network Segmentation**: Use security groups and NACLs in addition to routing
- **DNS Resolution**: Only enable when required for your use case
- **Route Table Management**: Be explicit about which route tables to update
- **CIDR Planning**: Ensure no overlapping CIDR blocks between peered VPCs
- **Monitoring**: Set up CloudWatch metrics for peering connection status
- **Tagging**: Use consistent tagging for cost allocation and management

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.26.0 |
| <a name="provider_aws.accepter"></a> [aws.accepter](#provider\_aws.accepter) | 6.26.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.cross_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_aws_assume_role_arn"></a> [accepter\_aws\_assume\_role\_arn](#input\_accepter\_aws\_assume\_role\_arn) | Accepter AWS assume role ARN | `string` | `""` | no |
| <a name="input_accepter_enabled"></a> [accepter\_enabled](#input\_accepter\_enabled) | Flag to enable/disable accepter side | `bool` | `true` | no |
| <a name="input_accepter_region"></a> [accepter\_region](#input\_accepter\_region) | Accepter AWS region | `string` | `""` | no |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | Accepter VPC ID | `string` | `""` | no |
| <a name="input_auto_accept_peering"></a> [auto\_accept\_peering](#input\_auto\_accept\_peering) | Automatically accept peering connections (same account only) | `bool` | `true` | no |
| <a name="input_connections"></a> [connections](#input\_connections) | Map of VPC peering connections to create | <pre>map(object({<br/>    requester_vpc_id = string<br/>    accepter_vpc_id  = string<br/>    peer_region      = optional(string)<br/>    peer_owner_id    = optional(string)<br/>    auto_accept      = optional(bool, true)<br/><br/>    # DNS settings<br/>    allow_remote_vpc_dns_resolution = optional(bool, false)<br/><br/>    # Route management<br/>    manage_routes               = optional(bool, false)<br/>    requester_route_table_ids   = optional(list(string), [])<br/>    accepter_route_table_ids    = optional(list(string), [])<br/>    requester_destination_cidrs = optional(list(string), [])<br/>    accepter_destination_cidrs  = optional(list(string), [])<br/><br/>    # Tags<br/>    tags = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_dns_resolution"></a> [dns\_resolution](#input\_dns\_resolution) | DNS resolution configuration | <pre>object({<br/>    requester_allow_remote_vpc_dns_resolution = optional(bool, true)<br/>    accepter_allow_remote_vpc_dns_resolution  = optional(bool, true)<br/>    enable_dns_resolution                     = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_manage_routes"></a> [manage\_routes](#input\_manage\_routes) | Enable route management for peering connections | `bool` | `false` | no |
| <a name="input_naming"></a> [naming](#input\_naming) | Naming configuration for resources | <pre>object({<br/>    name        = optional(string, "")<br/>    namespace   = optional(string, "")<br/>    environment = optional(string, "")<br/>    stage       = optional(string, "")<br/>    delimiter   = optional(string, "-")<br/>    attributes  = optional(list(string), [])<br/>    label_order = optional(list(string), ["namespace", "environment", "stage", "name", "attributes"])<br/>  })</pre> | `{}` | no |
| <a name="input_requester_region"></a> [requester\_region](#input\_requester\_region) | Requester AWS region | `string` | `""` | no |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | Requester VPC ID | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | VPC peering connection timeouts | <pre>object({<br/>    create = optional(string, "3m")<br/>    update = optional(string, "3m")<br/>    delete = optional(string, "5m")<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accept_status"></a> [accept\_status](#output\_accept\_status) | The status of the VPC peering connection request |
| <a name="output_connection_id"></a> [connection\_id](#output\_connection\_id) | VPC peering connection ID |
| <a name="output_peering_connection_ids"></a> [peering\_connection\_ids](#output\_peering\_connection\_ids) | Map of peering connection names to their IDs |
| <a name="output_peering_connection_status"></a> [peering\_connection\_status](#output\_peering\_connection\_status) | Map of peering connection names to their status |
| <a name="output_peering_connections"></a> [peering\_connections](#output\_peering\_connections) | Complete peering connection details |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning  
This project uses a `.version` file at the root of the repo which the pipeline reads from and does a git tag.  

When you intend to commit to `main`, you will need to increment this version. Once the project is merged,
the pipeline will kick off and tag the latest git commit.  

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
  ```sh
  pre-commit install
  ```

### Versioning

while Contributing or doing git commit please specify the breaking change in your commit message whether its major,minor or patch

For Example

```sh
git commit -m "your commit message #major"
```
By specifying this , it will bump the version and if you don't specify this in your commit message then by default it will consider patch and will bump that accordingly

### Tests
- Tests are available in `test` directory
- Configure the dependencies
  ```sh
  cd test/
  go mod init github.com/sourcefuse/terraform-aws-arc-vpc-peering
  go get github.com/gruntwork-io/terratest/modules/terraform
  ```
- Now execute the test  
  ```sh
  go test -timeout  30m
  ```

## Authors

This project is authored by:
- SourceFuse ARC Team
