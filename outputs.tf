output "peering_connection_ids" {
  description = "Map of peering connection names to their IDs"
  value = {
    for key, connection in aws_vpc_peering_connection.this : key => connection.id
  }
}

output "peering_connection_status" {
  description = "Map of peering connection names to their status"
  value = {
    for key, connection in aws_vpc_peering_connection.this : key => connection.accept_status
  }
}

output "peering_connections" {
  description = "Complete peering connection details"
  value = {
    for key, connection in aws_vpc_peering_connection.this : key => {
      id            = connection.id
      status        = connection.accept_status
      vpc_id        = connection.vpc_id
      peer_vpc_id   = connection.peer_vpc_id
      peer_region   = connection.peer_region
      peer_owner_id = connection.peer_owner_id
    }
  }
}

# Simple outputs for single connection
output "connection_id" {
  description = "VPC peering connection ID"
  value       = length(aws_vpc_peering_connection.this) > 0 ? values(aws_vpc_peering_connection.this)[0].id : ""
}

output "accept_status" {
  description = "The status of the VPC peering connection request"
  value       = length(aws_vpc_peering_connection.this) > 0 ? values(aws_vpc_peering_connection.this)[0].accept_status : ""
}
