resource "aws_lambda_function_url" "latest" {
  function_name = aws_lambda_function.lambda_function.function_name
  authorization_type = "NONE"
}