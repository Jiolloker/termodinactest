module "ec2_instance" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  version       = "~> 4.0"
  name          = "jenkins"
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  monitoring    = var.monitoring
  subnet_id     = var.subnet_id
  /*vpc_security_group_ids      = var.vpc_security_group_ids*/
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  associate_public_ip_address = var.ec2_associate_public_ip_address

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 30
    }
  ]
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7EA0A9C3F273FCD8
    sudo apt update -y
    apt-cache policy docker-ce
    sudo apt install docker-ce -y
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker ubuntu
    sudo apt install default-jre -y
    sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' -y
    sudo apt update
    sudo apt install jenkins -y
    sudo apt install nodejs npm -y
    sudo usermod -aG docker jenkins
    sudo systemctl start jenkins
    sudo npm install -g ts-jest
    newgrp docker
    EOF
  /*
  docker run -p 8080:8080 -p 50000:50000 -d -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts 
  docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11
  access docker container logs for jenkins
  
  docker exec -it --user root <container id> bash
  curl https://get.docker.com/ > dockerinstall && chmod 777 dockerinstall && ./dockerinstall 

  sudo chmod 666 /var/run/docker.sock


  sudo docker ps
  sudo docker logs -f <container id>
  docker exec -it <container id> cat /var/lib/jenkins/secrets/initialAdminPassword
  */
  tags = {
    Terraform     = "true"
    "Environment" = var.ec2_environment
  }
}

resource "aws_security_group" "jenkins_sg" {
  name_prefix = "jenkins_sg_"
  description = "Security group for Jenkins EC2 instance"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
