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

variable "keep_total_images" {
  type        = number
  default     = 5
  description = "Total number of images to keep on ECR (keep latest)."
}
