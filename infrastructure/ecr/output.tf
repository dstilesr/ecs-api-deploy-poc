output "ecr_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "ecr_name" {
  value = aws_ecr_repository.app_repo.name
}

output "ecr_arn" {
  value = aws_ecr_repository.app_repo.arn
}
