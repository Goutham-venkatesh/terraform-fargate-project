module "vpc" {
  source         = "../../modules/vpc"
  environment    = var.environment
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets= var.private_subnets
}

module "security" {
  source      = "../../modules/security"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

module "ecr" {
  source      = "../../modules/ecr"
  environment = var.environment
}

module "alb" {
  source         = "../../modules/alb"
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg         = module.security.alb_sg
  ecs_sg         = module.security.ecs_sg
}

module "ecs" {
  source = "../../modules/ecs"

  environment          = var.environment
  private_subnets     = module.vpc.private_subnets
  ecs_sg              = module.security.ecs_sg
  target_group_3000   = module.alb.target_group_3000
  target_group_3001   = module.alb.target_group_3001
  patient_ecr_url     = module.ecr.patient_service_repo
  appointment_ecr_url = module.ecr.appointment_service_repo
}