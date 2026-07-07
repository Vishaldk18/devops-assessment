module "network" {
  source = "../../modules/network"

  project_name = var.project_name

  vpc_cidr = "10.1.0.0/16"

  public_subnet_cidrs = [
    "10.1.1.0/24",
    "10.1.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.1.11.0/24",
    "10.1.12.0/24"
  ]

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}


module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

module "ecs" {
  source = "../../modules/ecs"

  project_name = var.project_name

  vpc_id = module.network.vpc_id

  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  alb_sg_id = module.security.alb_sg_id
  ecs_sg_id = module.security.ecs_sg_id
}

module "rds" {
  source = "../../modules/rds"

  project_name       = var.project_name
  private_subnet_ids = module.network.private_subnet_ids
  rds_sg_id          = module.security.rds_sg_id

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password


  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
  db_port           = var.db_port

  instance_class          = "db.t3.micro"
  backup_retention_period = 1
  deletion_protection     = false
}