############################################
# IPsets
############################################
## （動的生成）. 指定パスの IP 許可ルールグループ（許可IP以外をブロック）
resource "aws_wafv2_ip_set" "access_ristrict" {
  for_each = local.access_ristricted_paths_ips

  name               = "${each.value.name}-ristrict-ipsets"
  description        = "${each.value.name}-ristrict-ipsets"
  scope              = "REGIONAL"
  addresses          = each.value.allow_ip_list
  ip_address_version = "IPV4"

  tags = {
    Name = "${each.value.name}-ristrict-ipsets"
  }
}

############################################
# カスタムルールグループ
############################################
## （動的生成）. 指定パスの IP 許可ルールグループ（許可IP以外をブロック）
resource "aws_wafv2_rule_group" "access_ristrict" {
  for_each = local.access_ristricted_paths_ips

  name        = "${each.value.name}-ristrict-waf-rulegp"
  description = "${each.value.name}-ristrict-waf-rulegp"
  scope       = "REGIONAL"
  capacity    = 3 # 1 つのルールグループに 1 つのルールのみ設定する

  visibility_config {
    cloudwatch_metrics_enabled = true # CloudWatch Metrics を無効にすると CloudWatch で確認できなくなるため、true で固定
    metric_name                = "${each.value.name}-ristrict-rulegp"
    sampled_requests_enabled   = true # Web ACL ルールに一致するリクエストを表示する。true で固定
  }

  rule {
    name     = "${each.value.name}-ristrict-rule"
    priority = 1

    action {
      block {}
    }

    statement {
      and_statement {
        statement {
          byte_match_statement {
            field_to_match {
              uri_path {}
            }
            positional_constraint = "STARTS_WITH"
            search_string         = each.value.allow_path
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }

        statement {
          not_statement {
            statement {
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.access_ristrict[each.key].arn # IPsets の ARN を指定
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${each.value.name}-ristrict-rule"
      sampled_requests_enabled   = true
    }
  }
}

############################################
# Web ACL
############################################
resource "aws_wafv2_web_acl" "web_acl" {

  name        = "alb-webacl"
  description = "alb-wabacl"
  scope       = "REGIONAL"

  tags = {
    Name = "alb-webacl"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb-webacl"
    sampled_requests_enabled   = true
  }

  default_action {
    allow {}
  }

  ## （動的生成）. 指定パスの IP 許可ルールグループ（許可IP以外をブロック）
  dynamic "rule" {
    for_each = local.access_ristricted_paths_ips

    content {
      name     = "${title(rule.value.name)}PathIpRestriction"
      priority = rule.value.priority + 1000 

      override_action {
        none {}
      }

      statement {
        rule_group_reference_statement {
          arn = aws_wafv2_rule_group.access_ristrict[rule.key].arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true 
        metric_name                = "${title(rule.value.name)}PathIpRestriction"
        sampled_requests_enabled   = true 
      }
    }
  }

}

############################################
# WAF のログを出力する CloudWatch Logs
############################################
resource "aws_cloudwatch_log_group" "cwlogs" {

  name              = "aws-waf-logs-${aws_wafv2_web_acl.web_acl.name}"
  retention_in_days = 30

  tags = {
    Name     = "aws-waf-logs-${aws_wafv2_web_acl.web_acl.name}"
  }
}

############################################
# WAF のログフィルタ設定
############################################
resource "aws_wafv2_web_acl_logging_configuration" "waflog" {

  resource_arn = aws_wafv2_web_acl.web_acl.arn
  log_destination_configs = [
    # CloudWatch Logs
    aws_cloudwatch_log_group.cwlogs.arn,
  ]

  logging_filter {
    # デフォルトではログを記録しない
    default_behavior = "DROP"

    filter {
      behavior = "KEEP"
      # MEETS_ALL: AND条件、 MEETS_ANY: OR条件
      requirement = "MEETS_ANY"

      ## action_condition ブロックに CAPTCHA の記載はないが apply はできる模様 https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration#action-condition
      condition {
        action_condition {
          # CAPTCHAアクションのログを記録
          action = "CAPTCHA"
        }
      }

      condition {
        action_condition {
          # COUNTアクションのログを記録
          action = "COUNT"
        }
      }

      condition {
        action_condition {
          # BLOCKアクションのログを記録
          action = "BLOCK"
        }
      }
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.cwlogs,
  ]
}

############################################
# ALB への WAF の割り当て
############################################
resource "aws_wafv2_web_acl_association" "waf_association" {

  resource_arn = var.alb_arn #ALBのARN
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}