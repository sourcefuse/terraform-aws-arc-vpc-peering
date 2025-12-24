# AWS Configuration
aws_region = "us-east-1"

# VPC Configuration
requester_vpc_id = "vpc-12345678" 
accepter_vpc_id  = "vpc-87654321" 

# Route Table Configuration - Using private route tables
requester_route_table_ids = ["rtb-abcdef12", "rtb-abcdef21"] #  private route tables
accepter_route_table_ids  = ["rtb-abcdef12", "rtb-abcdef21"]  # custometest-poc private route tables

# CIDR Configuration
requester_destination_cidrs = ["10.11.0.0/16"]  # Route TO accepter VPC CIDR
accepter_destination_cidrs  = ["10.14.0.0/16"] # Route TO requester VPC CIDR
