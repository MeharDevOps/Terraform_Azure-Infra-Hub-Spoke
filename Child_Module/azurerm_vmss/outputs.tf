output "vmss_ids" {
  description = "Map of Virtual Machine Scale Set IDs"
  value       = { for k, v in azurerm_linux_virtual_machine_scale_set.vmss : k => v.id }
}
