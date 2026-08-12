
variable "aks_clusters" {
  description = "Map of AKS cluster configurations"
  type = map(object({
    cluster_name        = string
    location            = string
    rg_name             = string
    dns_prefix          = string
    kubernetes_version  = optional(string)
    sku_tier            = optional(string)
    identity_type       = optional(string)
    rbac_enabled        = optional(bool)
    tags                = optional(map(string))

    default_node_pool = object({
      name            = string
      node_count      = number
      vm_size         = string
      os_disk_size_gb = optional(number)
      subnet_id       = optional(string)
    })

    network_profile = optional(object({
      network_plugin    = optional(string)
      network_policy    = optional(string)
      load_balancer_sku = optional(string)
    }), {})
  }))
}