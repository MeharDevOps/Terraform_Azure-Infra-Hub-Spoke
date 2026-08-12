output "ip_configuration" {
  description = "IP configuration blocks for each firewall instance."
  value = {
    for k, fw in azurerm_firewall.firewall : k => fw.ip_configuration
  }
}

output "private_ip_address" {
  description = "Private IP address of the first firewall ip_configuration for each firewall instance."
  value = {
    for k, fw in azurerm_firewall.firewall : k => (
      length(fw.ip_configuration) > 0 ? fw.ip_configuration[0].private_ip_address : null
    )
  }
}