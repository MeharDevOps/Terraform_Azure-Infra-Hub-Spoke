variable "storage_account" {
  description = "Map of storage accounts"
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    account_kind             = optional(string)
    access_tier              = optional(string)
    enable_https_traffic_only = optional(bool)
    min_tls_version          = optional(string)
    is_hns_enabled           = optional(bool)
    tags                     = optional(map(string))
  }))
}