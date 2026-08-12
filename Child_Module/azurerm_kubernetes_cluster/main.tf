resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.aks_clusters

  name                = each.value.cluster_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  dns_prefix          = each.value.dns_prefix

  kubernetes_version  = lookup(each.value, "kubernetes_version", null)
  sku_tier            = lookup(each.value, "sku_tier", "Free")

  default_node_pool {
    name            = each.value.default_node_pool.name
    node_count      = each.value.default_node_pool.node_count
    vm_size         = each.value.default_node_pool.vm_size
    os_disk_size_gb = lookup(each.value.default_node_pool, "os_disk_size_gb", 30)
  }

  # 👇 Always use SystemAssigned identity
  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = lookup(each.value, "rbac_enabled", true)

  network_profile {
    network_plugin     = lookup(each.value.network_profile, "network_plugin", "azure")
    network_policy     = lookup(each.value.network_profile, "network_policy", "azure")
    load_balancer_sku  = lookup(each.value.network_profile, "load_balancer_sku", "standard")
  }

  tags = lookup(each.value, "tags", {})
}

