output "connection_id" {
  description = "VPC peering connection ID"
  value       = module.vpc_peering.connection_id
}

output "accept_status" {
  description = "The status of the VPC peering connection request"
  value       = module.vpc_peering.accept_status
}
