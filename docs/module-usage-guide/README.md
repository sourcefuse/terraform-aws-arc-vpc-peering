# Terraform AWS ARC VPC Peering Module Usage Guide

## Introduction

### Purpose of the Document

This document provides guidelines and instructions for users looking to implement the Terraform AWS ARC VPC Peering module for connecting VPCs in AWS environments.

### Module Overview

The Terraform AWS ARC VPC Peering module provides a secure and modular foundation for deploying VPC Peering connections on AWS. This module supports same-account, cross-account, and cross-region configurations, offering comprehensive connectivity with automatic route management, DNS resolution, and advanced peering options.

### Prerequisites

Before using this module, ensure you have the following:

- AWS credentials configured with appropriate permissions
- Terraform installed (version >= 1.5)
- A working knowledge of AWS VPC, VPC Peering, and Terraform concepts
- Understanding of network routing and DNS concepts

## Getting Started

### Module Source

To use the module in your Terraform configuration, include the following source block:

```hcl
module "vpc_peering" {
  source = "sourcefuse/arc-vpc-peering/aws"
  version = "1.0.0"

  peering_connections = {
    "web-to-db" = {
      requester_vpc_id = "vpc-12345678"
      accepter_vpc_id  = "vpc-87654321"
      auto_accept      = true
    }
  }

  tags = {
    Environment = "production"
    Project     = "networking"
  }
}
```

Refer to the [Terraform Registry](https://registry.terraform.io/modules/sourcefuse/arc-vpc-peering/aws/latest) for the latest version.

### Integration with Existing Terraform Configurations

To integrate the module with your existing Terraform mono repo configuration, follow the steps below:

- Create a new folder in terraform/ named `vpc-peering`
- Create the required files, see the examples to base off of
- Configure with your backend:
   - Create the environment backend configuration file: `config.<environment>.hcl`
   - region: Where the backend resides
   - key: `vpc-peering/terraform.tfstate`
   - bucket: Bucket name where the terraform state will reside
   - dynamodb_table: Lock table so there are not duplicate tfplans in the mix
   - encrypt: Encrypt all traffic to and from the backend

### Required AWS Permissions

Ensure that the AWS credentials used to execute Terraform have the necessary permissions to create, list and modify:

- VPC Peering Connections
- VPC Route Tables and Routes
- VPC DNS Resolution Options
- IAM roles for cross-account peering (if applicable)

## Module Configuration

### Input Variables

For a complete list of input variables, see the README [Inputs](../../README.md#inputs) section.

Key variables include:
- `peering_connections`: Map of VPC peering connections to create
- `tags`: Default tags to apply to all resources
- `name_prefix`: Prefix for resource names
- `enable_dns_resolution`: Enable DNS resolution by default
- `auto_accept_peering`: Automatically accept peering connections

### Output Values

For a complete list of outputs, see the README [Outputs](../../README.md#outputs) section.

Key outputs include:
- `peering_connection_ids`: Map of peering connection names to their IDs
- `peering_connection_status`: Map of peering connection names to their status
- `peering_connections`: Complete peering connection details

## Module Usage

### Basic Usage

For basic usage, see the [single-account example](../../examples/single-account) folder.

This example will create:

- VPC Peering connection between two VPCs in the same account
- Automatic acceptance of the peering connection
- Basic connectivity without route management

### Advanced Usage Examples

#### Cross-Account Peering
See the [cross-account example](https://github.com/sourcefuse/terraform-aws-arc-vpc-peering/examples/cross-account) for:
- Cross-account VPC peering with IAM role assumption
- Manual acceptance workflow
- Proper security configurations

#### Cross-Region Peering
See the [cross-region example](../../examples/cross-region) for:
- Cross-region VPC connectivity
- Regional considerations and limitations

#### Full-Featured Peering
See the [with-routes-dns example](../../examples/with-routes-dns) for:
- Automatic route table management
- DNS resolution configuration
- Complete connectivity setup

### Tips and Recommendations

- The module focuses on provisioning VPC Peering connections with flexible configuration options. The convention-based approach enables downstream services to easily integrate with the peered VPCs.
- Use same-account peering for simple connectivity within your AWS account
- Use cross-account peering for connecting VPCs across different AWS accounts with proper IAM roles
- Use cross-region peering for global connectivity requirements
- Enable route management for automatic connectivity setup
- Consider DNS resolution requirements for your applications

## Troubleshooting

### Common Issues

1. **Cross-Account Permissions**: Ensure proper IAM roles and trust policies for cross-account peering
2. **Route Conflicts**: Verify no overlapping CIDR blocks between peered VPCs
3. **DNS Resolution**: Check that both sides have DNS resolution enabled if required
4. **Auto-Accept Limitations**: Cross-account and cross-region peering cannot use auto-accept

### Reporting Issues

If you encounter a bug or issue, please report it on the [GitHub repository](https://github.com/sourcefuse/terraform-aws-arc-vpc-peering/issues).

## Security Considerations

### AWS VPC Peering Security

Understand the security considerations related to VPC Peering on AWS when using this module:

- VPC Peering connections are not transitive
- Security groups and NACLs still apply to peered traffic
- DNS resolution exposes private DNS names across VPCs
- Route table management affects traffic flow

### Best Practices for AWS VPC Peering

Follow best practices to ensure secure VPC Peering configurations:

- [AWS VPC Peering Security Best Practices](https://docs.aws.amazon.com/vpc/latest/peering/security-groups.html)
- Use least-privilege security group rules
- Implement proper network segmentation
- Monitor peering connection status and traffic
- Use specific route table entries instead of broad CIDR blocks

## Contributing and Community Support

### Contributing Guidelines

Contribute to the module by following the guidelines outlined in the [CONTRIBUTING.md](../../CONTRIBUTING.md) file.

### Reporting Bugs and Issues

If you find a bug or issue, report it on the [GitHub repository](https://github.com/sourcefuse/terraform-aws-arc-vpc-peering/issues).

## License

### License Information

This module is licensed under the Apache 2.0 license. Refer to the [LICENSE](../../LICENSE) file for more details.

### Open Source Contribution

Contribute to open source by using and enhancing this module. Your contributions are welcome!
