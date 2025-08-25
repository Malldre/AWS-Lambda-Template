data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/template/build"
  output_path = "${path.module}/../lambdas/template/output/package.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename      = data.archive_file.lambda_function.output_path
  function_name = var.lambda_function_name
  role         = aws_iam_role.lambda_role.arn
  handler     = var.lambda_handler
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime     = var.lambda_runtime
}