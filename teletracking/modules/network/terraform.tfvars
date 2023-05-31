### RDS Instance Variables ###
identifier                            = "mse-poc-rds-tf"
engine                                = "sqlserver-web"
engine_version                        = "15.00.4236.7.v1"
family                                = "default.sqlserver-web-15.0"
major_engine_version                  = "15.00"
instance_class                        = "db.t3.large"
allocated_storage                     = 70
max_allocated_storage                 = 100
storage_encrypted                     = true
username                              = "admin"
port                                  = 1433
multi_az                              = false ###SET THIS VARIABLE TO TRUE TO ENABLE MULTI-AZ RDS
db_subnet_group_name                  = "pod-mse-vpc-db-subnet-group"
maintenance_window                    = "mon:06:23-mon:06:53"
backup_window                         = "07:42-08:12"
enabled_cloudwatch_logs_exports       = ["error"]
create_cloudwatch_log_group           = true
backup_retention_period               = 2
skip_final_snapshot                   = true
deletion_protection                   = false
performance_insights_enabled          = false
performance_insights_retention_period = 7
create_monitoring_role                = false
monitoring_interval                   = 0
options                               = []
create_db_parameter_group             = false
license_model                         = "license-included"
timezone                              = ""
character_set_name                    = "SQL_Latin1_General_CP1_CI_AS"


### RDS - DB Subnet Group Variables ###
db_subnet_group_description = "subnet group used by MSE RDS Instance"
subnet_ids                  = ["subnet-09a1fd93d9dfdbf09", "subnet-04edef823d22ad781"]