#==========Server=config==========#
resource "aws_instance" "this" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.aws_region == "eu-north-1" ? "t3.micro" : "t2.micro"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.server.id]
  key_name               = var.key_name

  tags = {
    Name = "Wordpress Server"
  }
}

#==========Database=config===========#
#---RDS-password---#
resource "random_string" "rds_pwd" {
  length = 16
  special = true
  override_special = "!$&"
}

resource "aws_ssm_parameter" "rds_pwd" {
  name = "/task/mariadb"
  description = "Password for wordpress user"
  type = "SecureString"
  value = random_string.rds_pwd.result
}
#------------------#
resource "aws_db_subnet_group" "mariadb" {
  name        = "mariadb_subnet"
  description = "Subnet group  for database"
  subnet_ids  = aws_subnet.private[*].id
}

resource "aws_db_instance" "this" {
  identifier             = "wordpress-db"
  allocated_storage      = var.database_config["allocated_storage"]
  engine                 = var.database_config["engine"]
  engine_version         = var.database_config["engine_version"]
  instance_class         = var.database_config["instance_class"]
  db_name                = var.database_config["db_name"]
  username               = var.database_config["username"]
  password               = data.aws_ssm_parameter.rds_pwd.value
  db_subnet_group_name   = aws_db_subnet_group.mariadb.name
  vpc_security_group_ids = [aws_security_group.database.id]
  apply_immediately      = true
  skip_final_snapshot    = true

  tags = {
    Name = "Wordpress Database"
  }
}
