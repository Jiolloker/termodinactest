module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"
  name    = "jenkins"
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids

  associate_public_ip_address = var.ec2_associate_public_ip_address
  ## aqui poner el userdata para instalar jenkins
  user_data = <<-EOF
  #!/bin/bash
  apt-get update -y
  apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release 
  sudo mkdir -m 0755 -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  chmod a+r /etc/apt/keyrings/docker.gpg
  apt-get update -y
  apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
  docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11
  EOF

  tags = {
    Terraform     = "true"
    "Environment" = var.ec2_environment
  }
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}

output "public_dns" {
  value = module.ec2_instance.public_dns
}


/*
# Security Group for Public Bastion Host
module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name        = "public-bastion-sg"
  description = "Security group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = var.vpc_id
  # Ingress Rules & CIDR Block  
  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags = {
    "Terraform" = "true"
    Name = "jenkins_sg"
    "Environment" = var.ec2_environment
  }  
}
*/