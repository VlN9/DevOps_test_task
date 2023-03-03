resource "aws_lb_target_group" "this" {
  name        = "wordpresstg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = 80
    healthy_threshold   = 4
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200" # healthcheck is configured on 400code because app require additional setup
  }

  depends_on = [
    aws_instance.this
  ]
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.this.id
  port             = 80

  depends_on = [
    aws_lb_target_group.this
  ]
}

resource "aws_lb" "wordpress" {
  name               = "wordpress"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = aws_subnet.public[*].id

  depends_on = [
    aws_lb_target_group_attachment.this
  ]
}

resource "aws_lb_listener" "wordpress" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
