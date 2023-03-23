
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