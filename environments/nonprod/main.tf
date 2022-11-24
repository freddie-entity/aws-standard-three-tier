module "networking" {
  source   = "../../modules/infrastructure/networking"
  app_name = var.app_name
  cidr     = var.cidr
  azs      = var.azs
}

module "presentation_tier" {
  source = "../../modules/infrastructure/app"

  tier                = "web"
  lb_internal         = false
  ec2_instance_type   = "t2.micro"
  vpc_id              = module.networking.vpc_id
  public_subnets      = module.networking.public_subnets
  application_subnets = module.networking.private_subnets
  security_group_ids  = [module.networking.presentation_tier_security_group_id]
}

module "bastion" {
  source = "../../modules/infrastructure/bastion"

  ec2_instance_type  = "t2.micro"
  ec2_key_pair_name  = "docker"
  security_group_ids = [module.networking.bastion_security_group_id]
  application_subnets          = module.networking.public_subnets
}

module "application_tier" {
  source = "../../modules/infrastructure/app"

  tier                = "app"
  lb_internal         = true
  ec2_instance_type   = "t2.micro"
  vpc_id              = module.networking.vpc_id
  public_subnets      = module.networking.public_subnets
  application_subnets = module.networking.public_subnets
  security_group_ids  = [module.networking.application_tier_security_group_id]
}



module "data_tier" {
  source = "../../modules/infrastructure/databases"

  tier                = "app"
  db_subnets = module.networking.public_subnets
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  engine               = var.engine
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  vpc_security_group_ids = [module.networking.databasetier_security_group_id]
}