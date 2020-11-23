#global
variable "vpcid" {
  description = "ID of the VPC where to create security group"
  type        = string
}

#ec2
variable "ec2_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}
variable "ec2_name" {
  description = "Name to be used on all resources as prefix"
  type        = string
}
variable "ec2_ami" {
  description = "ID of AMI to use for the instance"
  type        = string
}
variable "ec2_instancetype" {
  description = "The type of instance to start"
  type        = string
}
variable "ec2_subnetid" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = ""
}
variable "ec2_securitygroup" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}
variable "ec2_publicaddress" {
  description = "If true, the EC2 instance will have associated public IP address"
  type        = bool
  default     = null
}
variable "ec2_key" {
  description = "The key name to use for the instance"
  type        = string
  default     = ""
}
variable "ec2_rbd" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(map(string))
  default     = []
}
variable "ec2_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
#sg
variable "sg_name" {
  description = "Name of security group"
  type        = string
}
variable "sgalb_name" {
  description = "Name of security group"
  type        = string
}
variable "sg_description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}
variable "sgalb_description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}
variable "sg_egresscidr" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}
variable "sgalb_egresscidr" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}
variable "sg_ingresscidr" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}
variable "sgalb_ingresscidr" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}
#variable "sgalb_computedingress" {
#  description = "List of computed ingress rules to create where 'source_security_group_id' is used"
#  type        = list(map(string))
#  default     = []
#}
#variable "sg_computedingresscount" {
#  description = "Number of computed ingress rules to create where 'source_security_group_id' is used"
#  type        = number
#  default     = 0
#}
# alb
variable "alb_name" {
  description = "The resource name and Name tag of the load balancer."
  type        = string
  default     = null
}
#variable "alb_sg" {
#  description = "The security groups to attach to the load balancer. e.g. [\"sg-edcd9784\",\"sg-edcd9785\"]"
#  type        = list(string)
#  default     = []
#}
variable "alb_subnets" {
  description = "A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']"
  type        = list(string)
  default     = null
}
variable "alb_httpslistener" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to 0)"
  type        = list(map(string))
  default     = []
}

variable "alb_tcplistener" {
  description = "A list of maps describing the HTTP listeners for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to 0)"
  type        = list(map(string))
  default     = []
}

variable "alb_tg" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port. Optional key/values are in the target_groups_defaults variable."
  type        = any
  default     = []
}

#variable "alb_tg1" {
#  description = "target id of instance"
#  type        = string
  #default     = []
#}
#variable "alb_tg2" {
#  description = "target id of instance"
#  type        = string
  #default     = []
#}
variable "alb_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
