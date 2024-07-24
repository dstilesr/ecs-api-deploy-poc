resource "aws_ecr_repository" "app_repo" {
  name         = "ecs-api-test-repository"
  force_delete = true
}
