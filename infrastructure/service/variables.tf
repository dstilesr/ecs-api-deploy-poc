variable "task_memory" {
  type        = number
  description = "Memory to assign to ECS task."
  default     = 256
}

variable "ecr_url" {
  type = string
  description = "URL of ECR repository where image is stored."
}

variable "stage_name" {
  type        = string
  description = "Name of deployment stage."
  default     = "dev"
}
