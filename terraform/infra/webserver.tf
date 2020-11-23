module "sg" {
  source                                                   = "../modules/security-group"
  name                                                     = var.sg_name
  description                                              = var.sg_description
  vpc_id                                                   = var.vpcid
  egress_with_cidr_blocks                                  = var.sg_egresscidr
  ingress_with_cidr_blocks                                 = var.sg_ingresscidr
  computed_ingress_with_source_security_group_id           = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "allow 80 port for load balancer"
      source_security_group_id = module.sgalb.this_security_group_id
    },
  ]
  number_of_computed_ingress_with_source_security_group_id = 1 
}
module "sgalb" {
  source                                                   = "../modules/security-group"
  name                                                     = var.sgalb_name
  description                                              = var.sgalb_description
  vpc_id                                                   = var.vpcid
  egress_with_cidr_blocks                                  = var.sgalb_egresscidr
  ingress_with_cidr_blocks                                 = var.sgalb_ingresscidr
 # number_of_computed_ingress_with_source_security_group_id = 1
}
module "ec2" {
  source                      = "../modules/ec2-instance"
  instance_count              = var.ec2_count
  name                        = var.ec2_name
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instancetype
  subnet_id                   = var.ec2_subnetid
  vpc_security_group_ids      = [module.sg.this_security_group_id]
  associate_public_ip_address = var.ec2_publicaddress
  key_name                    = var.ec2_key
  root_block_device           = var.ec2_rbd
  tags                        = var.ec2_tags
}
module "alb" {
  source             = "../modules/alb"
  name               = var.alb_name
  targetid0          = module.ec2.id[0]
  load_balancer_type = "application"
  vpc_id             = var.vpcid
  security_groups    = [module.sgalb.this_security_group_id]
  subnets            = var.alb_subnets
  http_tcp_listeners = var.alb_tcplistener
  https_listeners    = var.alb_httpslistener
  target_groups      = var.alb_tg
  tags               = var.alb_tags
}
