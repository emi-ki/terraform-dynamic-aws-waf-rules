##################################################
## CloudWatch Logs
##################################################
# CloudWatch Logs Group ARN
output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.cwlogs.arn
  description = "The ARN of the CloudWatch Log Group for AWS WAF logs."
}

##################################################
## Web ACL 
##################################################
# Web ACL ARN 
output "web_acl_arn" {
  value = aws_wafv2_web_acl.web_acl.arn
  description = "The ARN of the Web ACL."
}

# Web ACL ID
output "web_acl_id" {
  value = aws_wafv2_web_acl.web_acl.id
  description = "The ID of the Web ACL."
}

# Web ACL name
output "web_acl_name" {
description = "The name of the WAFv2 WebACL."
value       = aws_wafv2_web_acl.web_acl.name
}

# web acl capacity
output "web_acl_capacity" {
description = "The web ACL capacity units (WCUs) currently being used by the WAFv2 WebACL."
value       = aws_wafv2_web_acl.web_acl.capacity
}

# Web ACL Logging Configuration
# 通常 Web ACL自体のARNと同じだが、ログ設定のコンテキストでの使用に便利
output "web_acl_logging_configuration_resource_arn" {
  value = aws_wafv2_web_acl_logging_configuration.waflog.resource_arn
  description = "The resource ARN for the Web ACL Logging Configuration."
}

##################################################
## IP Sets
##################################################
# IP Sets の作成は動的であるため、それぞれの IP Set の ARN を map 型で出力
output "ip_set_arns" {
value       = { for k, v in aws_wafv2_ip_set.access_ristrict : k => v.arn }
description = "The ARNs of the WAFv2 IP Sets created for access restriction."
}

# IP Sets の作成は動的であるため、それぞれの IP Set の ID を map 型で出力
output "ip_set_ids" {
value       = { for k, v in aws_wafv2_ip_set.access_ristrict : k => v.id }
description = "The IDs of the WAFv2 IP Sets created for access restriction."
}

##################################################
## Rule Group
##################################################
# Rule Group の作成は動的であるため、それぞれの Rule Group の ARN を map 型で出力
output "rule_group_arns" {
description = "The ARNs of the WAFv2 Rule Groups created for access restriction."
value       = { for k, v in aws_wafv2_rule_group.access_ristrict : k => v.arn }
}

# Rule Group の作成は動的であるため、それぞれの Rule Group の ID を map 型で出力
output "rule_group_ids" {
description = "The IDs of the WAFv2 Rule Groups created for access restriction."
value       = { for k, v in aws_wafv2_rule_group.access_ristrict : k => v.id }
}

# k は "key" の頭文字、map の key（トップレベルキー）を表すために使用
# v は "value" の頭文字、map 内の値を表すために使用