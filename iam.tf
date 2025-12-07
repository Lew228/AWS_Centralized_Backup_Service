# AWS Backup requires an IAM role to perform backup and restore operations.
resource "aws_iam_role" "backup_role" {
  name = "AWSBackupServiceRole-S3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "backup.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the required managed policy for AWS Backup to manage S3 resources
resource "aws_iam_role_policy_attachment" "backup_policy_s3" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

resource "aws_iam_role_policy" "tag_read_policy" {
  name = "S3BackupTagReadPolicy"
  role = aws_iam_role.backup_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "tag:GetResources",
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}