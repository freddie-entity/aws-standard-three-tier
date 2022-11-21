module "networking" {
  source   = "../../modules/infrastructure/networking"
  app_name = var.app_name
  cidr     = var.cidr
  azs      = var.azs
}

module "webserver" {
  source = "../../modules/infrastructure/webserver"

  ec2_instance_type = "t2.micro"
  vpc_id            = module.networking.vpc_id
  private_subnets    = module.networking.private_subnets
  public_subnets    = module.networking.public_subnets
}

# module "databases" {
#   source = "../../modules/infrastructure/databases"
# }