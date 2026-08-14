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

  pe_subnet = {
    subnet_name      = "pe-subnet"
    vnet_name        = "HubVnet"
    rg_name          = "rg-hub-network"
    address_prefixes = ["10.0.3.0/24"]
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
  appgw_pip = {
    pip_name          = "appgw-pip"
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
    firewall_name = "firewall1"
    rg_name       = "rg-hub-network"
    location      = "eastus"
    sku_name      = "AZFW_VNet"
    sku_tier      = "Standard"
    pip_name      = "firewall-pip"
    vnet_name     = "HubVnet"
    subnet_name   = "AzureFirewallSubnet"
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

application_gateways = {
  appgw1 = {
    name        = "hub-appgateway"
    rg_name     = "rg-hub-network"
    location    = "eastus"
    pip_name    = "appgw-pip"
    subnet_name = "GatewaySubnet"
    vnet_name   = "HubVnet"

    sku = {
      name     = "Standard_v2"
      tier     = "Standard_v2"
      capacity = 2
    }

    gateway_ip_configuration = {
      name = "appGatewayIpConfig"
    }

    frontend_ports = {
      http_port = {
        name = "http-port"
        port = 80
      }
    }

    frontend_ip_configurations = {
      frontend_ip = {
        name = "appGatewayFrontendIP"
      }
    }

    backend_address_pools = {
      backend_pool = {
        name = "appGatewayBackendPool"
      }
    }

    backend_http_settings = {
      http_setting = {
        name                  = "appGatewayBackendHttpSettings"
        cookie_based_affinity = "Disabled"
        path                  = "/"
        port                  = 80
        protocol              = "Http"
        request_timeout       = 60
      }
    }

    http_listeners = {
      listener = {
        name               = "appGatewayHttpListener"
        ip_config_name     = "appGatewayFrontendIP"
        frontend_port_name = "http-port"
        protocol           = "Http"
      }
    }

    request_routing_rules = {
      rule = {
        name                       = "appGatewayRule"
        priority                   = 1
        rule_type                  = "Basic"
        http_listener_name         = "appGatewayHttpListener"
        backend_address_pool_name  = "appGatewayBackendPool"
        backend_http_settings_name = "appGatewayBackendHttpSettings"
      }
    }

    vm_backend_association = {}
  }
}

network_nic = {}

storage_account = {
  sa1 = {
    name                     = "sthubappdemo01"
    resource_group_name      = "rg-hub-network"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    access_tier              = "Hot"
    tags = {
      Environment = "hub"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}

private_endpoints = {
  pe_blob = {
    pe_name        = "pe-sthubappdemo01-blob"
    location    = "eastus"
    rg_name     = "rg-hub-network"
    vnet_name   = "HubVnet"
    subnet_name = "pe-subnet"
    private_service_connection = {
      name                 = "psc-sthubappdemo01-blob"
      target_resource_key  = "sa1"
      subresource_names    = ["blob"]
      is_manual_connection = false
    }
    tags = {
      Environment = "hub"
      Project     = "My-demoapp"
      ManagedBy   = "Terraform"
    }
  }
}


sql_data_server = {
  sql1 = {
    sql_server_name  = "appsql1"
    rg_name          = "rg-hub-network"
    location         = "eastus"
    version          = "12.0"
    userlogin        = "sqladmin"
    userpassword     = "MyStrongPassword123!"
    minimum_version  = "1.2"
  }
}

sql_database = {
  database1 = {
    db_name         = "appdb01"
    server_key      = "sql1"
    sku_name        = "S0"
    max_size_gb     = 10
    sql_server_name = "appsql1"
    rg_name         = "rg-hub-network"
  }
}


  