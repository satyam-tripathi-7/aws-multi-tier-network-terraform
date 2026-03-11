module "myvpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  version                 = "6.6.0"
  name                    = "myvpc"
  cidr                    = "10.0.0.0/16"
  azs                     = ["ap-south-1a", "ap-south-1b"]
  private_subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets          = ["10.0.10.0/24", "10.0.20.0/24"]
  private_subnet_names    = ["private-subnet-1", "private-subnet=2"]
  public_subnet_names     = ["public-subnet-1", "public-subnet-2"]
  enable_nat_gateway      = true
  enable_dns_support      = true
  map_public_ip_on_launch = true
}