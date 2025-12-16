output "peering_connection_id" {
  description = "The ID of the VPC peering connection"
  value       = module.vpc_peering.peering_connection_ids["prod-to-shared"]
}

output "peering_status" {
  description = "The status of the VPC peering connection"
  value       = module.vpc_peering.peering_connection_status["prod-to-shared"]
}

output "acceptance_required" {
  description = "Whether manual acceptance is required"
  value       = var.use_cross_account_role ? "Automatically accepted via cross-account role" : "Manual acceptance required in accepter account"
}
