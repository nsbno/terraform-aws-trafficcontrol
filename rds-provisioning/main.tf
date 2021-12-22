####################################################################################
# Invokes a lambda function to provision databases and roles to an RDS instance
####################################################################################

# Get RDS instance
data "aws_db_instance" rds {
  db_instance_identifier = var.rds_instance_id
}

# Get master password for RDS from SSM
data "aws_ssm_parameter" rds_master_password {
  name = "${var.rds_instance_id}-rds-master-password"
}

# Invoke provisioning lambda
data "aws_lambda_invocation" "lambda_invocation" {
  function_name = "${var.name_prefix}-rds-provisioning"
  input = <<JSON
  {
    "master_username" : "${data.aws_db_instance.rds.master_username}",
    "master_password" : "${data.aws_ssm_parameter.rds_master_password.value}",
    "database" : "${var.database}",
    "username" : "${var.username}",
    "password" : "${var.password}",
    "address" : "${data.aws_db_instance.rds.address}",
    "port" : "${data.aws_db_instance.rds.port}"
  }
  JSON
}