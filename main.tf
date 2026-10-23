terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "terraform-learning-lab"
      Environment = "practice"
      ManagedBy   = "Terraform"
    }
  }
}

resource "aws_s3_bucket" "lab" {
  bucket_prefix = "terraform-ubuntu-lab-"
}

resource "aws_s3_bucket_public_access_block" "lab" {
  bucket = aws_s3_bucket.lab.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lab" {
  bucket = aws_s3_bucket.lab.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "lab" {
  bucket = aws_s3_bucket.lab.id

  versioning_configuration {
    status = "Enabled"
  }
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket created for this lab."
  value       = aws_s3_bucket.lab.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket created for this lab."
  value       = aws_s3_bucket.lab.arn
}
