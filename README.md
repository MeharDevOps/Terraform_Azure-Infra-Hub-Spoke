# Azure Hub-Spoke Infrastructure with Terraform

Production-ready, modular Terraform codebase deploying a **Hub-Spoke Network Architecture** on Microsoft Azure. The repository features isolated multi-environment deployments (**Dev**, **QA**, **Prod**) connected to a centralized **Hub VNet** hosting Shared Services (Azure Firewall & Azure Bastion).

---

## 🏛️ Architecture Overview

```
                      +----------------------------------+
                      |         Hub VNet (10.0.0.0/16)   |
                      |  - AzureFirewallSubnet           |
                      |  - AzureBastionSubnet            |
                      |  - GatewaySubnet                 |
                      +----------------------------------+
                                       |
           +---------------------------+---------------------------+
           |                           |                           |
+----------------------+   +----------------------+   +----------------------+
| Spoke Dev            |   | Spoke QA             |   | Spoke Prod           |
| (10.1.0.0/16)        |   | (10.2.0.0/16)        |   | (10.3.0.0/16)        |
| - frontendsubnet     |   | - frontendsubnet     |   | - frontendsubnet     |
| - backendsubnet      |   | - backendsubnet      |   | - backendsubnet      |
| - VM Scale Sets      |   | - VM Scale Sets      |   | - VM Scale Sets      |
| - Azure Key Vault    |   | - Azure Key Vault    |   | - Azure Key Vault    |
+----------------------+   +----------------------+   +----------------------+
```

### Key Highlights
- **Centralized Hub Architecture**: Shared network services (Firewall, Bastion, Gateway) managed independently in `Environments/Hub-Vnet`.
- **Environment Isolation**: Dedicated Spoke VNets for `Dev`, `QA`, and `Prod` with strict network boundary controls.
- **Non-Overlapping IP Addressing**: Standardized, clean CIDR block allocation allowing seamless VNet Peering.
- **Modular Design**: Reusable terraform child modules located under `Child_Module/`.
- **Security First**: Secrets dynamically generated via `random` provider and stored in Azure Key Vault; NSGs enforce least privilege access.

---

## 📁 Repository Structure

```
.
├── Child_Module/                       # Reusable infrastructure child modules
│   ├── azurerm-application-gateway/    # Azure Application Gateway module
│   ├── azurerm_bastion/                # Azure Bastion Host & Subnet module
│   ├── azurerm_firewall/               # Azure Firewall & IP configuration module
│   ├── azurerm_keyvault/               # Azure Key Vault module
│   ├── azurerm_kubernetes_cluster/     # Azure Kubernetes Service (AKS) module
│   ├── azurerm_NetworkInterface/       # Network Interface (NIC) module
│   ├── azurerm_Network_Security_Group/ # NSG rules & NIC association module
│   ├── azurerm_public_ip/              # Public IP (PIP) module
│   ├── azurerm_resource_group/         # Resource Group module
│   ├── azurerm_storage_account/        # Storage Account module
│   ├── azurerm_subnet/                 # Subnet delegation & policies module
│   ├── azurerm_virtual_network/        # Virtual Network & outputs module
│   ├── azurerm_vm_secrets/             # Random secrets & Key Vault secrets module
│   ├── azurerm_vmss/                   # Linux Virtual Machine Scale Set module
│   └── azurerm_vnet_peering/           # VNet Peering module
└── Environments/                       # Environment root deployments
    ├── Hub-Vnet/                       # Hub network deployment configuration
    ├── Spoke-Dev/                      # Development spoke environment
    ├── Spoke-QA/                       # QA spoke environment
    └── Spoke-Prod/                     # Production spoke environment
```

---

## 🌐 Network Addressing Plan

| Environment | Resource Group | Virtual Network | CIDR Block | Subnets | Subnet Ranges |
|---|---|---|---|---|---|
| **Hub** | `rg-hub-network` | `HubVnet` | `10.0.0.0/16` | `AzureFirewallSubnet`<br>`GatewaySubnet`<br>`AzureBastionSubnet` | `10.0.0.0/26`<br>`10.0.1.0/27`<br>`10.0.2.0/26` |
| **Dev Spoke** | `rg-dev-spoke` | `dev-spoke-Vnet` | `10.1.0.0/16` | `frontendsubnet`<br>`backendsubnet` | `10.1.1.0/24`<br>`10.1.2.0/24` |
| **QA Spoke** | `rg-qa-spoke` | `qa-spoke-Vnet` | `10.2.0.0/16` | `frontendsubnet`<br>`backendsubnet` | `10.2.1.0/24`<br>`10.2.2.0/24` |
| **Prod Spoke** | `rg-prod-spoke` | `prod-spoke-Vnet` | `10.3.0.0/16` | `frontendsubnet`<br>`backendsubnet` | `10.3.1.0/24`<br>`10.3.2.0/24` |

---

## 📋 Prerequisites

Ensure the following tools are installed on your machine:

- [Terraform](https://www.terraform.io/downloads) `>= 1.0.0`
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) `>= 2.40.0`
- An active **Azure Subscription**

---

## 🚀 Deployment Instructions

### 1. Authenticate to Azure

```bash
az login
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

### 2. Deploy Hub Environment (Core Network & Shared Services)

```bash
cd Environments/Hub-Vnet
terraform init
terraform plan
terraform apply -auto-approve
```

### 3. Deploy Spoke Environments

Navigate to any spoke environment folder to deploy infrastructure:

#### Development Environment
```bash
cd Environments/Spoke-Dev
terraform init
terraform plan
terraform apply -auto-approve
```

#### QA Environment
```bash
cd Environments/Spoke-QA
terraform init
terraform plan
terraform apply -auto-approve
```

#### Production Environment
```bash
cd Environments/Spoke-Prod
terraform init
terraform plan
terraform apply -auto-approve
```

---

## 🔒 Security & Best Practices

1. **Key Vault Secrets Management**: VM passwords and usernames are auto-generated via Terraform `random` providers and securely stored in Azure Key Vault.
2. **Network Security Rules**: Backend database rules restrict incoming traffic (e.g., MSSQL port `1433`) strictly to internal frontend subnet IP ranges.
3. **Location Consistency**: All resources across modules use standardized Azure region slugs (e.g., `eastus`).

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
