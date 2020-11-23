terraform {
  backend "s3" {
    bucket = "assignment-terraform-state-file"
    key    = "statefile.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region = "us-east-1"
}

##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "source" {
  id = "vpc-0feeb955e0d57741b"
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.source.id}"
}
module "infra" {
  source         = "../infra/"
  sg_name        = "web-app-security"
  sg_description = "Security groups for application server"
  vpcid          = "vpc-0feeb955e0d57741b"
  sg_egresscidr = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  sg_ingresscidr = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ansible-bastion"
      cidr_blocks = "10.0.0.0/16"
    }
  ]
  sgalb_name        = "app-alb"
  sgalb_description = "Security groups for application-nginx"
  sgalb_egresscidr = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  sgalb_ingresscidr = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "inbound to outside traffic"
      cidr_blocks = "0.0.0.0/0"
    }

  ]
  ec2_count         = 1
  ec2_name          = "application-web"
  ec2_ami           = "ami-0817d428a6fb68645"
  ec2_instancetype  = "t2.medium"
  ec2_publicaddress = true
  ec2_subnetid      = "subnet-0d7c4ead880e8c553"
  ec2_key           = "test"
  ec2_rbd = [
    {
      volume_type = "gp2"
      volume_size = 10
    },
  ]
  ec2_tags = {
    Name        = "Application-web-server"
 }
  alb_name    = "application-web"
  alb_subnets = ["subnet-0d7c4ead880e8c553", "subnet-02698457a33237eb0"]
  alb_tcplistener = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  alb_tg = [
    {
      name_prefix          = "appweb"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]
  alb_tags = {
    Name       = "app-alb"
}
}
