############################################
# Common Values (read only)
############################################
module "common_values" {
  source = "../../shared/common_values"
}

############################################
# WAF
############################################
module "waf" {
source = "../../modules/waf"

access_ristricted_paths_ips = module.common_values.access_ristricted_paths_ips # 動的生成ルールグループのための変数呼び出し

# WAF を紐づける ALB の ARN
alb_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:loadbalancer/app/waf-test-alb/xxxxxxxxxxxxxxxx"

}