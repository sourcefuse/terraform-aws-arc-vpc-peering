locals {

  # Determine connections that need accepter (cross-account only)
  connections_needing_accepter = {
    for key, connection in var.peering_connections : key => connection
    if connection.peer_owner_id != null && connection.peer_region == null
  }
}

# VPC Peering Connections
resource "aws_vpc_peering_connection" "this" {
  for_each = var.peering_connections

  vpc_id        = each.value.requester_vpc_id
  peer_vpc_id   = each.value.accepter_vpc_id
  peer_region   = each.value.peer_region
  peer_owner_id = each.value.peer_owner_id
  auto_accept   = each.value.peer_owner_id == null && each.value.peer_region == null ? coalesce(each.value.auto_accept, var.auto_accept_peering) : false

  # Additional arguments
  requester {
    allow_remote_vpc_dns_resolution = coalesce(each.value.allow_remote_vpc_dns_resolution, var.enable_dns_resolution)
  }

  accepter {
    allow_remote_vpc_dns_resolution = coalesce(each.value.allow_remote_vpc_dns_resolution, var.enable_dns_resolution)
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# VPC Peering Connection Accepter (for cross-account only)
resource "aws_vpc_peering_connection_accepter" "this" {
  for_each = local.connections_needing_accepter

  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id
  auto_accept               = coalesce(each.value.auto_accept, var.auto_accept_peering)
  region                    = each.value.peer_region

  tags = var.tags

  depends_on = [aws_vpc_peering_connection.this]
}

# DNS Resolution Options
resource "aws_vpc_peering_connection_options" "requester" {
  for_each = {
    for key, connection in var.peering_connections : key => connection
    if coalesce(connection.allow_remote_vpc_dns_resolution, var.enable_dns_resolution)
  }

  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [
    aws_vpc_peering_connection.this,
    aws_vpc_peering_connection_accepter.this
  ]
}

resource "aws_vpc_peering_connection_options" "accepter" {
  for_each = {
    for key, connection in var.peering_connections : key => connection
    if coalesce(connection.allow_remote_vpc_dns_resolution, var.enable_dns_resolution) && connection.peer_region == null
  }

  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [
    aws_vpc_peering_connection.this,
    aws_vpc_peering_connection_accepter.this
  ]
}

# Route Management - Requester Routes
resource "aws_route" "requester" {
  for_each = {
    for route_key, route_config in flatten([
      for conn_key, connection in var.peering_connections : [
        for rt_id in connection.requester_route_table_ids : [
          for cidr in connection.requester_destination_cidrs : {
            key                    = "${conn_key}-${rt_id}-${replace(cidr, "/", "_")}"
            connection_key         = conn_key
            route_table_id         = rt_id
            destination_cidr_block = cidr
          }
        ]
      ] if connection.manage_routes
    ]) : route_config.key => route_config
  }

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.value.connection_key].id

  depends_on = [
    aws_vpc_peering_connection.this,
    aws_vpc_peering_connection_accepter.this
  ]
}

# Route Management - Accepter Routes
resource "aws_route" "accepter" {
  for_each = {
    for route_key, route_config in flatten([
      for conn_key, connection in var.peering_connections : [
        for rt_id in connection.accepter_route_table_ids : [
          for cidr in connection.accepter_destination_cidrs : {
            key                    = "${conn_key}-${rt_id}-${replace(cidr, "/", "_")}"
            connection_key         = conn_key
            route_table_id         = rt_id
            destination_cidr_block = cidr
          }
        ]
      ] if connection.manage_routes
    ]) : route_config.key => route_config
  }

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.value.connection_key].id

  depends_on = [
    aws_vpc_peering_connection.this,
    aws_vpc_peering_connection_accepter.this
  ]
}
