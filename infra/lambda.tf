# Lambda Function URL (opcional, pode remover se não for usar)
resource "aws_lambda_function_url" "latest" {
  function_name      = aws_lambda_function.lambda_function.function_name
  authorization_type = "NONE"
}

# Empacota o código-fonte da Lambda em um arquivo zip
data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/template/build"
  output_path = "${path.module}/../lambda/template/output/package.zip"
}
 
# Função Lambda
resource "aws_lambda_function" "lambda_function" {
  filename         = data.archive_file.lambda_function.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.lambda_handler # Exemplo: "index.handler"
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime          = var.lambda_runtime # Exemplo: "nodejs22.x"

  # Descomente e personalize conforme necessário
  # environment {
  #   variables = {
  #     EXAMPLE_VAR = "value"
  #   }
  # }

  # memory_size = 128
  # timeout     = 10
}

# Política de trust para Lambda assumir o papel
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Papel IAM para execução da Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "${var.lambda_function_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Permissão básica de logs no CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_logs_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
