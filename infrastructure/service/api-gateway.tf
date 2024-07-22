
resource "aws_api_gateway_rest_api" "mangum_api" {
  name        = "MangumExampleAPI"
  description = "Example API to try Mangum + FastAPI!"
}


resource "aws_api_gateway_resource" "base_api_resource" {
  parent_id   = aws_api_gateway_rest_api.mangum_api.root_resource_id
  path_part   = "api"
  rest_api_id = aws_api_gateway_rest_api.mangum_api.id
}

# Methods that need permissions
locals {
  http_methods = ["GET", "POST"]
}

#################################################
# API Endpoints Integration
#################################################
resource "aws_api_gateway_resource" "api_resource" {
  parent_id   = aws_api_gateway_resource.base_api_resource.id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.mangum_api.id
}

resource "aws_api_gateway_method" "api" {
  count            = length(local.http_methods)
  resource_id      = aws_api_gateway_resource.api_resource.id
  rest_api_id      = aws_api_gateway_rest_api.mangum_api.id
  http_method      = local.http_methods[count.index]
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "api_integration" {
  count                   = length(local.http_methods)
  rest_api_id             = aws_api_gateway_rest_api.mangum_api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.mangum_func.invoke_arn
}

#################################################
# Docs Endpoints Integration
#################################################
resource "aws_api_gateway_resource" "doc_base" {
  parent_id   = aws_api_gateway_rest_api.mangum_api.root_resource_id
  path_part   = "api-docs"
  rest_api_id = aws_api_gateway_rest_api.mangum_api.id
}

resource "aws_api_gateway_resource" "doc_get" {
  parent_id   = aws_api_gateway_resource.doc_base.id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.mangum_api.id
}

resource "aws_api_gateway_method" "doc_get" {
  resource_id      = aws_api_gateway_resource.doc_get.id
  rest_api_id      = aws_api_gateway_rest_api.mangum_api.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "doc_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.mangum_api.id
  resource_id             = aws_api_gateway_resource.doc_get.id
  http_method             = aws_api_gateway_method.doc_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.mangum_func.invoke_arn
}

#################################################
# Deployment + Stage
#################################################
resource "aws_api_gateway_deployment" "lambda_deploy" {
  rest_api_id = aws_api_gateway_rest_api.mangum_api.id
  description = "Deployment of function integration."

  triggers = {
    redeploy = filebase64sha256("api-gateway.tf")
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.api_integration,
    aws_api_gateway_integration.doc_get_integration,
  ]
}

resource "aws_api_gateway_stage" "deploy_stage" {
  deployment_id = aws_api_gateway_deployment.lambda_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.mangum_api.id
  stage_name    = var.stage_name
}

#################################################
# API Key
#################################################
resource "aws_api_gateway_api_key" "key" {
  name        = "mangum-api-key"
  description = "API Key to access the API endpoints."
}

resource "aws_api_gateway_usage_plan" "key" {
  name = "MangumAPIKeyUsagePlan"

  api_stages {
    api_id = aws_api_gateway_rest_api.mangum_api.id
    stage  = aws_api_gateway_stage.deploy_stage.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "key_plan" {
  key_id        = aws_api_gateway_api_key.key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.key.id
}

#################################################
# Invoke Permission
#################################################
resource "aws_lambda_permission" "api_gw_invoke" {
  count         = length(local.http_methods)
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mangum_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.mangum_api.execution_arn}/*/${local.http_methods[count.index]}/*"
}
