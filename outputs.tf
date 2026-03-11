output "VPC_id" {
  value       = module.myvpc.vpc_id
  description = "VPC_ID"
}

output "VPC_name" {
  value       = module.myvpc.name
  description = "VPC name"
}

output "public_subnet" {
  value       = module.myvpc.public_subnets
  description = "public subnets"
}
output "private_subnet" {
  value       = module.myvpc.private_subnets
  description = "Private subnets"
}

output "CIDR_block" {
  value       = module.myvpc.vpc_cidr_block
  description = "VPC_CIDR_block"
}

output "bastion_names" {
  description = "names of bastion hosts"
  value       = [for instance in module.ec2_bastion : instance.id]
}

output "ec2_app1_name" {
  description = "names of app1 hosts"
  value       = module.ec2_app1.id
}

output "ec2_app2_name" {
  description = "names of app2 hosts"
  value       = module.ec2_app2.id
}

output "bastion_public_IP" {
  description = "bastion hosts public IP"
  value       = [for instance in module.ec2_bastion : instance.public_ip]
}

output "ec2_app1_private_ip" {
  description = "app1 host private IP"
  value       = module.ec2_app1.private_ip
}

output "ec2_app2_private_ip" {
  description = "app2 host private ip"
  value       = module.ec2_app2.private_ip
}

output "bastion_sg" {
  description = "bastion hosts public IP"
  value       = [for instance in module.ec2_bastion : instance.security_group_id]
}

output "ec2_app1_sg" {
  description = "app1 host sg"
  value       = module.ec2_app1.security_group_id
}

output "ec2_app2_sg" {
  description = "app2 host sg"
  value       = module.ec2_app2.security_group_id
}

output "alb_dns" {
  description = "DNS of ALB"
  value = module.alb.dns_name
}

