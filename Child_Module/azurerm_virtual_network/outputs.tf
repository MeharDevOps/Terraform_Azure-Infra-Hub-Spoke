output "vnet_ids" {
  description = "Map of virtual network IDs keyed by the virtual network map key."
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.id }
}

output "vnet_names" {
  description = "Map of virtual network names keyed by the virtual network map key."
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.name }
}

output "vnet_resource_group_names" {
  description = "Map of resource group names for each virtual network keyed by the virtual network map key."
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.resource_group_name }
}
