
locals {
  function_file = "../lambda-src.zip"
  layer_file    = "../layer-src.zip"
}

resource "aws_lambda_layer_version" "libs_layer" {
  layer_name          = "mangum-app-libraries"
  description         = "Contains the Python libraries required for the app. See requirements.txt file for details."
  compatible_runtimes = ["python3.9"]
  filename            = local.layer_file
  source_code_hash    = filebase64sha256(local.layer_file)
}

resource "aws_lambda_function" "mangum_func" {
  function_name    = "mangum-example-function"
  role             = aws_iam_role.mangum_func_role.arn
  runtime          = "python3.9"
  package_type     = "Zip"
  filename         = local.function_file
  source_code_hash = filebase64sha256(local.function_file)
  memory_size      = var.lambda_memory
  handler          = "main.lambda_handler"

  environment {
    variables = {
      STAGE_NAME = var.stage_name
    }
  }

  layers = [aws_lambda_layer_version.libs_layer.arn]
}
