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
  source        = "../../Child_Module/azurerm_vnet_peering"
  vnet_peerings = var.vnet_peerings
  vnet_ids      = module.virtual_network.vnet_ids
  vnet_names    = module.virtual_network.vnet_names
  vnet_rg_names = module.virtual_network.vnet_resource_group_names
  depends_on    = [module.virtual_network]
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

module "application_gateway" {
  source               = "../../Child_Module/azurerm-application-gateway"
  application_gateways = var.application_gateways
  network_nic          = var.network_nic
  depends_on           = [module.public_Ip, module.subnet, module.resource_group]
}

module "storage_account" {
  source          = "../../Child_Module/azurerm_storage_account"
  storage_account = var.storage_account
  depends_on      = [module.resource_group]
}

module "private_endpoint" {
  source = "../../Child_Module/azurerm_private_endpoint"
  private_endpoints = {
    for k, pe in var.private_endpoints : k => merge(pe, {
      private_service_connection = merge(pe.private_service_connection, {
        private_connection_resource_id = coalesce(
          pe.private_service_connection.private_connection_resource_id,
          try(module.storage_account.storage_account_ids[pe.private_service_connection.target_resource_key], null)
        )
      })
    })
  }
  depends_on = [module.resource_group, module.subnet, module.storage_account]
}

module "azurerm_sql_server" {
  source          = "../../Child_Module/azurerm_sql_dataserver"
  sql_data_server = var.sql_data_server
  depends_on      = [module.resource_group]
}

module "azurerm_sql_database" {
  source = "../../Child_Module/azurerm_sql_database"
  sql_database = {
    for k, db in var.sql_database : k => merge(db, {
      server_id = coalesce(
        lookup(db, "server_id", null),
        try(module.azurerm_sql_server.sql_server_ids[db.server_key], null)
      )
    })
  }
  depends_on = [module.azurerm_sql_server]
}