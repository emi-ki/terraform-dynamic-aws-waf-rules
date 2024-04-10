locals {
  # アクセス制限をかける path と IP アドレスのリスト
  access_ristricted_paths_ips = [
    # {
    #   name = "access-ristrict-sample1"
    #   priority = 1 # <- 例。 priority は 1～999 で設定する。WAF モジュール側で +1000
    #   allow_path     = "/ristrict/sample1/"
    #   allow_ip_list = [
    #     "xx.xx.xx.xx/32", // AWS WAF の制約で末尾 /0 は指定できない（0.0.0.0/0 は指定できない）。すべてのアクセスを許可する場合、["0.0.0.0/1","128.0.0.0/1"] とする
    #     "yy.yy.yy.yy/32",
    #     "zz.zz.zz.zz/32",
    #   ]
    # },
    {
      name           = "access-ristrict-sample2"
      priority       = 1
      allow_path     = "/ristrict/sample2/"
      allow_ip_list  = [
        "0.0.0.0/1",
        "128.0.0.0/1",
      ]
    },
        {
      name           = "access-ristrict-sample3"
      priority       = 2
      allow_path     = "/ristrict/sample3/"
      allow_ip_list  = [
        "0.0.0.0/1",
        "128.0.0.0/1",
      ]
    },
  ]
}