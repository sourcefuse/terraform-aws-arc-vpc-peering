variable "requester_vpc_id" {
  description = "VPC ID in the requester account"
  type        = string
}

variable "accepter_vpc_id" {
  description = "VPC ID in the accepter account"
  type        = string
}

variable "accepter_account_id" {
  description = "AWS Account ID of the accepter"
  type        = string
}

variable "use_cross_account_role" {
  description = "Whether to use cross-account IAM role for automatic acceptance"
  type        = bool
  default     = false
}
