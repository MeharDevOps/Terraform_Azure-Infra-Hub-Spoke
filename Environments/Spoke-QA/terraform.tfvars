resource_group = {
  rg1 = {
    rg_name    = "rg-qa-spoke"
    location   = "eastus"
    managed_by = "azurerm_user_assigned_identity.test"
    tags = {
      Environment = "qa"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}

virtual_network = {
  qa-spoke-Vnet = {
    vnet_name     = "qa-spoke-Vnet"
    rg_name       = "rg-qa-spoke"
    location      = "eastus"
    address_space = ["10.2.0.0/16"]
    tags = {
      Environment = "qa"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}

vnet_peerings = {}

subnet = {
  frontendsubnet = {
    subnet_name      = "frontendsubnet"
    vnet_name        = "qa-spoke-Vnet"
    rg_name          = "rg-qa-spoke"
    address_prefixes = ["10.2.1.0/24"]
  }

  backendsubnet = {
    subnet_name      = "backendsubnet"
    vnet_name        = "qa-spoke-Vnet"
    rg_name          = "rg-qa-spoke"
    address_prefixes = ["10.2.2.0/24"]
  }
}

network_nic = {
  nic1 = {
    nic_name                      = "frontnic"
    location                      = "eastus"
    rg_name                       = "rg-qa-spoke"
    ip_config_name                = "internal"
    private_ip_meth               = "Dynamic"
    subnet_name                   = "frontendsubnet"
    vnet_name                     = "qa-spoke-Vnet"
    nsg_key                       = "nsg1"
    enable_accelerated_networking = true
    tags = {
      Environment = "qa"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
  nic2 = {
    nic_name             = "backendnic"
    location             = "eastus"
    rg_name              = "rg-qa-spoke"
    ip_config_name       = "internal"
    private_ip_meth      = "Dynamic"
    subnet_name          = "backendsubnet"
    vnet_name            = "qa-spoke-Vnet"
    nsg_key              = "nsg2"
    enable_ip_forwarding = true
    tags = {
      Environment = "qa"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }  
}

vmss = {
  web_vmss = {
    vmss_name     = "mehar-web-vmss"
    rg_name       = "rg-qa-spoke"
    location      = "eastus"
    sku           = "Standard_DC1ds_v3"
    instances     = 2
    keyvault_name = "mehar-kv"
    subnet_name   = "frontendsubnet"
    vnet_name     = "qa-spoke-Vnet"
    tags = {
      Environment = "qa"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}
 
network_nsg = {
  nsg1 = {
    nsg_name = "front-nsg"
    location = "eastus"
    rg_name  = "rg-qa-spoke"
    rules = [
      {
        rule_name                  = "allow-http"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      Environment = "qa"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }

  nsg2 = {
    nsg_name = "backend-nsg"
    location = "eastus"
    rg_name  = "rg-qa-spoke"
    rules = [
      {
        rule_name                  = "allow-sql"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "10.2.1.0/24"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      Environment = "qa"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}

keyvaults = {
  kv-eastus = {
    keyvault_name              = "mehar-kv"
    location                   = "eastus"
    rg_name                    = "rg-qa-spoke"
    sku_name                   = "premium"
    soft_delete_retention_days = 30
    key_permissions            = ["Create", "Get", "List"]
    secret_permissions         = ["Set", "List", "Get", "Delete", "Recover"]

  }
}

secret = {
  username = {
    keyvault_name = "mehar-kv"
    rg_name       = "rg-qa-spoke"
    secret_name   = "vm-admin-username"
    length        = 8
    lower         = true
    upper         = false
    special       = false
  }
  password = {
    keyvault_name    = "mehar-kv"
    rg_name          = "rg-qa-spoke"
    secret_name      = "vm-admin-password"
    length           = 16
    special          = true
    override_special = "!@#"
  }
}