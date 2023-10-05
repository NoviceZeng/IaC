locals {
  /*vm_list = {
    for hostname in csvdecode(file("vm_list.csv")) :
    hostname["hostname"] => hostname
  }*/
  sg_rules = csvdecode(file("sg_rules.csv"))
}
/**********************************************
VPC and Subnets
***********************************************/
resource "aws_vpc" "prod_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    env = "prod"
    Name = "prod_vpc"
  }
}

resource "aws_subnet" "business1_subnet" {
  for_each = "${var.sh_network_prod_subnets}"
  vpc_id     = aws_vpc.prod_vpc.id
  cidr_block = "${each.value.subnet_ip}"

  tags = {
    Name = "${each.value.subnet_name}"
  }
}

/**********************************************
Security Group
***********************************************/
resource "aws_security_group" "prod_vpc_sg" {
  count = length(var.security_group)
  description = var.security_group[count.index].description
  vpc_id      = aws_vpc.prod_vpc.id

  tags = {
    Name = var.security_group[count.index].name
  }
}

resource "aws_security_group_rule" "prod_vpc_sg_rules" {
  count = length(local.sg_rules)
  type              = local.sg_rules[count.index].type
  from_port         = local.sg_rules[count.index].from_port
  to_port           = local.sg_rules[count.index].to_port
  protocol          = local.sg_rules[count.index].protocol
  cidr_blocks       = ["${local.sg_rules[count.index].cidr_blocks}",]
  security_group_id = local.sg_rules[count.index].security_group_id
  description       = local.sg_rules[count.index].description
}