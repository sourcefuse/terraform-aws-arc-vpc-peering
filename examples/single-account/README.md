# Single Account VPC Peering Example

This example demonstrates basic VPC peering within the same AWS account and region.

## Prerequisites

- Two existing VPCs in the same AWS account and region
- AWS credentials configured

## Configuration

The example uses placeholder VPC IDs. Update them in `main.tf`:

```hcl
connections = {
  "main" = {
    requester_vpc_id                = "vpc-12345678"  # Replace with your VPC ID
    accepter_vpc_id                 = "vpc-87654321"  # Replace with your VPC ID
    allow_remote_vpc_dns_resolution = false
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

- `peering_connection_ids`: Map of peering connection names to their IDs
- `peering_connection_status`: Map of peering connection names to their status

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
