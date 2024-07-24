
resource "aws_ecs_cluster" "cluster" {
  name = "ecs-example-cluster"
}

resource "aws_ecs_task_definition" "task" {
  container_definitions    = jsonencode([local.service_definition])
  family                   = "ecs-test-definition"
  memory                   = tostring(var.task_memory)
  cpu                      = tostring(var.task_cpu)
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task_exec_role.arn
}

resource "aws_ecs_service" "task" {
  name            = "ecs-test-service"
  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 1
    weight            = 100
  }

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.service.id]
  }

  load_balancer {
    container_name   = local.service_definition.name
    container_port   = 80
    target_group_arn = aws_lb_target_group.ecs_target.arn
  }
}
