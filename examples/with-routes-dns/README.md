# VPC Peering with Routes and DNS Example

This example demonstrates a complete VPC peering setup with automatic route management and DNS resolution using the connections map pattern.

## What This Example Creates

- VPC peering connection with:
  - Automatic route creation
  - DNS resolution enabled
  - Route table management

## Configuration

Configure the peering connection using the connections map:

```hcl
connections = {
  "app-to-data" = {
    requester_vpc_id                = var.requester_vpc_id
    accepter_vpc_id                 = var.accepter_vpc_id
    requester_route_table_ids       = var.requester_route_table_ids
    accepter_route_table_ids        = var.accepter_route_table_ids
    requester_destination_cidrs     = var.requester_destination_cidrs
    accepter_destination_cidrs      = var.accepter_destination_cidrs
    allow_remote_vpc_dns_resolution = true
  }
}
```

## Features Demonstrated

- **Route Management**: Automatically creates routes in specified route tables
- **DNS Resolution**: Enables DNS resolution across peered VPCs
- **Complete Connectivity**: Full bidirectional communication setup

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Configuration Details

The module automatically:
1. Creates peering connection between VPCs
2. Adds routes to specified route tables
3. Enables DNS resolution for both VPCs
4. Configures bidirectional connectivity

## Route Configuration

- Routes are created in the specified route tables
- Routes point to the peering connection
- Supports multiple destination CIDRs per VPC

## DNS Resolution

- Instances in requester VPC can resolve DNS names in accepter VPC
- Instances in accepter VPC can resolve DNS names in requester VPC

## Outputs

After successful deployment:

```hcl
peering_connection_ids = {
  "app-to-data" = "pcx-1234567890abcdef0"
}

peering_connection_status = {
  "app-to-data" = "active"
}
```

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

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.6 |
| <a name="module_vpc_peering"></a> [vpc\_peering](#module\_vpc\_peering) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_destination_cidrs"></a> [accepter\_destination\_cidrs](#input\_accepter\_destination\_cidrs) | List of CIDR blocks to route from accepter VPC (usually requester VPC CIDRs) | `list(string)` | n/a | yes |
| <a name="input_accepter_route_table_ids"></a> [accepter\_route\_table\_ids](#input\_accepter\_route\_table\_ids) | List of route table IDs in the accepter VPC | `list(string)` | n/a | yes |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | ID of the accepter VPC | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_requester_destination_cidrs"></a> [requester\_destination\_cidrs](#input\_requester\_destination\_cidrs) | List of CIDR blocks to route from requester VPC (usually accepter VPC CIDRs) | `list(string)` | n/a | yes |
| <a name="input_requester_route_table_ids"></a> [requester\_route\_table\_ids](#input\_requester\_route\_table\_ids) | List of route table IDs in the requester VPC | `list(string)` | n/a | yes |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | ID of the requester VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peering_connection_id"></a> [peering\_connection\_id](#output\_peering\_connection\_id) | The ID of the VPC peering connection |
| <a name="output_peering_status"></a> [peering\_status](#output\_peering\_status) | The status of the VPC peering connection |
<!-- END_TF_DOCS -->
