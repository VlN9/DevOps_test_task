#==========Vars=for=main.tf==========#
variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

#==========Vars=for=network.tf==========#
variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(any)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_cidr_blocks" {
  description = "CIDR block for private subnets"
  type        = list(any)
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24",
  ]
}

#==========Vars=for=security_groups.tf==========#
variable "server_cidr_rules" {
  description = "list of parametres for server's security group ingress and egress rules. CIDR only"
  type        = list(any)
  default = [
    {
      description = "Egress rule for server"
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

variable "lb_cidr_rules" {
  description = "list of parametres for load_balancer's security group ingress and egress rules. CIDR only"
  type        = list(any)
  default = [
    {
      description = "HTTP rule for load_balancer"
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Egress rule for server"
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

variable "server_connections" {
  description = "list of parametres for server's security group rules. For connection security group to another"
  type        = list(any)
  default = [
    {
      description = "Rule for connection server to load_balancer "
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
    }
  ]
}

variable "database_connections" {
  description = "list of parametres for database's security group rules. For connection security group to another"
  type        = list(any)
  default = [
    {
      description = "Rule for connection database to server"
      type        = "ingress"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
    }
  ]
}

#==========Vars=for=server_and_db.tf==========#
variable "key_name" {
  description = "Key name for SSH connect to server"
}

variable "database_config" {
  description = "Set of configuration for database server"
  type        = map(any)
  default = {
    allocated_storage = 8
    engine            = "mariadb"
    engine_version    = "10.6.5"
    instance_class    = "db.t3.micro"
    db_name           = "wordpress"
    username          = "wordpress"
    password          = "wordpress"
  }
}
