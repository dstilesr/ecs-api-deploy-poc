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
  }
}
