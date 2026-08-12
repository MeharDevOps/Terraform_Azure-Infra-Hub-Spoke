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

module "public_Ip" {
  source     = "../../Child_Module/azurerm_public_ip"
  public_ip  = var.public_ip
  depends_on = [module.resource_group, module.subnet]
}

module "azure_bastion" {
  source        = "../../Child_Module/azurerm_bastion"
  azure_bastion = var.azure_bastion
  depends_on    = [module.public_Ip]
}

module "firewall" {
  source     = "../../Child_Module/azurerm_firewall"
  firewall   = var.firewall
  depends_on = [module.subnet, module.public_Ip, module.resource_group]
}



