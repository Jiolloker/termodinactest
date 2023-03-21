module "vpc" {
  source                 = "../modules/vpc"
  vpc_name               = var.vpc_name
  vpc_cidr               = var.vpc_cidr
  vpc_azs                = var.vpc_azs
  vpc_private_subnets    = var.vpc_private_subnets
  vpc_public_subnets     = var.vpc_public_subnets
  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
  environment            = var.environment
  vpc_create_igw         = var.vpc_create_igw
  cluster_name           = var.cluster_name
}

module "ec2_instance" {
  source                          = "../modules/jenkins"
  depends_on                      = [module.vpc]
  ami                             = var.ami
  instance_type                   = var.instance_type
  key_name                        = var.key_name
  ec2_environment                 = var.ec2_environment
  monitoring                      = var.monitoring
  ec2_associate_public_ip_address = var.ec2_associate_public_ip_address
  subnet_id                       = module.vpc.public_subnets_id[0]
  vpc_security_group_ids          = [module.vpc.vpc_security_group_id]
  vpc_id                          = module.vpc.vpc_id
}


module "eks" {
  source                          = "../modules/eks"
  depends_on                      = [module.vpc]
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  vpc_id                          = module.vpc.vpc_id
  subnet_id                       = module.vpc.private_subnets_ids
  environment                     = var.environment
}
