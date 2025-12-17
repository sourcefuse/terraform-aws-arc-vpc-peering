variable "requester_vpc_id" {
  description = "VPC ID in the requester account"
  type        = string
  default     = "vpc-0e6c09980580ecbf6"
}

variable "accepter_vpc_id" {
  description = "VPC ID in the accepter account"
  type        = string
  default     = "vpc-064703a783487931f"
}

variable "accepter_aws_assume_role_arn" {
  description = "AWS assume role ARN for accepter account"
  type        = string
  default     = "arn:aws:iam::630470746897:role/test-vpc"
}
