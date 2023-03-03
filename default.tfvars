aws_region = "eu-north-1"

vpc_cidr = "10.0.0.0/16"

public_cidr_blocks = [ 
    "10.0.1.0/24",
    "10.0.2.0/24",
]

private_cidr_blocks = [ 
    "10.0.3.0/24",
    "10.0.4.0/24",
]

server_cidr_rules = [ 
    {
      description = "SSH rule for server"
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["93.175.223.50/32"]
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

key_name = "devops-task-key"