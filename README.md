# Automated Multi-Tiered S3 Data Protection Pipeline


## Description

&nbsp;&nbsp;&nbsp;&nbsp; This project provides an "Infrastructure as Code" (IaC) solution to automate the protection of Amazon S3 data. Using Terraform, it establishes a standardized backup environment that automatically detects, secures, and archives data based on simple organizational "tags." It is built for teams that need a hands-off, compliant, and cost-effective way to ensure their cloud data is never lost.

## Installation
   - To deploy this infrastructure, ensure you have the Terraform CLI installed and AWS credentials configured.

   1. Clone the Repository:\
      `git clone https://github.com/your-repo/aws-s3-backup-automation.git`\
      `cd aws-s3-backup-automation`
   2. Initialize Terraform:\
      `terraform init`
   3. Plan the deployment:\
      `terraform plan`
   4. Deploy to AWS:\
      `terraform apply`

## Features

- **Automated Scheduling:** Daily backups triggered at 05:00 UTC.
- **Intelligent Resource Selection:** Uses tag-based logic so you don't have to manually update the code for every new bucket.
- **Tiered Retention Policy:**\
&nbsp;&nbsp;&nbsp;&nbsp; 30 Days: Immediate recovery points.\
&nbsp;&nbsp;&nbsp;&nbsp; 365 Days: Long-term archival for compliance.
- **Security First:** Implements "Least Privilege" IAM roles and blocks all public S3 access by default.
- **Point-in-Time Recovery:** Continuous backup enabled for "rewinding" data to specific seconds.

## Tech Stack / Built With

Cloud Provider: Amazon Web Services (AWS)
Infrastructure as Code: Terraform (HCL)
Services Used:
 - AWS Backup: Centralized backup management.
 - Amazon S3: Scalable object storage.
 - AWS IAM: Security and access identity.

## Architectural Features and Best Practices:

**1. Two-Tiered Retention Strategy**

&nbsp;&nbsp;&nbsp;&nbsp; The backup plan is configured with two distinct retention lifecycles, ensuring both immediate recovery and long-term compliance are addressed:

   **Tier 1: Continuous Backup (Point-in-Time Recovery - PITR):**

- **Purpose:** Rapid recovery from accidental deletion or corruption.
- **Mechanism:** S3 Versioning is enabled on the source bucket, and continuous backup is configured, allowing recovery to any point in time within the 30-day window. This is crucial for achieving a low Recovery Time Objective (RTO).

   **Tier 2: Long-Term Snapshot Copy:**

- **Purpose:** Compliance, auditing, and extended retention.
- **Mechanism:** A copy_action within the plan creates an independent, vaulted snapshot of the data, retained for 365 days. This snapshot is decoupled from the continuous backup window and provides reliable WORM (Write Once, Read Many)-like integrity for yearly archiving.

**2. Policy-Driven Automation**

- The project utilizes tagging to abstract resource selection from the backup policy:
- **Tag-Based Selection:** Resources (S3 Buckets) are automatically included in the daily backup plan if they possess the tag BackupMe = "Yes". This simplifies scaling and prevents human error by ensuring new critical resources are protected immediately upon creation.
- **Scheduled Execution:** Backups are scheduled using a CRON expression (cron(0 5 ? * * *)) to run daily at off-peak hours, minimizing impact on application performance.

**3. Security and Governance**

- **Isolated Backup Vault:** Backup data is stored in a dedicated aws_backup_vault, providing a layer of isolation and protection against accidental deletion or source environment compromise.
- **KMS Encryption:** The Backup Vault is configured with a specific KMS Key ARN, guaranteeing that all backup data is encrypted at rest.
- **Granular IAM Role:** A dedicated IAM Service Role is defined (S3BackupRoleAutomated) with the minimum necessary permissions (tag:GetResources for discovery and AWSBackupServiceRolePolicyForBackup for execution) following the principle of least privilege.


