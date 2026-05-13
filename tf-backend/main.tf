provider "aws" { region = "us-east-1" }

resource "aws_s3_bucket" "state" {
  bucket = "tf-state-bucket-r05323039"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_dynamodb_table" "locks" {
  name         = "tf-state-locks-r05323039"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}