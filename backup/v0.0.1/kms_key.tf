resource "aws_kms_key" "vault_key" {
  count                   = local.create_kms_key ? 1 : 0
  description             = "Encryption Key For AWS Vault ${var.backup_vault_name}"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "vault_key_alias" {
  count         = local.create_kms_key ? 1 : 0
  name          = "alias/backup-vault-${var.backup_vault_name}"
  target_key_id = aws_kms_key.vault_key[0].key_id
}
