output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "eks_managed_node_groups" {
  value = module.eks.eks_managed_node_groups
}