# Single Account VPC Peering Example

This example demonstrates basic VPC peering within the same AWS account and region using existing VPCs.

## Prerequisites

- Two existing VPCs in the same AWS account and region
- AWS credentials configured

## Configuration

Update the VPC IDs in `main.tf`:

```hcl
peering_connections = {
  "web-to-db" = {
    requester_vpc_id = "vpc-xxxxxxxxx"  # Your first VPC ID
    accepter_vpc_id  = "vpc-yyyyyyyyy"  # Your second VPC ID
    auto_accept      = true
  }
}
```

## Usage

1. Update the VPC IDs with your existing VPCs
2. Configure AWS credentials:
   ```bash
   aws configure
   ```
3. Run terraform:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## What This Example Creates

- A VPC peering connection between two existing VPCs
- Automatic acceptance of the peering connection (same account)

## Key Features Demonstrated

- **Same Account Peering**: No cross-account complexity
- **Auto Accept**: Connection is automatically accepted
- **Existing VPCs**: Uses your existing VPC infrastructure
- **Simple Configuration**: Minimal setup required

## Outputs

- `peering_connection_id`: The ID of the created peering connection
- `peering_status`: The status of the peering connection (should be "active")

## Clean Up

```bash
terraform destroy
```

## Notes

- Both VPCs must be in the same AWS account and region
- VPCs should have non-overlapping CIDR blocks
- Auto-accept works only for same-account peering

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.6 |
| <a name="module_vpc_peering"></a> [vpc\_peering](#module\_vpc\_peering) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peering_connection_id"></a> [peering\_connection\_id](#output\_peering\_connection\_id) | The ID of the VPC peering connection |
| <a name="output_peering_status"></a> [peering\_status](#output\_peering\_status) | The status of the VPC peering connection |
<!-- END_TF_DOCS -->
