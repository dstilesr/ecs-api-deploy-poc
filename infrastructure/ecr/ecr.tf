resource "aws_ecr_repository" "app_repo" {
  name         = "${var.project}-ecr-${var.environment}"
  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "app_repo" {
  repository = aws_ecr_lifecycle_policy.app_repo.id
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.keep_total_images} images"
        selection = {
          countType   = "imageCountMoreThan"
          countNumber = var.keep_total_images
          tagStatus   = "any"
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
