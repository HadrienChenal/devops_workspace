# modules/lambda-sample/main.tf

# 1. Le code de la fonction Lambda (index.js)
resource "local_file" "lambda_code" {
  filename = "${path.module}/index.js"
  content  = <<EOF
exports.handler = async (event) => {
    return {
        statusCode: 200,
        body: JSON.stringify({ message: "Hello from Lambda!" }),
    };
};
EOF
}

# 2. Archive du code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = local_file.lambda_code.filename
  output_path = "${path.module}/lambda.zip"
}

# 3. Rôle IAM pour la Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_sample"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# 4. La fonction Lambda
resource "aws_lambda_function" "sample" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "sample-function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
}

# 5. API Gateway (V2 HTTP API pour la simplicité)
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "v2-lambda-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_handler" {
  api_id             = aws_apigatewayv2_api.lambda_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.sample.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_handler.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = "$default"
  auto_deploy = true
}

# Permission pour que l'API appelle la Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}