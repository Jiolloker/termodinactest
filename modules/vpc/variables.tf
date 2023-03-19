variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_azs" {
  description = "Availability zones for the VPC"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "Private subnets for the VPC"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "Public subnets for the VPC"
  type        = list(string)
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateway for the VPC"
  type        = bool
}

variable "vpc_single_nat_gateway" {
  description = "Enable single NAT Gateway for the VPC"
  type        = bool
  default = true
}

variable "vpc_enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  type        = bool
  default = true
}

variable "environment" {
  description = "Environment for the VPC"
  type        = string
}
