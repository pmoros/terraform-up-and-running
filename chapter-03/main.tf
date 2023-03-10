terraform {
  backend "s3" {
    key    = "global/s3/terraform.tfstate"
  }
}


provider "aws" {
  region = "us-east-2"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}

# Create an S3 bucket to store our Terraform state file
resource "aws_s3_bucket" "terraform_state" {
  bucket = "paul-moros-terraform-up-and-running-state"
}

# Enable versioning so we can see the full revision history of our
# state files
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy       = true
    create_before_destroy = true
  }

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning_configuration {
    status = "Enabled"
  }

}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket_versioning.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lock the state file so that only one person can modify it at a time
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

