output "SG_allow_ssh_from_bastion_id" {
  description = "The ID of the security group"
  value       = aws_security_group.allow_ssh_from_bastion.id
}

output "SG_allow_ssh_to_bastion_id" {
  description = "The ID of the security group"
  value       = aws_security_group.allow_ssh_to_bastion.id
}


output "SG_allow_http_from_ALB_id" {
  description = "The ID of the security group"
  value       = aws_security_group.allow_http_from_ALB.id
}

output "SG_allow_http_to_ALB_id" {
  description = "The ID of the security group"
  value       = aws_security_group.allow_http_to_ALB.id
}
