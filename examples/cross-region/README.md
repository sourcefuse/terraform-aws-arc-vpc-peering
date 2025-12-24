# Cross-Region VPC Peering Example

This example demonstrates VPC peering between two different AWS regions using existing VPCs.

## Prerequisites

- Two existing VPCs in different AWS regions
- AWS credentials configured with permissions in both regions

## Configuration

The example uses placeholder VPC IDs. Update them in `main.tf`:

```hcl
connections = {
  "main" = {
    requester_vpc_id                = "vpc-12345678"  # Replace with your US East VPC ID
    accepter_vpc_id                 = "vpc-87654321"  # Replace with your US East 2 VPC ID
    peer_region                     = "us-east-2"
    allow_remote_vpc_dns_resolution = true
  }
}
```

## Usage

1. Update the VPC IDs with your existing VPCs in different regions
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

- Cross-region VPC peering connection
- Automatic accepter in the target region
- DNS resolution options for both sides

## Key Features Demonstrated

- **Cross-Region Peering**: Connects VPCs across AWS regions
- **Automatic Accepter**: Module handles accepter side automatically
- **DNS Resolution**: Enables DNS resolution across regions
- **Dual Provider**: Uses different AWS providers for each region

## Outputs

- `peering_connection_ids`: Map of peering connection names to their IDs
- `peering_connection_status`: Map of peering connection names to their status

## Important Considerations

- Cross-region peering incurs data transfer charges
- DNS resolution works across regions when enabled
- Security group rules need to account for cross-region access
- Both regions must support VPC peering

## Clean Up

```bash
terraform destroy
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.eu_west"></a> [aws.eu\_west](#provider\_aws.eu\_west) | 6.25.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.6 |
| <a name="module_vpc_peering"></a> [vpc\_peering](#module\_vpc\_peering) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_peering_connection_accepter.peer_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peering_connection_id"></a> [peering\_connection\_id](#output\_peering\_connection\_id) | The ID of the VPC peering connection |
| <a name="output_peering_status"></a> [peering\_status](#output\_peering\_status) | The status of the VPC peering connection |
<!-- END_TF_DOCS -->
