variable "vnet_peerings" {
  description = "Map of VNet peering definitions."
  type = map(object({
    name                        = string
    local_vnet                  = string
    remote_vnet                 = string
    allow_virtual_network_access = optional(bool)
    allow_forwarded_traffic      = optional(bool)
    allow_gateway_transit        = optional(bool)
    use_remote_gateways          = optional(bool)
  }))
}

variable "vnet_ids" {
  description = "Map of VNet ids keyed by virtual network map key."
  type        = map(string)
}

variable "vnet_names" {
  description = "Map of VNet names keyed by virtual network map key."
  type        = map(string)
}

variable "vnet_rg_names" {
  description = "Map of VNet resource group names keyed by virtual network map key."
  type        = map(string)
}
