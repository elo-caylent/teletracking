data "aws_availability_zones" "available" {}


################################################################################
# RDS Module   --- ALL VARIABLES VALUES ARE INSIDE TERRAFORM.TFVARS VALUE      #
################################################################################

module "db" {
  source = "./terraform/modules/rds"

  identifier = var.identifier

  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family               # DB parameter group
  major_engine_version = var.major_engine_version # DB option group
  instance_class       = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  # Encryption at rest is not available for DB instances running SQL Server Express Edition
  storage_encrypted = var.storage_encrypted

  username = var.username
  port     = var.port

  multi_az               = var.multi_az ##set to true to enable multi-az
  db_subnet_group_name   = module.db_subnet_group.db_subnet_group_id
  vpc_security_group_ids = [aws_security_group.db_sg_pod.id] #this will get security group id from the resource created in this current module.

  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group     = var.create_cloudwatch_log_group

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_monitoring_role                = var.create_monitoring_role
  monitoring_interval                   = var.monitoring_interval

  options                   = var.options
  create_db_parameter_group = var.create_db_parameter_group
  license_model             = var.license_model
  timezone                  = var.timezone
  character_set_name        = var.character_set_name

  tags = local.tags
}

module "db_disabled" {
  source = "./terraform/modules/rds"

  identifier = "${local.name}-disabled"

  create_db_instance        = false
  create_db_parameter_group = false
  create_db_option_group    = false
}

################################################################################
# RDS - DB Subnet Group                                                        #
################################################################################


module "db_subnet_group" {
  source = "./terraform/modules/rds/modules/db_subnet_group"

  name        = local.name
  description = var.db_subnet_group_description
  subnet_ids  = local.db_subnets_ids

  tags = local.tags
}



