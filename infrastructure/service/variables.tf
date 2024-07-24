variable "task_memory" {
  type        = number
  description = "Memory to assign to ECS task."
  default     = 512
}

variable "task_cpu" {
  type        = number
  description = "CPU to assign to task."
  default     = 256
}

variable "ecr_url" {
  type        = string
  description = "URL of ECR repository where image is stored."
}

variable "stage_name" {
  type        = string
  description = "Name of deployment stage."
  default     = "dev"
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC to deploy in."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets in which to deploy the service."
}
