provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source      = "./modules/ec2"
  vpc_id      = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id_az1
}

module "rds" {
  source      = "./modules/rds"
  vpc_id      = module.vpc.vpc_id
  db_username = var.db_username
  db_password = var.db_password
  private_subnet_ids = [module.vpc.private_subnet_id_az1, module.vpc.private_subnet_id_az2]
  app_sg_id = module.ec2.app_sg_id
}

module "api_gateway" {
  source        = "./modules/api_gateway"
  private_ip    = module.ec2.app_private_ip
}

output "bastion_public_ip" {
  value = module.ec2.bastion_public_ip
}

# Output the API Gateway URL
output "api_gateway_url" {
  value = "https://${module.api_gateway.api_invoke_url}/app"
}

