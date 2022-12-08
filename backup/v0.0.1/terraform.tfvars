backup_vault_name = "backup_vault"

backup_plans = [
  {
    name = "backup_plan_1"
    rules = [{
      rule_name                = "backup_rule_1"
      schedule                 = "cron(0 0 1 * * * *)"
      start_window             = 60
      completion_window        = 120
      enable_continuous_backup = true
      lifecycle = {
        cold_storage_after = 0
        delete_after       = 25
      }
    }]
  },
  {
    name = "backup_plan_2"
    rules = [{
      rule_name                = "backup_rule_1"
      schedule                 = "cron(0 0 1 * * * *)"
      start_window             = 60
      completion_window        = 120
      enable_continuous_backup = true
      lifecycle = {
        cold_storage_after = 0
        delete_after       = 25
      }
    }]
  }
]

backup_selections = [
  {
    name      = "selection_1"
    plan_name = "backup_plan_1"
    selection_tags = [{
      type  = "STRINGEQUALS"
      key   = "BackupPlan"
      value = "35-days"
    }]
  },
  {
    name      = "selection_2"
    plan_name = "backup_plan_2"
    selection_tags = [{
      type  = "STRINGEQUALS"
      key   = "BackupPlan"
      value = "35-days"
    }]
  },
  {
    name          = "selection_3"
    plan_name     = "backup_plan_2"
    resources     = ["arn:aws:dynamodb:us-east-1:123456789101:table/mydynamodb-table3"]
    not_resources = []
    conditions = {
      string_equals = [{
        key   = "aws:ResourceTag/Component"
        value = "rds"
        },
        {
          key   = "aws:ResourceTag/Project"
          value = "Project1"
      }]
      string_like = [{
        key   = "aws:ResourceTag/Application"
        value = "app*"
      }]
      string_not_equals = [{
        key   = "aws:ResourceTag/Backup"
        value = "false"
      }]
      string_not_like = [{
        key   = "aws:ResourceTag/Environment"
        value = "test*"
      }]
    }
  }
]



create_kms_key = true
kms_key_arn    = null

create_iam_role = true
iam_role_arn    = null
