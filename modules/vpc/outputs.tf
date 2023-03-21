output "public_subnets_id" {
  value = module.vpc.public_subnets
}

output "vpc_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets_ids" {
  value = module.vpc.private_subnets
}
