variable "access_ristricted_paths_ips" {
  type = list(object({
    name          = string
    priority      = number
    allow_path    = string
    allow_ip_list = list(string)
  }))
  default     = []
  description = "アクセス拒否パスとIPリスト"
}

variable "alb_arn" {
  type        = string
  description = "ALB の ARN 設定情報"
}