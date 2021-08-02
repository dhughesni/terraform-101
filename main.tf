terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
    access_key = "mock_access_key"
    region = "us-east-1"
    s3_force_path_style = true
    secret_key = "mock_secret_key"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_requesting_account_id = true

    endpoints {
        # ensure localstack connections are valid
        es = "http://0.0.0.0:4566"
        s3 = "http://0.0.0.0:4566"
    }
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
  acl = "public-read"
  
  tags = {
    Name = "My bucket"
    Environment = "Dev"
  }
}
