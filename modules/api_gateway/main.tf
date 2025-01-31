# API Gateway REST API Setup
resource "aws_api_gateway_rest_api" "api" {
  name        = "MyAppAPI"
  description = "API Gateway to access the private EC2 instance"
}

# API Gateway Resource (root path)
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "app"
}

# API Gateway Method (GET method)
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway Integration with EC2 in Private Subnet via VPC Link
resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP" 
  uri                     = "http://${var.private_ip}:80" # EC2's private IP
  connection_type         = "INTERNET"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration.get_integration]

  rest_api_id = aws_api_gateway_rest_api.api.id
}

# API Gateway Stage for deployment
resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}

output "api_invoke_url" {
  value = aws_api_gateway_stage.api_stage.invoke_url
}
