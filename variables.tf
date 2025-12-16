variable "peering_connections" {
  description = "Map of VPC peering connections to create"
  type = map(object({
    requester_vpc_id = string
    accepter_vpc_id  = string
    peer_region      = optional(string)
    peer_owner_id    = optional(string)
    auto_accept      = optional(bool, true)

    # DNS settings
    allow_remote_vpc_dns_resolution = optional(bool, false)

    # Route management
    manage_routes               = optional(bool, false)
    requester_route_table_ids   = optional(list(string), [])
    accepter_route_table_ids    = optional(list(string), [])
    requester_destination_cidrs = optional(list(string), [])
    accepter_destination_cidrs  = optional(list(string), [])

    # Tags
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_dns_resolution" {
  description = "Enable DNS resolution for all peering connections by default"
  type        = bool
  default     = false
}

variable "auto_accept_peering" {
  description = "Automatically accept peering connections (same account only)"
  type        = bool
  default     = true
}
