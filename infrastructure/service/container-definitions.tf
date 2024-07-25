locals {
  service_definition = {
    name  = "ecs-test-service-run"
    image = "${var.ecr_url}:latest"
    portMappings = [
      {
        hostPort      = 80
        containerPort = 80
      }
    ]

    environment = [
      {
        Name  = "STAGE_NAME"
        Value = var.stage_name
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.service.name
        awslogs-region        = "us-west-2"
        awslogs-stream-prefix = "ecs-test"
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "service" {
  name = "test-ecs-logs"
}
