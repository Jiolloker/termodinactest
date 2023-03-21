## VPC
vpc_name               = "staging-eks-vpc"
vpc_cidr               = "40.0.0.0/16"
vpc_azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_private_subnets    = ["40.0.1.0/24", "40.0.2.0/24", "40.0.3.0/24"]
vpc_public_subnets     = ["40.0.101.0/24", "40.0.102.0/24", "40.0.103.0/24"]
vpc_enable_nat_gateway = true
environment            = "staging"
vpc_create_igw         = true

## EC2 Instance
ec2_associate_public_ip_address = true
ami                             = "ami-0557a15b87f6559cf"
instance_type                   = "t3.small"
key_name                        = "my_key_pair"
ec2_environment                 = "staging"
monitoring                      = false

## EKS Cluster
cluster_name                    = "staging-eks-webdemo"
cluster_version                 = "1.24"
cluster_endpoint_private_access = true
cluster_endpoint_public_access  = true

## Profile and Region
aws_profile = "onepanman"
aws_region  = "us-east-1"