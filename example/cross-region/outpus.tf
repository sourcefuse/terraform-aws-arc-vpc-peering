output "peering_connection_id" {
  description = "The ID of the VPC peering connection"
  value       = module.vpc_peering.peering_connection_ids["us-east-to-eu-west"]
}

output "peering_status" {
  description = "The status of the VPC peering connection"
  value       = module.vpc_peering.peering_connection_status["us-east-to-eu-west"]
}
