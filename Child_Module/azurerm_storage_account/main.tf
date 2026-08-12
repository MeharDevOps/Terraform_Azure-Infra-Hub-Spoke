resource "azurerm_storage_account" "sa" {
  for_each = var.storage_account
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  # Optional settings
  account_kind             = lookup(each.value, "account_kind", "StorageV2")
  access_tier              = lookup(each.value, "access_tier", "Hot")
  https_traffic_only_enabled = lookup(each.value, "enable_https_traffic_only", true)
  min_tls_version          = lookup(each.value, "min_tls_version", "TLS1_2")

  # Optional Hierarchical Namespace (for Data Lake Gen2)
  is_hns_enabled = lookup(each.value, "is_hns_enabled", false)

  # Tags
  tags = lookup(each.value, "tags", {
    environment = "dev"
    owner       = "mehar"
  })
}