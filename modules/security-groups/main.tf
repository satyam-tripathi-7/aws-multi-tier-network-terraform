##to be applied on private ec2
resource "aws_security_group" "allow_ssh_from_bastion" {
  name        = "allow_SSH_from_bastion"
  description = "Allow SSH inbound traffic from bastion (VPC CIDR)"
  vpc_id      = var.vpc_id

}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion" {
  security_group_id = aws_security_group.allow_ssh_from_bastion.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

##to be applied on bastion ec2
resource "aws_security_group" "allow_ssh_to_bastion" {
  name        = "allow_SSH_to_bastion"
  description = "Allow SSH inbound traffic to bastion from public internet"
  vpc_id      = var.vpc_id

}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_to_bastion" {
  security_group_id = aws_security_group.allow_ssh_to_bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

##to be applied on ALB"
resource "aws_security_group" "allow_http_to_ALB" {
  name        = "allow_http_to_ALB"
  description = "Allow HTTP inbound traffic from public internet to ALB"
  vpc_id      = var.vpc_id

}

resource "aws_vpc_security_group_ingress_rule" "allow_http_to_ALB" {
  security_group_id = aws_security_group.allow_http_to_ALB.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

##to be applied on private ec2
resource "aws_security_group" "allow_http_from_ALB" {
  name        = "allow_http_from_ALB"
  description = "Allow HTTP inbound traffic from ALB to private intances"
  vpc_id      = var.vpc_id  

}

resource "aws_vpc_security_group_ingress_rule" "allow_http_from_ALB" {
  security_group_id = aws_security_group.allow_http_from_ALB.id
  referenced_security_group_id = aws_security_group.allow_http_to_ALB.id
  #cidr_ipv4         = var.vpc_cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

/*this allows CIDR block reach private instance on port 80
resource "aws_vpc_security_group_ingress_rule" "allow_http_from_ALB" {
  security_group_id = aws_security_group.allow_http_from_ALB.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
*/



locals {
  all_SG = {
    allow_ssh_from_bastion = aws_security_group.allow_ssh_from_bastion.id
    allow_http_to_ALB = aws_security_group.allow_http_to_ALB.id
    allow_ssh_to_bastion = aws_security_group.allow_ssh_to_bastion.id 
    allow_http_from_ALB = aws_security_group.allow_http_from_ALB.id
    
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  for_each = local.all_SG
  security_group_id = each.value
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
