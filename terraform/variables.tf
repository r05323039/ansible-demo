variable "server_configs" {
  description = "伺服器環境與管理員設定"
  type = map(object({
    env   = string
    admin = string
  }))
}