output "kms_key_arn" {
  description = "ARN of the KMS key used for the backup vault"
  value       = local.kms_key_arn
}

output "iam_role_arn" {
  description = "ARN of the IAM role used for the backup plan"
  value       = local.iam_role_arn
}
