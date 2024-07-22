
output "lambda_arn" {
  value = aws_lambda_function.mangum_func.arn
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.mangum_api.id
}

output "invoke_url" {
  value = aws_api_gateway_deployment.lambda_deploy.invoke_url
}

output "docs_url" {
  value = format(
    "%s%s/api-docs/docs",
    aws_api_gateway_deployment.lambda_deploy.invoke_url,
    var.stage_name
  )
}

output "api_key" {
  value     = aws_api_gateway_api_key.key.value
  sensitive = true
}
