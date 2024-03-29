terraform {
  required_providers {
    aws = {
      version = ">= 4.0.0"
      source  = "hashicorp/aws"
    }
  }
}


# specify the provider region
provider "aws" {
  region = "ca-central-1"
}




# S3 bucket
# if you omit the name, Terraform will assign a random name to it
# see the docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "lambda" {}


# output the name of the bucket after creation
output "bucket_name" {
  value = aws_s3_bucket.lambda.bucket
}


# add the next part of the infrasturcture code from the notes once the functions are made


# read the docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "lotion-30140980" {
  name         = "lotion-30140980"
  billing_mode = "PROVISIONED"


  # up to 8KB read per second (eventually consistent)
  read_capacity = 1


  # up to 1KB per second
  write_capacity = 1


  # # we only need a student id to find an item in the table; therefore, we
  # # don't need a sort key here
  # hash_key = "student_id"
  hash_key = "email"
  range_key = "note_id"






  attribute {
    name = "note_id"
    type = "S"
  }


  attribute {
    name = "email"
    type = "S"
  }
}


# the locals block is used to declare constants that
# you can use throughout your code
locals {
  function_names = ["save-note-30148383", "get-notes-30148383", "delete-note-30148383"]
  handler_name  = "main.handler"
}


# create a role for the Lambda function to assume
# every service on AWS that wants to call other AWS services should first assume a role.
# then any policy attached to the role will give permissions
# to the service so it can interact with other AWS services
# see the docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "lambda" {
  for_each          = toset(local.function_names)
  name               = "iam-for-lambda-${each.key}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


# create a Lambda function
# see the docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
resource "aws_lambda_function" "lambda" {
  for_each     = toset(local.function_names)
  s3_bucket     = "terraform-20230323225408891900000001"
  s3_key        = "${each.key}/artifact.zip"
  role          = aws_iam_role.lambda[each.key].arn
  function_name = each.key
  handler       = local.handler_name
  runtime = "python3.9"
}


# create a policy for publishing logs to CloudWatch
# see the docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "logs" {
  for_each     = toset(local.function_names)
  name        = "lambda-logging-${each.key}"
  description = "IAM policy for logging from a lambda"


  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}


# attach the above policy to the function role
# see the docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  for_each    = toset(local.function_names)
  role       = aws_iam_role.lambda[each.key].name
  policy_arn = aws_iam_policy.logs[each.key].arn
}


# create a data source for the Lambda function
# this will allow us to retrieve the function's URL
data "aws_lambda_function" "example_lambda" {
  function_name = aws_lambda_function.lambda["save-note-30148383"].function_name
}


# output the function's URL
output "lambda_function_url" {
  value = data.aws_lambda_function.example_lambda.invoke_arn
}
