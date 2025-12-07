resource "aws_s3_bucket" "source" {
  bucket = var.source_bucket_name
  tags = {
    Name        = "Source S3 Data"
    BackupMe    = "Yes" # Tag used for resource selection
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "source_versioning" {
  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access for security best practice
resource "aws_s3_bucket_public_access_block" "source_public_access" {
  bucket                  = aws_s3_bucket.source.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}