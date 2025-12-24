variable "connections" {
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

# DNS Resolution
variable "dns_resolution" {
  description = "DNS resolution configuration"
  type = object({
    requester_allow_remote_vpc_dns_resolution = optional(bool, true)
    accepter_allow_remote_vpc_dns_resolution  = optional(bool, true)
    enable_dns_resolution                     = optional(bool, false)
  })
  default = {}
}

# Timeouts
variable "timeouts" {
  description = "VPC peering connection timeouts"
  type = object({
    create = optional(string, "3m")
    update = optional(string, "3m")
    delete = optional(string, "5m")
  })
  default = {}
}


# Naming
variable "naming" {
  description = "Naming configuration for resources"
  type = object({
    name        = optional(string, "")
    namespace   = optional(string, "")
    environment = optional(string, "")
    stage       = optional(string, "")
    delimiter   = optional(string, "-")
    attributes  = optional(list(string), [])
    label_order = optional(list(string), ["namespace", "environment", "stage", "name", "attributes"])
  })
  default = {}
}

# Global settings
variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "auto_accept_peering" {
  description = "Automatically accept peering connections (same account only)"
  type        = bool
  default     = true
}
