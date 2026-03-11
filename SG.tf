module "SG" {
  source         = "./modules/security-groups"
  vpc_cidr_block = module.myvpc.vpc_cidr_block
  vpc_id         = module.myvpc.vpc_id

}