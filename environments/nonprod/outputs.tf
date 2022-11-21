# Module: Networking
output "vpc_id" {
  value = module.networking.vpc_id
}

output "vpc_cidr" {
  value = module.networking.vpc_cidr
}

output "public_subnets" {
  value = module.networking.public_subnets
}

# Module: Webserver
output "webserver_alb_dns" {
  value = module.webserver.webserver_alb_dns
}