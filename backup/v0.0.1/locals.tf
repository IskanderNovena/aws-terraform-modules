locals {
  create_kms_key = var.create_kms_key && var.kms_key_arn == null ? true : false
  kms_key_arn    = local.create_kms_key ? aws_kms_key.vault_key[0].arn : var.kms_key_arn

  create_iam_role = var.create_iam_role && var.iam_role_arn == null ? true : false
  iam_role_arn    = local.create_iam_role ? aws_iam_role.backup_role[0].arn : var.iam_role_arn
}
