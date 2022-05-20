####################################################################################
# Invokes a lambda function to provision databases and roles to an RDS instance
####################################################################################

locals {
  port = var.rds_instance_id != null ? data.aws_db_instance.rds[0].port : var.port
  database_address = var.rds_instance_id != null ? data.aws_db_instance.rds[0].address : var.address
  master_username = var.rds_instance_id != null ? data.aws_db_instance.rds[0].master_username : var.master_username
  master_password = var.rds_instance_id != null ? data.aws_ssm_parameter.rds_master_password[0].value : var.master_password
}

# Get RDS instance
data "aws_db_instance" rds {
  count = var.rds_instance_id != null ? 1 : 0
  db_instance_identifier = var.rds_instance_id
}

# Get master password for RDS from SSM
data "aws_ssm_parameter" rds_master_password {
  count = var.rds_instance_id != null ? 1 : 0
  name = "${var.rds_instance_id}-rds-master-password"
}

# Invoke provisioning lambda
data "aws_lambda_invocation" "lambda_invocation" {
  function_name = "${var.name_prefix}-rds-provisioning"
  input = <<JSON
  {
    "master_username" : "${local.master_username}",
    "master_password" : "${local.master_password}",
    "database" : "${var.database}",
    "username" : "${var.username}",
    "password" : "${var.password}",
    "address" : "${local.database_address}",
    "port" : "${local.port}"
  }
  JSON
}