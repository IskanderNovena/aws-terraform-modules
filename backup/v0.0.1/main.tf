resource "aws_backup_vault" "backup_vault" {
  name        = var.backup_vault_name
  kms_key_arn = local.kms_key_arn
}

resource "aws_backup_plan" "backup_plan" {
  for_each = [for plan in var.backup_plans : plan]
  name     = each.value.name

  dynamic "rule" {
    for_each = each.value.rules
    content {
      rule_name                = rule.value["name"]
      target_vault_name        = aws_backup_vault.backup_vault.name
      schedule                 = rule.value["schedule"]
      start_window             = rule.value["start_window"]
      completion_window        = rule.value["completion_window"]
      enable_continuous_backup = rule.value["enable_continuous_backup"]

      #Lifecycle for the backup vault
      dynamic "lifecycle" {
        for_each = rule.value["lifecycle"]
        content {
          cold_storage_after = lifecycle.value["cold_storage_after"]
          delete_after       = lifecycle.value["delete_after"]
        }
      }
    }
  }
}

locals {
}

resource "aws_backup_selection" "backup_selection" {
  for_each     = var.backup_selections
  iam_role_arn = local.iam_role_arn
  name         = each.value.name
  plan_id      = aws_backup_plan.backup_plan["${each.value.plan_name}"].id

  resources     = each.value.resources
  not_resources = each.value.not_resources

  dynamic "selection_tag" {
    for_each = each.value.selection_tag
    content {
      type  = selection_tag.type
      key   = selection_tag.key
      value = selection_tag.value
    }
  }

  condition {
    dynamic "string_equals" {
      for_each = each.value.conditions.string_equals
      content {
        key   = string_equals.key
        value = string_equals.value
      }
    }
    dynamic "string_like" {
      for_each = each.value.conditions.string_like
      content {
        key   = string_like.key
        value = string_like.value
      }
    }
    dynamic "string_not_equals" {
      for_each = each.value.conditions.string_not_equals
      content {
        key   = string_not_equals.key
        value = string_not_equals.value
      }
    }
    dynamic "string_not_like" {
      for_each = each.value.conditions.string_not_like
      content {
        key   = string_not_like.key
        value = string_not_like.value
      }
    }
  }
}
