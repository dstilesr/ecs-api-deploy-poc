locals {
  service_definition = {
    name  = "ecs-test-service-run"
    image = "${var.ecr_url}:latest"
    portMappings = [
      {
        hostPort      = var.port
        containerPort = var.port
      }
    ]

    environment = [
      {
        Name  = "ENVIRONMENT"
        Value = var.environment
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.service.name
        awslogs-region        = var.region
        awslogs-stream-prefix = var.project
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "service" {
  name = "${var.project}-ecs-${var.environment}"
}
