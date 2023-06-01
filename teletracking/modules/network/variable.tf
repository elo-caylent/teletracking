################################################################################
# VPC
################################################################################

variable "vpc_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.1.128.0/20"
}

variable "vpc_cidr_pod" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.1.160.0/21"
}

################################################################################
# TAG
################################################################################
variable "environment" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mse-poc"
}

variable "costcenter" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mse-poc"
}

variable "space" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mse-poc"
}

variable "serviceline" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mse-poc"
}

variable "dataclassification" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mse-poc"
}

variable "map_migrated" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mig44451"
}



################################################################################
#  Hub Subnets
################################################################################

variable "az" {
  description = "String of availablity zones "
  type        = set(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}


variable "ingress_subnet_cidr_per_az" {
  description = " Mapping of az to ingress subnets"
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.129.0/27", "ap-northeast-1c" = "10.1.129.32/27", "ap-northeast-1d" = "10.1.129.64/27" }
}

variable "fw_subnet_cidr_per_az" {
  description = "Mapping of az to firewall subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.128.0/28", "ap-northeast-1c" = "10.1.128.16/28", "ap-northeast-1d" = "10.1.128.32/28" }
}

variable "tgw_subnet_cidr_per_az" {
  description = "Mapping of az to transit gatway subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.128.48/28", "ap-northeast-1c" = "10.1.128.64/28", "ap-northeast-1d" = "10.1.128.80/28" }
}

variable "prv_subnet_cidr_per_az" {
  description = "Mapping of az to transit gatway subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.128.96/28", "ap-northeast-1c" = "10.1.128.112/28", "ap-northeast-1d" = "10.1.128.128/28" }
}


################################################################################
#  Pod Subnets
################################################################################

variable "az_pod" {
  description = "String of availablity zones "
  type        = set(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "podtgw_subnet_cidr_per_az" {
  description = "Mapping of az to transit gatway subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.160.0/28", "ap-northeast-1c" = "10.1.160.16/28" }
}

variable "web_subnet_cidr_per_az" {
  description = "Mapping of az to web pod subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.160.128/26", "ap-northeast-1c" = "10.1.160.192/26" }
}

variable "app_subnet_cidr_per_az" {
  description = "Mapping of az to app pod subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.160.64/28", "ap-northeast-1c" = "10.1.160.80/28" }
}

variable "db_subnet_cidr_per_az" {
  description = "Mapping of az to database pod subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.161.0/24", "ap-northeast-1c" = "10.1.162.0/24" }
}

################################################################################
#  TGW VPN
################################################################################

/*
variable "role_to_assume" {
  description = "IAM role name to assume (eg. ASSUME-ROLE-HUB)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Map of custom tags for the provisioned resources"
  type        = map(string)
  default     = {}
}

variable "vpn_cgw" {
  description = "Customer gateway basic information"
  type = object({
    bgp_asn         = number
    ip_address      = string
    type            = optional(string, "ipsec.1")
    name            = string
    dynamic_routing = bool
  })
}

variable "vpn_connection_specs" {
  description = "Customer gateway basic information"
  type = object({
    name                       = string
    tunnel1_inside_cidr        = optional(string, "")
    tunnel2_inside_cidr        = optional(string, "")
    tunnel1_preshared_key      = optional(string, "")
    tunnel2_preshared_key      = optional(string, "")
    static_routes_destinations = optional(list(string), [])
  })
}

variable "tgw_vpn_custome_routes" {
  description = "Customer gateway basic information"
  type = list(object(
    {
      destination_cidr_block = optional(string, null)
      blackhole              = optional(bool, null)
      destination_attachment = optional(string, null)
  }))
}

variable "tgw_vpn_propagated_routes" {
  description = "Customer gateway basic information"
  type = object(
    {
      origin_attachments = optional(list(string), null)
  })
}

variable "transit_gateway_hub_id" {
  description = "Id of the Transit Gateway to attach the VPN to"
  type        = string
}
*/
################################################################################
#  TGW ROUTING
################################################################################
/*
variable "tgw_routing_information" {
  description = "A list of objects containing the routing information per attachement id"
  type = list(object({
            rt_name = optional(string, null)
            attachment_id = optional(string, null)
            transit_gateway_hub_id = optional(string, null)
            tgw_custome_routes = optional(list(object(
            {
              destination_cidr_block = optional(string, null)
              blackhole              = optional(bool, null)
              destination_attachment = optional(string, null)
            })), null)
            tgw_propagated_routes = optional(list(object({origin_attachments = optional(list(string), null)})), null)
          }))
}
*/
#EC2#
variable "ami_id" {
  description = "default ami for cms ec2 resources "
  type        = string
  default     = "ami-0b7dd7b9e977b2b85"
}

variable "instance_type" {
  description = "default instance type for ec2 resources "
  type        = string
  default     = "t3.xlarge"
}
variable "volume_sizes" {
  description = "default volume size for ec2 resources "
  type        = string
  default     = "256"
}

variable "volume_types" {
  description = "default volume type for ec2 resources "
  type        = string
  default     = "gp3"
}

variable "iops" {
  description = "default iops type for ec2 resources "
  type        = string
  default     = "3000"
}

################################################################################
#  Elastic Load Balancers
################################################################################

variable "use_new_eips" {
  description = "Defines weather or not to use new fixed public IPv4 IP addresses for the NLB listeners"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "Defines weather the load balancer is application or Network type"
  type        = string
  default     = "network"
}

variable "sip_ports" {
  description = "Ports used for the SIP connection to IVR"
  type        = list(number)
  default     = [5060, 49100, 49101, 49102, 49103, 49104, 49105, 49106, 49107, 49108, 49109, 49110, 49111, 49112, 49113, 49114, 49115, 49116, 49117, 49118, 49119, 49120, 49121, 49122, 49123, 49124, 49125, 49126, 49127, 49128, 49129]
}

variable "web_ingress_nlb_listener_certificate_arn" {
  description = "The ARN of the ACM certificate used for the TLS listener of the web ingress NLB for HTTPS connection"
  type        = string
  default     = "" #Example: "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
}

variable "ip_address_position" {
  description = "Defines the IP Address position within a CIDR to use i.e: CIDR = 192.168.1.128/25, ip_address_position = 13; IP address result = 192.168.1.141"
  type        = number
  default     = 6
}

variable "prod_rtls_listener_certificate_arn" {
  description = "The ARN of the ACM certificate used for the TLS listener of the PROD app server NLB for RTLS connection"
  type        = string
  default     = "" #Example: "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
}

variable "test_rtls_listener_certificate_arn" {
  description = "The ARN of the ACM certificate used for the TLS listener of the TEST app server NLB for RTLS connection"
  type        = string
  default     = "" #Example: "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
}

variable "hub_alb_listener_certificate_arn" {
  description = "The ARN of the ACM certificate used for the HTTPS listener of the HUB ALB"
  type        = string
  default     = "" #Example: "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
}

variable "pod_alb_listener_certificate_arn" {
  description = "The ARN of the ACM certificate used for the HTTPS listener of the POD ALB"
  type        = string
  default     = "" #Example: "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
}

#RDS#
/*
variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}

variable "instance_use_identifier_prefix" {
  description = "Determines whether to use `identifier` as is or create a unique identifier beginning with `identifier` as the specified prefix"
  type        = bool
  default     = false
}

variable "custom_iam_instance_profile" {
  description = "RDS custom iam instance profile"
  type        = string
  default     = null
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = null
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter"
  type        = string
  default     = null
}

variable "storage_throughput" {
  description = "Storage throughput value for the DB instance. See `notes` for limitations regarding this variable for `gp3`"
  type        = number
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used. Be sure to use the full ARN, not a key alias."
  type        = string
  default     = null
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate"
  type        = string
  default     = null
}

variable "license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  type        = string
  default     = null
}

variable "replica_mode" {
  description = "Specifies whether the replica is in either mounted or open-read-only mode. This attribute is only supported by Oracle instances. Oracle replicas operate in open-read-only mode unless otherwise specified"
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or not the mappings of AWS Identity and Access Management (IAM) accounts to database accounts are enabled"
  type        = bool
  default     = false
}

variable "domain" {
  description = "The ID of the Directory Service Active Directory domain to create the instance in"
  type        = string
  default     = null
}

variable "domain_iam_role_name" {
  description = "(Required if domain is provided) The name of the IAM role to be used when making API calls to the Directory Service"
  type        = string
  default     = null
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = null
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05"
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier_prefix" {
  description = "The name which is prefixed to the final snapshot on cluster destroy"
  type        = string
  default     = "final"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = null
}

variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = null
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = null
}

variable "password" {
  description = <<EOF
  Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file.
  The password provided will not be used if the variable create_random_password is set to true.
  EOF
  type        = string
  default     = null
  sensitive   = true
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero"
  type        = string
  default     = null
}

variable "monitoring_role_name" {
  description = "Name of the IAM role which will be created when create_monitoring_role is enabled"
  type        = string
  default     = "rds-monitoring-role"
}

variable "monitoring_role_use_name_prefix" {
  description = "Determines whether to use `monitoring_role_name` as is or create a unique identifier beginning with `monitoring_role_name` as the specified prefix"
  type        = bool
  default     = false
}

variable "monitoring_role_description" {
  description = "Description of the monitoring IAM role"
  type        = string
  default     = null
}

variable "create_monitoring_role" {
  description = "Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  type        = bool
  default     = false
}

variable "monitoring_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the monitoring IAM role"
  type        = string
  default     = null
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = null
}

variable "blue_green_update" {
  description = "Enables low-downtime updates using RDS Blue/Green deployments."
  type        = map(string)
  default     = {}
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = null
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = null
}

variable "restore_to_point_in_time" {
  description = "Restore to a point in time (MySQL is NOT supported)"
  type        = map(string)
  default     = null
}

variable "s3_import" {
  description = "Restore from a Percona Xtrabackup in S3 (only MySQL is supported)"
  type        = map(string)
  default     = null
}

variable "db_instance_tags" {
  description = "Additional tags for the DB instance"
  type        = map(string)
  default     = {}
}

variable "db_option_group_tags" {
  description = "Additional tags for the DB option group"
  type        = map(string)
  default     = {}
}

variable "db_parameter_group_tags" {
  description = "Additional tags for the  DB parameter group"
  type        = map(string)
  default     = {}
}

variable "db_subnet_group_tags" {
  description = "Additional tags for the DB subnet group"
  type        = map(string)
  default     = {}
}

# DB subnet group
variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  default     = false
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = null
}

variable "db_subnet_group_use_name_prefix" {
  description = "Determines whether to use `subnet_group_name` as is or create a unique name beginning with the `subnet_group_name` as the prefix"
  type        = bool
  default     = true
}

variable "db_subnet_group_description" {
  description = "Description of the DB subnet group to create"
  type        = string
  default     = null
}


# DB parameter group
variable "create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
  default     = true
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
  default     = null
}

variable "parameter_group_use_name_prefix" {
  description = "Determines whether to use `parameter_group_name` as is or create a unique name beginning with the `parameter_group_name` as the prefix"
  type        = bool
  default     = true
}

variable "parameter_group_description" {
  description = "Description of the DB parameter group to create"
  type        = string
  default     = null
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = null
}

variable "parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default     = []
}

# DB option group
variable "create_db_option_group" {
  description = "Create a database option group"
  type        = bool
  default     = true
}

variable "option_group_name" {
  description = "Name of the option group"
  type        = string
  default     = null
}

variable "option_group_use_name_prefix" {
  description = "Determines whether to use `option_group_name` as is or create a unique name beginning with the `option_group_name` as the prefix"
  type        = bool
  default     = true
}

variable "option_group_description" {
  description = "The description of the option group"
  type        = string
  default     = null
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = null
}

variable "options" {
  description = "A list of Options to apply"
  type        = any
  default     = []
}

variable "create_db_instance" {
  description = "Whether to create a database instance"
  type        = bool
  default     = true
}

variable "timezone" {
  description = "Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information"
  type        = string
  default     = null
}

variable "character_set_name" {
  description = "The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS and Collations and Character Sets for Microsoft SQL Server for more information. This can only be set on creation"
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)"
  type        = list(string)
  default     = []
}

variable "timeouts" {
  description = "Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times"
  type        = map(string)
  default     = {}
}

variable "option_group_timeouts" {
  description = "Define maximum timeout for deletion of `aws_db_option_group` resource"
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true"
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Valid values are `7`, `731` (2 years) or a multiple of `31`"
  type        = number
  default     = 7
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data"
  type        = string
  default     = null
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}

variable "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  type        = string
  default     = null
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = true
}

variable "create_random_password" {
  description = "Whether to create random password for RDS primary cluster"
  type        = bool
  default     = true
}

variable "random_password_length" {
  description = "Length of random password to create"
  type        = number
  default     = 16
}

variable "network_type" {
  description = "The type of network stack to use"
  type        = string
  default     = null
}
*/
################################################################################
# CloudWatch Log Group
################################################################################

variable "create_cloudwatch_log_group" {
  description = "Determines whether a CloudWatch log group is created for each `enabled_cloudwatch_logs_exports`"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain CloudWatch logs for the DB instance"
  type        = number
  default     = 7
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "putin_khuylo" {
  description = "Do you agree that Putin doesn't respect Ukrainian sovereignty and territorial integrity? More info: https://en.wikipedia.org/wiki/Putin_khuylo!"
  type        = bool
  default     = true
}
