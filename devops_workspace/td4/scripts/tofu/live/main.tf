# live/main.tf

provider "aws" {
  region = "eu-west-3"
}

module "my_lambda" {
  source = "../modules/lambda-sample"
}

output "api_url" {
  value = module.my_lambda.api_endpoint
}