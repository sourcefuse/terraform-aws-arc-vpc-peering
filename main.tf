terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.0, < 7.0"
      configuration_aliases = [aws.accepter]
    }
  }
}

locals {
  # Generate consistent naming
  enabled = length(var.connections) > 0

  # Create ID for naming
  id = join(var.naming.delimiter, compact([
    var.naming.namespace,
    var.naming.environment,
    var.naming.stage,
    var.naming.name,
    join(var.naming.delimiter, var.naming.attributes)
  ]))

  # Use connections directly
  all_connections = var.connections

  # Determine connections that need accepter
  connections_needing_accepter = {
    for key, connection in local.all_connections : key => connection
    if connection.peer_owner_id != null || connection.peer_region != null
  }

  # Common tags
  common_tags = merge(
    var.tags,
    {
      Name = local.id != "" ? local.id : "vpc-peering"
    }
  )
}

# VPC Peering Connections (Requester side)
resource "aws_vpc_peering_connection" "this" {
  for_each = local.enabled ? local.all_connections : tomap({})

  vpc_id        = each.value.requester_vpc_id
  peer_vpc_id   = each.value.accepter_vpc_id
  peer_region   = each.value.peer_region
  peer_owner_id = each.value.peer_owner_id
  auto_accept   = each.value.peer_owner_id == null && each.value.peer_region == null ? coalesce(each.value.auto_accept, var.auto_accept_peering) : false

  tags = merge(local.common_tags, each.value.tags, {
    Side = "Requester"
  })

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  lifecycle {
    create_before_destroy = true
  }
}

# VPC Peering Connection Accepter (Accepter side - cross-region same account only)
resource "aws_vpc_peering_connection_accepter" "this" {
  for_each = local.enabled ? {
    for key, connection in local.connections_needing_accepter : key => connection
    if connection.peer_owner_id == null && connection.peer_region != null
  } : {}

  provider = aws.accepter

  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id
  auto_accept               = coalesce(each.value.auto_accept, var.auto_accept_peering)

  tags = merge(local.common_tags, each.value.tags, {
    Side = "Accepter"
  })

  depends_on = [aws_vpc_peering_connection.this]
}

# VPC Peering Connection Accepter (Cross-account)
resource "aws_vpc_peering_connection_accepter" "cross_account" {
  for_each = local.enabled ? {
    for key, connection in local.connections_needing_accepter : key => connection
    if connection.peer_owner_id != null
  } : {}

  provider = aws.accepter

  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id
  auto_accept               = coalesce(each.value.auto_accept, var.auto_accept_peering)

  tags = merge(local.common_tags, each.value.tags, {
    Side = "Accepter"
  })

  depends_on = [aws_vpc_peering_connection.this]
}

# DNS Resolution Options - Requester
resource "aws_vpc_peering_connection_options" "requester" {
  for_each = {
    for key, conn in local.all_connections : key => conn
    if local.enabled && coalesce(
      conn.allow_remote_vpc_dns_resolution,
      var.dns_resolution.enable_dns_resolution,
      var.dns_resolution.requester_allow_remote_vpc_dns_resolution
    )
  }

  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [
    aws_vpc_peering_connection.this,
    aws_vpc_peering_connection_accepter.this,
    aws_vpc_peering_connection_accepter.cross_account
  ]
}

# DNS Resolution Options - Accepter
resource "aws_vpc_peering_connection_options" "accepter" {
  for_each = {
    for key, connection in local.all_connections : key => connection
    if local.enabled && coalesce(
      connection.allow_remote_vpc_dns_resolution,
      var.dns_resolution.enable_dns_resolution,
      var.dns_resolution.accepter_allow_remote_vpc_dns_resolution
    )
  }

  provider = aws.accepter

  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [
    aws_vpc_peering_connection.this,
    aws_vpc_peering_connection_accepter.this,
    aws_vpc_peering_connection_accepter.cross_account
  ]
}

# Route Management - Requester Routes
resource "aws_route" "requester" {
  for_each = local.enabled ? {
    for route_key, route_config in flatten([
      for conn_key, connection in local.all_connections : [
        for rt_id in coalesce(connection.requester_route_table_ids, []) : [
          for cidr in coalesce(connection.requester_destination_cidrs, []) : {
            key                    = "${conn_key}-${rt_id}-${replace(cidr, "/", "_")}"
            connection_key         = conn_key
            route_table_id         = rt_id
            destination_cidr_block = cidr
          }
        ]
      ] if coalesce(connection.manage_routes, false)
    ]) : route_config.key => route_config
  } : {}

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.value.connection_key].id

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  depends_on = [
    aws_vpc_peering_connection.this,
    aws_vpc_peering_connection_accepter.this,
    aws_vpc_peering_connection_accepter.cross_account
  ]
}

# Route Management - Accepter Routes
resource "aws_route" "accepter" {
  for_each = local.enabled ? {
    for route_key, route_config in flatten([
      for conn_key, connection in local.all_connections : [
        for rt_id in coalesce(connection.accepter_route_table_ids, []) : [
          for cidr in coalesce(connection.accepter_destination_cidrs, []) : {
            key                    = "${conn_key}-${rt_id}-${replace(cidr, "/", "_")}"
            connection_key         = conn_key
            route_table_id         = rt_id
            destination_cidr_block = cidr
          }
        ]
      ] if coalesce(connection.manage_routes, false)
    ]) : route_config.key => route_config
  } : {}

  provider = aws.accepter

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.value.connection_key].id

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  depends_on = [
    aws_vpc_peering_connection.this,
    aws_vpc_peering_connection_accepter.this,
    aws_vpc_peering_connection_accepter.cross_account
  ]
}
