Automated Multi-Tiered S3 Data Protection Pipeline

Project Overview:
    This Terraform project deploys an automated and policy-driven data protection solution for critical Amazon S3 data. It leverages AWS Backup services to establish a resilient, multi-tiered retention strategy that meets both stringent disaster recovery (DR) objectives and long-term compliance mandates. The infrastructure is provisioned entirely using Infrastructure as Code (IaC), ensuring consistency, repeatability, and version control.

Key Technologies Used:
- IaC: Terraform
- Cloud Platform: Amazon Web Services (AWS)
- Services: AWS Backup, Amazon S3, AWS Identity and Access Management (IAM), AWS Key Management Service (KMS).

Architectural Features and Best Practices:

1. Two-Tiered Retention Strategy

The backup plan is configured with two distinct retention lifecycles, ensuring both immediate recovery and long-term compliance are addressed:

   Tier 1: Continuous Backup (Point-in-Time Recovery - PITR):

- Purpose: Rapid recovery from accidental deletion or corruption.
- Mechanism: S3 Versioning is enabled on the source bucket, and continuous backup is configured, allowing recovery to any point in time within the 30-day window. This is crucial for achieving a low Recovery Time Objective (RTO).

   Tier 2: Long-Term Snapshot Copy:

- Purpose: Compliance, auditing, and extended retention.
- Mechanism: A copy_action within the plan creates an independent, vaulted snapshot of the data, retained for 365 days. This snapshot is decoupled from the continuous backup window and provides reliable WORM (Write Once, Read Many)-like integrity for yearly archiving.

2. Policy-Driven Automation

- The project utilizes tagging to abstract resource selection from the backup policy:
- Tag-Based Selection: Resources (S3 Buckets) are automatically included in the daily backup plan if they possess the tag BackupMe = "Yes". This simplifies scaling and prevents human error by ensuring new critical resources are protected immediately upon creation.
- Scheduled Execution: Backups are scheduled using a CRON expression (cron(0 5 ? * * *)) to run daily at off-peak hours, minimizing impact on application performance.

3. Security and Governance

- Isolated Backup Vault: Backup data is stored in a dedicated aws_backup_vault, providing a layer of isolation and protection against accidental deletion or source environment compromise.
- KMS Encryption: The Backup Vault is configured with a specific KMS Key ARN, guaranteeing that all backup data is encrypted at rest.
- Granular IAM Role: A dedicated IAM Service Role is defined (S3BackupRoleAutomated) with the minimum necessary permissions (tag:GetResources for discovery and AWSBackupServiceRolePolicyForBackup for execution) following the principle of least privilege.


