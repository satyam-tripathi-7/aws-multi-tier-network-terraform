variable "region" {
  description = "region where resource will be created"
  type        = string

}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
}

variable "instance_type" {
  description = "type of ec2 instance"
  type        = string
  default     = "t3.micro"

}

variable "key_name" {
  description = "AWS EC2 key pair name"
  type        = string
}