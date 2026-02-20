resource "aws_lb" "alb" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name        = "${var.environment}-alb"
    Environment = var.environment
  }
}

#############################################
# Target Group - Patient Service (Port 3000)
#############################################

resource "aws_lb_target_group" "tg_3000" {
  name        = "${var.environment}-tg-3000"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    port                = "3000"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = "200"
  }

  tags = {
    Name        = "${var.environment}-tg-3000"
    Environment = var.environment
  }
}

#############################################
# Target Group - Appointment Service (Port 3001)
#############################################

resource "aws_lb_target_group" "tg_3001" {
  name        = "${var.environment}-tg-3001"
  port        = 3001
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    port                = "3001"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = "200"
  }

  tags = {
    Name        = "${var.environment}-tg-3001"
    Environment = var.environment
  }
}

#############################################
# Listener - Port 80 (Default → Patient Service)
#############################################

resource "aws_lb_listener" "listener_80" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_3000.arn
  }
}

#############################################
# Listener - Port 3001 → Appointment Service
#############################################

resource "aws_lb_listener" "listener_3001" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 3001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_3001.arn
  }
}