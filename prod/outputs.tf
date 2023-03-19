output "public_dns" {
  value = module.ec2_instance.public_dns
}

output "cluster_id" {
  value = module.eks.cluster_id
}