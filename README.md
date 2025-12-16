![Module Structure](./static/terraform-aws-arc-vpc-peering.png)

# [terraform-aws-arc-vpc-peering](https://github.com/sourcefuse/terraform-aws-arc-vpc-peering)

<a href="https://github.com/sourcefuse/terraform-aws-arc-vpc-peering/releases/latest"><img src="https://img.shields.io/github/release/sourcefuse/terraform-aws-arc-vpc-peering.svg?style=for-the-badge" alt="Latest Release"/></a> <a href="https://github.com/sourcefuse/terraform-aws-arc-vpc-peering/commits"><img src="https://img.shields.io/github/last-commit/sourcefuse/terraform-aws-arc-vpc-peering.svg?style=for-the-badge" alt="Last Updated"/></a> ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

[![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=sourcefuse_terraform-aws-arc-vpc-peering&token=6f397a571887a0cf7b2d8435f88fc1e6cc58d0c7)](https://sonarcloud.io/summary/new_code?id=sourcefuse_terraform-aws-arc-vpc-peering)

## Overview

SourceFuse AWS Reference Architecture (ARC) Terraform module for managing AWS VPC Peering connections.

## Features

- **Multi-Account Support**: Cross-account VPC peering with automatic accepter handling
- **Multi-Region Support**: Cross-region VPC peering capabilities  
- **Automatic Route Management**: Optional route table updates for seamless connectivity
- **DNS Resolution**: Configurable DNS resolution across peered VPCs
- **Flexible Configuration**: Map-based input for multiple peering connections
- **Production Ready**: Comprehensive validation, error handling, and best practices
- **Security Best Practices**: Encryption, tagging, and protection settings
- **High Availability**: Multi-AZ route table support
- **Conditional Resources**: Smart resource creation based on configuration

## Usage

### Basic Same-Account Peering

```hcl
module "vpc_peering" {
  source = "sourcefuse/arc-vpc-peering/aws"

  peering_connections = {
    "web-to-db" = {
      requester_vpc_id = "vpc-12345678"
      accepter_vpc_id  = "vpc-87654321"
      auto_accept      = true
    }
  }

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

### Cross-Account Peering

```hcl
module "vpc_peering" {
  source = "sourcefuse/arc-vpc-peering/aws"

  peering_connections = {
    "prod-to-shared" = {
      requester_vpc_id = "vpc-12345678"
      accepter_vpc_id  = "vpc-87654321"
      peer_owner_id    = "123456789012"
      auto_accept      = false
    }
  }

  tags = {
    Environment = "production"
    Project     = "cross-account-peering"
  }
}
```

### Cross-Region Peering with Routes and DNS

```hcl
module "vpc_peering" {
  source = "sourcefuse/arc-vpc-peering/aws"

  peering_connections = {
    "us-east-to-eu-west" = {
      requester_vpc_id = "vpc-12345678"
      accepter_vpc_id  = "vpc-87654321"
      peer_region      = "eu-west-1"

      # Route management
      manage_routes = true
      requester_route_table_ids = ["rtb-12345678", "rtb-87654321"]
      accepter_route_table_ids  = ["rtb-11111111", "rtb-22222222"]
      requester_destination_cidrs = ["10.1.0.0/16"]
      accepter_destination_cidrs  = ["10.2.0.0/16"]

      # DNS resolution
      allow_remote_vpc_dns_resolution = true
    }
  }

  tags = {
    Environment = "production"
    Project     = "global-connectivity"
  }
}
```

### Advanced Multi-Connection Setup

```hcl
module "vpc_peering" {
  source = "sourcefuse/arc-vpc-peering/aws"

  peering_connections = {
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
      auto_accept      = true

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

## Examples

The `examples/` directory contains complete, working examples:

- **[single-account](./examples/single-account/)**: Basic same-account VPC peering
- **[cross-account](./examples/cross-account/)**: Cross-account peering with IAM roles
- **[cross-region](./examples/cross-region/)**: Cross-region VPC connectivity
- **[with-routes-dns](./examples/with-routes-dns/)**: Full-featured peering with route management and DNS

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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_accept_peering"></a> [auto\_accept\_peering](#input\_auto\_accept\_peering) | Automatically accept peering connections (same account only) | `bool` | `true` | no |
| <a name="input_enable_dns_resolution"></a> [enable\_dns\_resolution](#input\_enable\_dns\_resolution) | Enable DNS resolution for all peering connections by default | `bool` | `false` | no |
| <a name="input_peering_connections"></a> [peering\_connections](#input\_peering\_connections) | Map of VPC peering connections to create | <pre>map(object({<br/>    requester_vpc_id = string<br/>    accepter_vpc_id  = string<br/>    peer_region      = optional(string)<br/>    peer_owner_id    = optional(string)<br/>    auto_accept      = optional(bool, true)<br/><br/>    # DNS settings<br/>    allow_remote_vpc_dns_resolution = optional(bool, false)<br/><br/>    # Route management<br/>    manage_routes               = optional(bool, false)<br/>    requester_route_table_ids   = optional(list(string), [])<br/>    accepter_route_table_ids    = optional(list(string), [])<br/>    requester_destination_cidrs = optional(list(string), [])<br/>    accepter_destination_cidrs  = optional(list(string), [])<br/><br/>    # Tags<br/>    tags = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accepter_vpc_ids"></a> [accepter\_vpc\_ids](#output\_accepter\_vpc\_ids) | Map of peering connection names to accepter VPC IDs |
| <a name="output_peer_owner_ids"></a> [peer\_owner\_ids](#output\_peer\_owner\_ids) | Map of peering connection names to peer owner IDs |
| <a name="output_peering_connection_ids"></a> [peering\_connection\_ids](#output\_peering\_connection\_ids) | Map of peering connection names to their IDs |
| <a name="output_peering_connection_status"></a> [peering\_connection\_status](#output\_peering\_connection\_status) | Map of peering connection names to their status |
| <a name="output_peering_connections"></a> [peering\_connections](#output\_peering\_connections) | Complete peering connection details |
| <a name="output_requester_vpc_ids"></a> [requester\_vpc\_ids](#output\_requester\_vpc\_ids) | Map of peering connection names to requester VPC IDs |
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
