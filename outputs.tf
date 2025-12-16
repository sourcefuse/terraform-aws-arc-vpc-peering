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

output "requester_vpc_ids" {
  description = "Map of peering connection names to requester VPC IDs"
  value = {
    for key, connection in aws_vpc_peering_connection.this : key => connection.vpc_id
  }
}

output "accepter_vpc_ids" {
  description = "Map of peering connection names to accepter VPC IDs"
  value = {
    for key, connection in aws_vpc_peering_connection.this : key => connection.peer_vpc_id
  }
}

output "peer_owner_ids" {
  description = "Map of peering connection names to peer owner IDs"
  value = {
    for key, connection in aws_vpc_peering_connection.this : key => connection.peer_owner_id
  }
}
