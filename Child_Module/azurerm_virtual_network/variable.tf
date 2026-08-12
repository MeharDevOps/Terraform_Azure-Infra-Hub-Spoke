
variable "virtual_network" {
  type = map(object({
    vnet_name              = string
    rg_name                = string
    location               = string
    address_space          = list(string)
    dns_servers            = optional(list(string))
    edge_zone              = optional(string)
    bgp_community          = optional(string)
    flow_timeout_in_minutes = optional(number)
    tags                   = optional(map(string))
  }))
}
