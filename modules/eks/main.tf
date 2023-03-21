module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_id
  control_plane_subnet_ids        = var.subnet_id
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  tags = {
    Terraform = "true"
  "Environment" = var.environment }
}

resource "aws_security_group_rule" "eks_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.cluster_security_group_id
}

# Create IAM role for EKS node group
resource "aws_iam_role" "eks_node_group" {
  name = "eks-node-group-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach IAM policy to the EKS node group role
resource "aws_iam_role_policy_attachment" "eks_node_group" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}

# Create the EKS managed node group
resource "aws_eks_node_group" "eks_workers" {
  depends_on = [
    module.eks, aws_iam_role.eks_node_group, aws_iam_role_policy_attachment.eks_node_group
  ]
  cluster_name    = var.cluster_name
  node_group_name = "eks-workers"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.subnet_id

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 30

  tags = {
    Terraform     = "true"
    "Environment" = var.environment
  }
}

resource "aws_eks_addon" "coredns" {
  depends_on = [
    module.eks, aws_eks_node_group.eks_workers
  ]
  cluster_name      = var.cluster_name
  addon_name        = "coredns"
  addon_version     = "v1.8.7-eksbuild.4" #e.g., previous version v1.8.7-eksbuild.2 and the new version is v1.8.7-eksbuild.3
  resolve_conflicts = "OVERWRITE"
}