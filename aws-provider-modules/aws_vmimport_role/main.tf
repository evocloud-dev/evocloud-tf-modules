################################################################################
# AWS VMIMPORT IAM Role
################################################################################
#https://docs.aws.amazon.com/vm-import/latest/userguide/required-permissions.html

#--------------------------------------------
# Create Trust Policy
#--------------------------------------------
data "aws_iam_policy_document" "vmimport_trust" {
  statement {
    sid     = "VMImportTrust"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vmie.amazonaws.com"]
    }

    # Recommended security improvement (AWS docs 2024+)
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["vmimport"]
    }
  }
}


#--------------------------------------------
# Create Role and set Trust Relationship
#--------------------------------------------
# The vmimport Role must be named exactly "vmimport"
resource "aws_iam_role" "vmimport" {
  name               = "vmimport"
  assume_role_policy = data.aws_iam_policy_document.vmimport_trust.json # Attach Trust Policy

  # Optional: add description & tags
  description = "Role required by AWS VM Import/Export service"
  tags = {
    Name        = "vmimport"
    Purpose     = "VM-Import-Export-Service"
  }
}

#--------------------------------------------
# Policies to attach to "vmimport" Role
#--------------------------------------------
data "aws_iam_policy_document" "vmimport_permissions" {
  # Required: access to read the disk image from S3
  statement {
    sid    = "ReadImportBucket"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "${var.BUCKET_ARN}",
      "${var.BUCKET_ARN}/*"
    ]
  }

  # Required: write exported/converted images to S3
  statement {
    sid    = "WriteExportBucket"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:PutObjectAcl"   # sometimes needed depending on target bucket settings
    ]
    resources = [
      "${var.BUCKET_ARN}",
      "${var.BUCKET_ARN}/*"
    ]
  }

  # Required for EC2 operations during import
  statement {
    sid    = "EC2ImportOperations"
    effect = "Allow"
    actions = [
      "ec2:ModifySnapshotAttribute",
      "ec2:CopySnapshot",
      "ec2:RegisterImage",
      "ec2:Describe*"
    ]
    resources = ["*"]
  }
}

#--------------------------------------------
# Attach Policy to "vmimport" Role
#--------------------------------------------
resource "aws_iam_role_policy" "vmimport_policy" {
  name   = "vmimport-policy"
  role   = aws_iam_role.vmimport.id
  policy = data.aws_iam_policy_document.vmimport_permissions.json
}