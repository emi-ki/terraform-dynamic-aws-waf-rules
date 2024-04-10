locals{
  access_ristricted_paths_ips = {
    for paths_ips in var.access_ristricted_paths_ips : 
    paths_ips.name => paths_ips
  }
}

# for で paths_ips を繰り返し処理する。
# 1 回目の繰り返し処理で var.access_ristricted_paths_ips から
# shared/common_values/waf_rules.tf で定義し
# shared/common_values/outputs.tf で出力した
# 以下のような list（paths_ips）を得る。

# {
#   name           = "access-ristrict-sample2"
#   priority       = 1
#   allow_path     = "/ristrict/sample2/"
#   allow_ip_list  = [
#     "0.0.0.0/1",
#     "128.0.0.0/1",
#   ]
# },

# paths_ips.name => paths_ips の指示では、
# paths_ips の name（"access-ristrict-sample2"）を
# 新しい map のトップレベルキーとして設定し、
# この list（paths_ips）全体を、新しい map の値として使う。
# 新しい map 型ができあがると以下のようになる。

# {
#   "access-ristrict-sample2" = {
#     name           = "access-ristrict-sample2"
#     priority       = 1
#     allow_path     = "/ristrict/sample2/"
#     allow_ip_list  = [
#       "0.0.0.0/1",
#       "128.0.0.0/1",
#     ]
#   }
# },