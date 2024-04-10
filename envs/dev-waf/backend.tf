##################################################
# Terraform settings
##################################################
terraform { # https://developer.hashicorp.com/terraform/language/settings
  # Terraform バージョンの指定
  required_version = "~> 1.5"
  # AWS プロバイダーのバージョン指定 https://registry.terraform.io/providers/hashicorp/aws/latest
  required_providers {
      aws = {
          source  = "hashicorp/aws"
          version = "~> 5.1"
      }
  }
  # tfstate ファイルを S3 に配置する（配置先の S3 は事前に作成しておく）
  backend s3 {
      bucket = "<s3_bucket_name>"
      region = "ap-northeast-1"
      key    = "<tfstate_file_name>.tfstate"
  }
}