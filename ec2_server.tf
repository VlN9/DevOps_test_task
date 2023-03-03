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