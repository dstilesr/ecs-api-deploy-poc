variable "lambda_memory" {
  type        = number
  description = "Memory to assign to lambda function (MB)."
  default     = 256
}

variable "stage_name" {
  type        = string
  description = "Name of deployment stage."
  default     = "dev"
}
