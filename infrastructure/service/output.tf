output "load_balancer_url" {
  value = aws_lb.alb.dns_name
}

output "load_balancer_arn" {
  value = aws_lb.alb.arn
}

output "service_name" {
  value = aws_ecs_service.task.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.task.arn
}
