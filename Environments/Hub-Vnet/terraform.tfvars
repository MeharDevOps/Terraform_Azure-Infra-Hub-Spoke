resource_group = {
  rg1 = {
    rg_name    = "rg-hub-network"
    location   = "eastus"
    managed_by = "azurerm_user_assigned_identity.test"
    tags = {
      Environment = "hub"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}

virtual_network = {
  Hubvnet = {
    vnet_name     = "HubVnet"
    rg_name       = "rg-hub-network"
    location      = "eastus"
    address_space = ["10.0.0.0/16"]
    tags = {
      Environment = "hub"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}

vnet_peerings = {}

subnet = {
  subnet1 = {
    subnet_name      = "AzureFirewallSubnet"
    vnet_name        = "HubVnet"
    rg_name          = "rg-hub-network"
    address_prefixes = ["10.0.0.0/26"]
  }

  subnet4 = {
    subnet_name      = "GatewaySubnet"
    vnet_name        = "HubVnet"
    rg_name          = "rg-hub-network"
    address_prefixes = ["10.0.1.0/27"]
  }
}

public_ip = {
  bastion_pip = {
    pip_name          = "bastion-pip"
    rg_name           = "rg-hub-network"
    location          = "eastus"
    allocation_method = "Static"
    sku               = "Standard"
    tags = {
      Environment = "hub"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
  firewall_pip = {
    pip_name          = "firewall-pip"
    rg_name           = "rg-hub-network"
    location          = "eastus"
    allocation_method = "Static"
    sku               = "Standard"
    tags = {
      Environment = "hub"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}

azure_bastion = {
  bastion1 = {
    bastion_name       = "azure-bastion"
    location           = "eastus"
    rg_name            = "rg-hub-network"
    vnet_name          = "HubVnet"
    bastion_subnetname = "AzureBastionSubnet"
    address_prefixes   = ["10.0.2.0/26"]
    pip_name           = "bastion-pip"
    tags = {
      Environment = "hub"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}

firewall = {
  firewall01 = {
    firewall_name     = "firewall1"
    rg_name           = "rg-hub-network"
    location          = "eastus"
    sku_name          = "AZFW_VNet"
    sku_tier          = "Standard"
    pip_name          = "firewall-pip"
    vnet_name         = "HubVnet"
    subnet_name       = "AzureFirewallSubnet"
    private_ip_ranges = [
      "10.0.0.0/8",
      "172.16.0.0/12"
    ]
    threat_intel_mode = "Alert"
    zones             = ["1", "2", "3"]
    tags = {
      Environment = "hub"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}
