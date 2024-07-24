/**
resource "aws_api_gateway_rest_api" "api" {
  name        = "ECS Example API"
  description = "Example API to try ECS + FastAPI!"
}

#################################################
# API Endpoints Integration
#################################################
resource "aws_api_gateway_resource" "api_resource" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "api" {
  resource_id      = aws_api_gateway_resource.api_resource.id
  rest_api_id      = aws_api_gateway_rest_api.api.id
  http_method      = "ALL"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.mangum_func.invoke_arn
}


#################################################
# Deployment + Stage
#################################################
resource "aws_api_gateway_deployment" "lambda_deploy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  description = "Deployment of function integration."

  triggers = {
    redeploy = filebase64sha256("api-gateway.tf")
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.api_integration,
  ]
}

resource "aws_api_gateway_stage" "deploy_stage" {
  deployment_id = aws_api_gateway_deployment.lambda_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.stage_name
}
*/