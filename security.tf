resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name_prefix}${random_id.suffix.hex}nodejs-app-ecs-tasks-sg"
  description = "Allow inbound access from ALB only"
  vpc_id      = var.vpc_id # aws_vpc.main.id 

  ingress {
    protocol        = "tcp"
    from_port       = 5000
    to_port         = 5000
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = [data.aws_vpc.selected.cidr_block]  # Ensure tasks can reach ECR via VPC endpoints
}

}

# Security group for VPC endpoints
resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.name_prefix}${random_id.suffix.hex}vpc-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id #aws_vpc.main.id 

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]  # Restrict to VPC CIDR aws_vpc.main
  }
  ingress {
    description = "Allow ECS tasks access to ECR VPC endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]  # Allow ECS tasks to reach ECR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-vpc-endpoint-sg"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoint.id]
  subnet_ids         = var.private_subnet_ids
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoint.id]
  subnet_ids         = var.private_subnet_ids
  private_dns_enabled = true
}