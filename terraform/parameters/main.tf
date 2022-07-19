resource "random_password" "master_password" {
  length  = 16
  special = false
}


resource "aws_ssm_parameter" "rds-username" {
  name        = "/dev/database/username"
  description = "Master DB User"
  type        = "SecureString"
  value       = var.db_username

  tags = {
    environment = "development"
  }
}

resource "aws_ssm_parameter" "rds-password" {
  name        = "/dev/database/password"
  description = "Master DB Password"
  type        = "SecureString"
  value       = random_password.master_password.result

  tags = {
    environment = "development"
  }
}

resource "aws_ssm_parameter" "rds-connection-string" {
  name        = "/dev/database/connectionstring"
  description = "DB connection string"
  type        = "SecureString"
  value       = var.connection_string

  tags = {
    environment = "development"
  }
}

resource "aws_ssm_parameter" "asg-name" {
  name        = "/dev/asg_refresh/asg_name"
  description = "ASG Name"
  type        = "String"
  value       = var.asg_name

  tags = {
    environment = "development"
  }
}

resource "aws_ssm_parameter" "instance-warmup" {
  name        = "/dev/asg_refresh/instance_warmup"
  description = "Instance warmup time"
  type        = "String"
  value       = var.instance_warmup

  tags = {
    environment = "development"
  }
}

resource "aws_ssm_parameter" "min-healthy-percentage" {
  name        = "/dev/asg_refresh/min_healthy_percentage"
  description = "Minimum percentage required for healthy instances while instance refresh is happening"
  type        = "String"
  value       = var.min_healthy_percentage

  tags = {
    environment = "development"
  }
}

resource "aws_ssm_parameter" "asg-refresh-strategy" {
  name        = "/dev/asg_refresh/strategy"
  description = "ASG refresh strategy"
  type        = "String"
  value       = var.asg_refresh_strategy

  tags = {
    environment = "development"
  }
}

