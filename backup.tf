# 3. AWS Backup Vault
# The vault is the secure, encrypted, and isolated container where the backups land.

resource "aws_backup_vault" "vault" {
  name        = var.backup_vault_name
}

# 4. AWS Backup Plan (Schedule and Retention)

resource "aws_backup_plan" "daily_plan" {
  name = "Daily-S3-Backup-Plan"

  rule {
    rule_name         = "Daily-S3-Retention-30Days"
    target_vault_name = aws_backup_vault.vault.name
    # Schedule: Run every day at 05:00 UTC (using cron expression)
    schedule          = "cron(0 5 ? * * *)"
    enable_continuous_backup = true
    
    # Retention Policy: keep backups for 30 days
    lifecycle {
      delete_after = 30
    }
    copy_action {
      destination_vault_arn = aws_backup_vault.vault.arn
      lifecycle {
        # The copy action defines the longer retention snapshot
        # This creates a monthly snapshot copy held for 1 year
        delete_after = 365 
      }
    }

  }
}

# 5. AWS Backup Selection (Resource Assignment)
# This links the backup plan to the specific resource (the S3 bucket).

resource "aws_backup_selection" "s3_selection" {
  name          = "S3-Selection-${var.source_bucket_name}"
  plan_id       = aws_backup_plan.daily_plan.id
  iam_role_arn  = aws_iam_role.backup_role.arn

  # Select resources using tags. Any resource with the key "BackupMe" and value "Yes"
  # will be included in this backup plan. This is the recommended approach.
  selection_tag {
    type  = "STRINGEQUALS"
    key   = "BackupMe"
    value = "Yes"
  }
}
