variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "requester_vpc_id" {
  description = "ID of the requester VPC"
  type        = string
  default     = "vpc-12345678"
}

variable "accepter_vpc_id" {
  description = "ID of the accepter VPC"
  type        = string
  default     = "vpc-87654321"
}

variable "requester_route_table_ids" {
  description = "List of route table IDs in the requester VPC"
  type        = list(string)
  default     = ["rtb-12345678", "rtb-87654321"]
}

variable "accepter_route_table_ids" {
  description = "List of route table IDs in the accepter VPC"
  type        = list(string)
  default     = ["rtb-abcdef12", "rtb-fedcba21"]
}

variable "requester_destination_cidrs" {
  description = "List of CIDR blocks to route from requester VPC (usually accepter VPC CIDRs)"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "accepter_destination_cidrs" {
  description = "List of CIDR blocks to route from accepter VPC (usually requester VPC CIDRs)"
  type        = list(string)
  default     = ["10.12.0.0/16"]
}
