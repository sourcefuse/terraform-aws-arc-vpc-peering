output "peering_connection_ids" {
  description = "Map of peering connection names to their IDs"
  value       = module.vpc_peering.peering_connection_ids
}

output "peering_connection_status" {
  description = "Map of peering connection names to their status"
  value       = module.vpc_peering.peering_connection_status
}
