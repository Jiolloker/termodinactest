variable "ec2_associate_public_ip_address" {
  description = "Associate a public IP address with an instance in a VPC"
  type        = bool
}

variable "ami" {
  description = "AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair to use for the instance"
  type        = string
}

variable "ec2_environment" {
  description = "Environment for the EC2 instance"
  type        = string
}

variable "monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
}


variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate"
  type        = list(string)
  /*default = []*/
}
