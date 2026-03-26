variable "project" {
  type        = string
  description = "Name of the project the application belongs to"
  default     = "experiment"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "dev"
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWSregion to deploy in"
}

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

variable "vpc_id" {
  type        = string
  description = "ID of VPC to deploy in."
}

variable "port" {
  type        = number
  description = "Port on which the service will listen."
  default     = 80
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets in which to deploy the service."
}

variable "capacity_provider" {
  description = "Capacity provider for ECS service."
  type        = string
  default     = "FARGATE_SPOT"
}

variable "cpu_arch" {
  description = "CPU architecture for ECS service."
  type        = string
  default     = "X86_64"
}
