# Cross-Account VPC Peering Example

This example demonstrates VPC peering between two different AWS accounts using the connections map pattern.

## Prerequisites

- Access to two AWS accounts (requester and accepter)
- VPCs already created in both accounts
- Proper IAM permissions for cross-account peering

## Configuration

Configure the peering connection using the connections map:

```hcl
connections = {
  "cross-account-peering" = {
    requester_vpc_id              = "vpc-12345678"
    accepter_vpc_id               = "vpc-87654321"
    accepter_account_id           = "123456789012"
    accepter_aws_assume_role_arn  = "arn:aws:iam::123456789012:role/CrossAccountRole"
    allow_remote_vpc_dns_resolution = true
  }
}
```

## Setup Instructions

1. **Create IAM role** in accepter account (if using automated acceptance):
```bash
# Deploy iam-role-setup.tf in accepter account first
terraform apply -target=aws_iam_role.vpc_peering_cross_account
```

2. **Configure variables** in `terraform.tfvars`:
```hcl
connections = {
  "cross-account-peering" = {
    requester_vpc_id              = "vpc-12345678"
    accepter_vpc_id               = "vpc-87654321"
    accepter_account_id           = "123456789012"
    accepter_aws_assume_role_arn  = "arn:aws:iam::123456789012:role/CrossAccountRole"
    allow_remote_vpc_dns_resolution = true
  }
}
```

3. **Run Terraform**:
```bash
terraform init
terraform apply
```

## IAM Role Requirements

The accepter account needs an IAM role with:

1. **Trust Policy**: Allows requester account to assume the role
2. **Permissions**:
   - `ec2:AcceptVpcPeeringConnection`
   - `ec2:DescribeVpcPeeringConnections`
   - `ec2:DescribeVpcs`

See `iam-role-setup.tf` for complete IAM configuration.

## Outputs

After successful deployment:

```hcl
peering_connection_ids = {
  "cross-account-peering" = "pcx-1234567890abcdef0"
}

peering_connection_status = {
  "cross-account-peering" = "active"
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

Also clean up the IAM role in accepter account if no longer needed.
