variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of Kubernetes to run in the EKS cluster"
  type        = string
  default     = "1.24"
}

variable "environment" {
  description = "Environment for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to launch the instance in"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = list(string)
}

variable "cluster_endpoint_private_access" {
  description = "Enable or disable private access to the cluster's Kubernetes API server endpoint. If you disable private access, public access must be enabled. Defaults to false."
  type        = bool
}

variable "cluster_endpoint_public_access" {
  description = "Enable or disable public access to the cluster's Kubernetes API server endpoint. If you disable public access, private access must be enabled. Defaults to true."
  type        = bool
}


