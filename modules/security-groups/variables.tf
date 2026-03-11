
variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}


variable "vpc_cidr_block" {
  description = "CIDR of the VPC where to create security group"
  type        = string
  default     = null
}