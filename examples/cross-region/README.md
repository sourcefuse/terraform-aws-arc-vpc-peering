# Cross-Region VPC Peering Example

This example demonstrates VPC peering between two different AWS regions.

## What This Example Creates

- VPC in US East (N. Virginia): `10.1.0.0/16`
- VPC in EU West (Ireland): `10.2.0.0/16`
- Cross-region peering connection between them

## Usage

1. Ensure you have permissions in both regions
2. Run:

```bash
terraform init
terraform plan
terraform apply
```

## Configuration Details

- Requester: US East (us-east-1)
- Accepter: EU West (eu-west-1)
- Auto-accept enabled (same account)

## Important Considerations

- Cross-region peering incurs data transfer charges
- DNS resolution works differently across regions
- Security group rules need to account for cross-region access

## Outputs

- `peering_connection_id`: The ID of the peering connection
- `peering_status`: Status of the connection
- `requester_vpc_cidr`: CIDR of the US East VPC
- `accepter_vpc_cidr`: CIDR of the EU West VPC

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
