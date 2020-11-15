# State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-appup"
  # Enable versioning so we can see the full revision history of our state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# We need this for terraform to maintain the state remotely
terraform {
  backend "s3" {
    bucket = "terraform-appup"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table          = "terraform"
    encrypt                 = true
    shared_credentials_file = "$HOME/.aws/credentials"
    profile                 = "appup-new"
  }
}
