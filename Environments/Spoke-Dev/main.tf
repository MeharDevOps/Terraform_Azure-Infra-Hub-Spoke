module "resource_group" {
  source         = "../../Child_Module/azurerm_resource_group"
  resource_group = var.resource_group
}

module "virtual_network" {
  source          = "../../Child_Module/azurerm_virtual_network"
  virtual_network = var.virtual_network
  depends_on      = [module.resource_group]
}

module "vnet_peering" {
  source           = "../../Child_Module/azurerm_vnet_peering"
  vnet_peerings    = var.vnet_peerings
  vnet_ids         = module.virtual_network.vnet_ids
  vnet_names       = module.virtual_network.vnet_names
  vnet_rg_names    = module.virtual_network.vnet_resource_group_names
  depends_on       = [module.virtual_network]
}

module "subnet" {
  source     = "../../Child_Module/azurerm_subnet"
  subnet     = var.subnet
  depends_on = [module.virtual_network]
}

module "network_interface" {
  source      = "../../Child_Module/azurerm_NetworkInterface"
  network_nic = var.network_nic
  depends_on  = [module.subnet, module.resource_group]
}

module "network_security_group" {
  source      = "../../Child_Module/azurerm_Network_Security_Group"
  network_nsg = var.network_nsg
  network_nic = var.network_nic
  depends_on  = [module.network_interface, module.resource_group]
}

module "vmss" {
  source     = "../../Child_Module/azurerm_vmss"
  vmss       = var.vmss
  depends_on = [module.subnet, module.resource_group, module.keyvaults, module.vm_secret]
}

module "keyvaults" {
  source     = "../../Child_Module/azurerm_keyvault"
  keyvaults  = var.keyvaults
  depends_on = [module.resource_group]
}

module "vm_secret" {
  source     = "../../Child_Module/azurerm_vm_secrets"
  secret     = var.secret
  depends_on = [module.keyvaults]
}