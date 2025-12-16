variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "requester_vpc_id" {
  description = "ID of the requester VPC"
  type        = string
}

variable "accepter_vpc_id" {
  description = "ID of the accepter VPC"
  type        = string
}

variable "requester_route_table_ids" {
  description = "List of route table IDs in the requester VPC"
  type        = list(string)
}

variable "accepter_route_table_ids" {
  description = "List of route table IDs in the accepter VPC"
  type        = list(string)
}

variable "requester_destination_cidrs" {
  description = "List of CIDR blocks to route from requester VPC (usually accepter VPC CIDRs)"
  type        = list(string)
}

variable "accepter_destination_cidrs" {
  description = "List of CIDR blocks to route from accepter VPC (usually requester VPC CIDRs)"
  type        = list(string)
}
