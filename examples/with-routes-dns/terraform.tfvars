# AWS Configuration
aws_region = "us-east-1"

# VPC Configuration
requester_vpc_id = "vpc-0e6c09980580ecbf6" # arc-poc-vpc (10.12.0.0/16)
accepter_vpc_id  = "vpc-0c2174e558f2678c8" # custometest-poc-vpc (10.0.0.0/16)

# Route Table Configuration - Using private route tables
requester_route_table_ids = ["rtb-06e6b9c3ccfee7093", "rtb-0f5559d9d30517330"] # arc-poc private route tables
accepter_route_table_ids  = ["rtb-0f5811f97fbca9273", "rtb-045c12dc9be8674a4"] # custometest-poc private route tables

# CIDR Configuration
requester_destination_cidrs = ["10.0.0.0/16"]  # Route TO accepter VPC CIDR
accepter_destination_cidrs  = ["10.12.0.0/16"] # Route TO requester VPC CIDR
