
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
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = false

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_vpc_link" "lb_link" {
  name        = "ecs-example-link"
  description = "Link AWS API Gateway to load balancer"
  target_arns = [aws_lb.alb.arn]
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_lb.alb.dns_name}:${var.port}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.lb_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
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
