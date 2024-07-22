
resource "aws_iam_role" "mangum_func_role" {
  name = "MangumFunctionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"

        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "write_logs" {
  name = "MangumLogsPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["arn:aws:logs:*:*:*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "logs_attach" {
  policy_arn = aws_iam_policy.write_logs.arn
  role       = aws_iam_role.mangum_func_role.name
}
