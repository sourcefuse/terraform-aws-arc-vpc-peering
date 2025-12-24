variable "requester_vpc_id" {
  description = "VPC ID in the requester account"
  type        = string
  default     = "vpc-12345678"
}

variable "accepter_vpc_id" {
  description = "VPC ID in the accepter account"
  type        = string
  default     = "vpc-87654321"
}

variable "accepter_aws_assume_role_arn" {
  description = "AWS assume role ARN for accepter account"
  type        = string
  default     = "arn:aws:iam::123456789012:role/CrossAccountRole"
}

