module "ec2_bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "6.3.0"
  for_each               = { for x, subnet_id in module.myvpc.public_subnets : x => subnet_id }
  name                   = "bastion-${each.key}"
  ami                    = data.aws_ami.AMILinux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = false
  subnet_id              = each.value
  vpc_security_group_ids = [module.SG.SG_allow_ssh_to_bastion_id]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_app1" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version = "6.3.0"
  name                   = "instance-app1"
  ami                    = data.aws_ami.AMILinux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = false
  subnet_id              = module.myvpc.private_subnets[0]
  vpc_security_group_ids = [module.SG.SG_allow_http_from_ALB_id, module.SG.SG_allow_ssh_from_bastion_id]
  user_data              = file("app1-install.sh")
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_app2" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version = "6.3.0"
  name                   = "instance-app2"
  ami                    = data.aws_ami.AMILinux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = false
  subnet_id              = module.myvpc.private_subnets[1]
  vpc_security_group_ids = [module.SG.SG_allow_http_from_ALB_id, module.SG.SG_allow_ssh_from_bastion_id]
  user_data              = file("app2-install.sh")
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_ami" "AMILinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}