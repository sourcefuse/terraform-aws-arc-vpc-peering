output "peering_connection_id" {
  description = "The ID of the VPC peering connection"
  value       = module.vpc_peering.peering_connection_ids["app-to-data"]
}

output "peering_status" {
  description = "The status of the VPC peering connection"
  value       = module.vpc_peering.peering_connection_status["app-to-data"]
}
