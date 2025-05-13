resource "aws_lb" "app" {
  name               = "nodejs-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
  
  enable_deletion_protection = false

  tags = {
    Environment = "production"
    Application = "nodejs-app"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "nodejs-app-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id #var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    interval            = 30
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 3
    path                = "/health"
    unhealthy_threshold = 2
  }
}
# ALB listener (HTTP → HTTPS redirect recommended)
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  
  # default_action {
  #   type = "redirect"
  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_security_group" "alb" {
  name        = "nodejs-app-alb-sg"
  description = "Allow HTTP/HTTPS inbound traffic"
  vpc_id      = aws_vpc.main.id #var.vpc_id 

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   protocol    = "tcp"
  #   from_port   = 443
  #   to_port     = 443
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "nodejs-app-alb-sg"
  }
}