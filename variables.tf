variable "region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "backup_vault_name" {
  description = "The Backup Vault Name"
  type        = string
  default     = "s3-backup-vault"
}

variable "source_bucket_name" {
  description = "The S3 Bucket Name"
  type        = string
  default     = "my-app-data-source-bucket-20251201" # Must be globally unique!
}