############################################
# ECS CLUSTER
############################################

resource "aws_ecs_cluster" "this" {
  name = "${var.environment}-ecs-cluster"

  tags = {
    Name        = "${var.environment}-ecs-cluster"
    Environment = var.environment
  }
}

############################################
# IAM ROLE FOR ECS TASK EXECUTION
############################################

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-ecs-task-execution-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

############################################
# PATIENT SERVICE TASK DEFINITION (PORT 3000)
############################################

resource "aws_ecs_task_definition" "patient_task" {
  family                   = "${var.environment}-patient-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "patient-service"
      image = var.patient_ecr_url

      essential = true

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name        = "${var.environment}-patient-task"
    Environment = var.environment
  }
}

############################################
# APPOINTMENT SERVICE TASK DEFINITION (PORT 3001)
############################################

resource "aws_ecs_task_definition" "appointment_task" {
  family                   = "${var.environment}-appointment-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "appointment-service"
      image = var.appointment_ecr_url

      essential = true

      portMappings = [
        {
          containerPort = 3001
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name        = "${var.environment}-appointment-task"
    Environment = var.environment
  }
}

############################################
# PATIENT SERVICE ECS SERVICE
############################################

resource "aws_ecs_service" "patient_service" {
  name            = "${var.environment}-patient-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.patient_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_sg]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_3000
    container_name   = "patient-service"
    container_port   = 3000
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy
  ]

  tags = {
    Name        = "${var.environment}-patient-service"
    Environment = var.environment
  }
}

############################################
# APPOINTMENT SERVICE ECS SERVICE
############################################

resource "aws_ecs_service" "appointment_service" {
  name            = "${var.environment}-appointment-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.appointment_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_sg]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_3001
    container_name   = "appointment-service"
    container_port   = 3001
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy
  ]

  tags = {
    Name        = "${var.environment}-appointment-service"
    Environment = var.environment
  }
}