# waf_rules
output "access_ristricted_paths_ips" {
  value = local.access_ristricted_paths_ips
}

# value フィールドに指定したデータの型（list, map など）はそのまま出力に反映される。
# local.access_ristricted_paths_ips が list 型で定義されていれば出力も list 型。
# output で以下のようなリストが出力される。

# access_ristricted_paths_ips = [
#   {
#     name           = "access-ristrict-sample2"
#     priority       = 1
#     allow_path     = "/ristrict/sample2/"
#     allow_ip_list  = [
#       "0.0.0.0/1",
#       "128.0.0.0/1",
#     ]
#   },
#   {
#     name           = "access-ristrict-sample3"
#     priority       = 2
#     allow_path     = "/ristrict/sample3/"
#     allow_ip_list  = [
#       "0.0.0.0/1",
#       "128.0.0.0/1",
#     ]
#   },
# ]