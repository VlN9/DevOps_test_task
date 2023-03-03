resource "aws_security_group" "server" {
  name = "Server_Security_Group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Server SG"
  }
}

resource "aws_security_group" "database" {
  name = "Database_Security_Group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Database SG"
  }
}

resource "aws_security_group" "load_balancer" {
  name = "Load_balancer_Security_Group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Load Balancer SG"
  }
}

resource "aws_security_group_rule" "server_cidr" {
  count             = length(var.server_cidr_rules)
  description       = element(var.server_cidr_rules, count.index)["description"]
  type              = element(var.server_cidr_rules, count.index)["type"]
  from_port         = element(var.server_cidr_rules, count.index)["from_port"]
  to_port           = element(var.server_cidr_rules, count.index)["to_port"]
  protocol          = element(var.server_cidr_rules, count.index)["protocol"]
  cidr_blocks       = element(var.server_cidr_rules, count.index)["cidr_blocks"]
  security_group_id = aws_security_group.server.id
}

resource "aws_security_group_rule" "lb_cidr" {
  count             = length(var.lb_cidr_rules)
  description       = element(var.lb_cidr_rules, count.index)["description"]
  type              = element(var.lb_cidr_rules, count.index)["type"]
  from_port         = element(var.lb_cidr_rules, count.index)["from_port"]
  to_port           = element(var.lb_cidr_rules, count.index)["to_port"]
  protocol          = element(var.lb_cidr_rules, count.index)["protocol"]
  cidr_blocks       = element(var.lb_cidr_rules, count.index)["cidr_blocks"]
  security_group_id = aws_security_group.load_balancer.id
}

resource "aws_security_group_rule" "server_connections" {
  count                    = length(var.server_connections)
  description              = element(var.server_connections, count.index)["description"]
  type                     = element(var.server_connections, count.index)["type"]
  from_port                = element(var.server_connections, count.index)["from_port"]
  to_port                  = element(var.server_connections, count.index)["to_port"]
  protocol                 = element(var.server_connections, count.index)["protocol"]
  source_security_group_id = aws_security_group.load_balancer.id
  security_group_id        = aws_security_group.server.id
}

resource "aws_security_group_rule" "database_connections" {
  count                    = length(var.database_connections)
  description              = element(var.database_connections, count.index)["description"]
  type                     = element(var.database_connections, count.index)["type"]
  from_port                = element(var.database_connections, count.index)["from_port"]
  to_port                  = element(var.database_connections, count.index)["to_port"]
  protocol                 = element(var.database_connections, count.index)["protocol"]
  source_security_group_id = aws_security_group.server.id
  security_group_id        = aws_security_group.database.id
}
