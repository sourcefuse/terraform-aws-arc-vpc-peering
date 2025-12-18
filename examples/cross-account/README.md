# Cross-Account VPC Peering Example

This example demonstrates VPC peering between two different AWS accounts with two approaches for handling acceptance.

## Prerequisites

- Access to two AWS accounts (requester and accepter)
- VPCs already created in both accounts
- Proper IAM permissions for cross-account peering

## Two Approaches

### Option 1: Manual Acceptance (Simpler)
- No cross-account IAM roles needed
- Peering connection created in "pending-acceptance" state
- Manual acceptance required in accepter account

### Option 2: Automated with Cross-Account Role
- Requires IAM role setup in accepter account
- Fully automated acceptance
- Single Terraform run handles everything

## Setup Instructions

### Option 1: Manual Acceptance

1. **Configure providers** for both accounts:
```hcl
# In terraform.tfvars
requester_vpc_id      = "vpc-12345678"
accepter_vpc_id       = "vpc-87654321"
accepter_account_id   = "123456789012"
use_cross_account_role = false
```

2. **Run Terraform** in requester account:
```bash
terraform apply
```

3. **Manually accept** in accepter account:
```bash
aws ec2 accept-vpc-peering-connection --vpc-peering-connection-id pcx-xxxxxxxxx
```

### Option 2: Automated with IAM Role

1. **First, create IAM role** in accepter account:
```bash
# Deploy iam-role-setup.tf in accepter account first
terraform apply -target=aws_iam_role.vpc_peering_cross_account
```

2. **Configure main setup**:
```hcl
# In terraform.tfvars
requester_vpc_id      = "vpc-12345678"
accepter_vpc_id       = "vpc-87654321"
accepter_account_id   = "123456789012"
use_cross_account_role = true
```

3. **Run Terraform** (will automatically accept):
```bash
terraform apply
```

## Required Variables

Create a `terraform.tfvars` file:

```hcl
requester_vpc_id       = "vpc-12345678"  # VPC ID in requester account
accepter_vpc_id        = "vpc-87654321"  # VPC ID in accepter account  
accepter_account_id    = "123456789012"  # AWS Account ID of accepter
use_cross_account_role = false           # true for automated, false for manual
```

## IAM Role Requirements (Option 2 Only)

The accepter account needs an IAM role with:

1. **Trust Policy**: Allows requester account to assume the role
2. **Permissions**:
   - `ec2:AcceptVpcPeeringConnection`
   - `ec2:DescribeVpcPeeringConnections`
   - `ec2:DescribeVpcs`

See `iam-role-setup.tf` for complete IAM configuration.

## Provider Configuration

### Option 1: Manual (No Role)
```hcl
provider "aws" {
  alias  = "requester"
  region = "us-east-1"
  # Use requester account credentials
}

# No accepter provider needed for manual acceptance
```

### Option 2: Automated (With Role)
```hcl
provider "aws" {
  alias  = "requester"
  region = "us-east-1"
  # Use requester account credentials
}

provider "aws" {
  alias  = "accepter"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::ACCEPTER-ACCOUNT:role/VPCPeeringCrossAccountRole"
  }
}
```

## Security Considerations

1. **Least Privilege**: IAM role has minimal required permissions
2. **External ID**: Use external ID for additional security
3. **Time-Limited**: Consider temporary credentials
4. **Audit**: Monitor cross-account role usage

## Troubleshooting

### Common Issues

1. **Role Not Found**: Ensure IAM role exists in accepter account
2. **Access Denied**: Check trust policy and permissions
3. **Wrong Account**: Verify account IDs are correct
4. **Region Mismatch**: Ensure both VPCs are in same region for same-region peering

## Clean Up

```bash
terraform destroy
```

For Option 2, also clean up the IAM role in accepter account.

## Answer to Your Question

**Cross-account VPC peering can work both ways:**

1. **Without IAM Role**: Simpler setup, manual acceptance required
2. **With IAM Role**: Fully automated, requires IAM role setup in accepter account

The choice depends on your automation requirements and security preferences.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.accepter"></a> [aws.accepter](#provider\_aws.accepter) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.6 |
| <a name="module_vpc_peering"></a> [vpc\_peering](#module\_vpc\_peering) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_peering_connection_accepter.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_account_id"></a> [accepter\_account\_id](#input\_accepter\_account\_id) | AWS Account ID of the accepter | `string` | n/a | yes |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | VPC ID in the accepter account | `string` | n/a | yes |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | VPC ID in the requester account | `string` | n/a | yes |
| <a name="input_use_cross_account_role"></a> [use\_cross\_account\_role](#input\_use\_cross\_account\_role) | Whether to use cross-account IAM role for automatic acceptance | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acceptance_required"></a> [acceptance\_required](#output\_acceptance\_required) | Whether manual acceptance is required |
| <a name="output_peering_connection_id"></a> [peering\_connection\_id](#output\_peering\_connection\_id) | The ID of the VPC peering connection |
| <a name="output_peering_status"></a> [peering\_status](#output\_peering\_status) | The status of the VPC peering connection |
<!-- END_TF_DOCS -->
