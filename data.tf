data "aws_availability_zones" "available" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_ssm_parameter" "rds_pwd" {
  name = "/task/mariadb"

  depends_on = [
    aws_ssm_parameter.rds_pwd
  ]
}