resource "aws_iam_role" "backup_role" {
  count = local.create_iam_role ? 1 : 0
  name  = "aws_backup_backup_role_${var.backup_vault_name}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : ["sts:AssumeRole"],
        "Effect" : "allow",
        "Principal" : {
          "Service" : ["backup.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_role_attachment" {
  count      = local.create_iam_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role[0].name
}
resource "aws_iam_role_policy_attachment" "restore_role_attachment" {
  count      = local.create_iam_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.backup_role[0].name
}

resource "aws_iam_role_policy" "kms_usage_policy" {
  name = "kms_policy"
  role = aws_iam_role.backup_role[0].id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ]
        Effect   = "Allow"
        Resource = local.kms_key_arn
      },
    ]
  })
}
