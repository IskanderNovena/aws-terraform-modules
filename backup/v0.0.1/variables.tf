variable "backup_vault_name" {
  type        = string
  description = "Name to give to the backup vault"
}

variable "backup_plans" {
  type = list(object({
    name = string,
    rules = list(object({
      rule_name                = string
      schedule                 = string
      start_window             = number
      completion_window        = number
      enable_continuous_backup = bool
      lifecycle = object({
        cold_storage_after = number
        delete_after       = number
      })
    }))
  }))
}

variable "backup_selections" {
  type = list(object({
    name          = string
    plan_name     = string
    resources     = optional(list(string))
    not_resources = optional(list(string))
    selection_tags = optional(list(object({
      type  = string
      key   = string
      value = string
    })))
    conditions = optional(object({
      string_equals = optional(list(object({
        key   = string
        value = string
      })))
      string_like = optional(list(object({
        key   = string
        value = string
      })))
      string_not_equals = optional(list(object({
        key   = string
        value = string
      })))
      string_not_like = optional(list(object({
        key   = string
        value = string
      })))
    }))
  }))
}

variable "create_kms_key" {
  type        = bool
  description = "Set to 'false' to provide a custom KMS key for the Backup Vault"
  default     = true
}

variable "kms_key_arn" {
  type        = string
  nullable    = true
  description = "ARN of the KMS key to use for the vault"
  default     = null
}

variable "create_iam_role" {
  type        = bool
  description = "Set to 'false' to provide a custom IAM role for the backup plan"
  default     = true
}

variable "iam_role_arn" {
  type        = string
  nullable    = true
  description = "ARN of the IAM role to use for the backup plan"
  default     = null
}

