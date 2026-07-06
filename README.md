# Azure VNET Terraform Module + Dev Environment

This repo automatically builds a small dev environment in Azure using Terraform.

## What it does

1. **A reusable network module** (`modules/vnet`) — a blueprint for creating an Azure Virtual Network with subnets and security rules. It's written so it can be reused for any environment (dev, staging, prod) just by changing inputs.

2. **A dev environment** (`environments/dev/eastus`) that uses that blueprint to create:
   - A resource group
   - A virtual network with one subnet
   - A security rule allowing SSH access
   - One Linux VM (Ubuntu) you can SSH into
   - One storage account (for the VM's boot diagnostics)

3. **A GitHub Actions pipeline** that automates it: opening a pull request shows a preview (`plan`) of what will change; merging that PR to `main` applies those changes to Azure automatically.

## Repo structure

azure-vnet-terraform/
├── modules/vnet/            # reusable network module
├── environments/dev/eastus/ # dev environment that uses the module
└── .github/workflows/       # plan-on-PR, apply-on-merge pipeline

## Usage

```bash
cd environments/dev/eastus
terraform init
terraform plan
terraform apply
```

To tear it down:

```bash
terraform destroy
```

See `DESIGN.md` for the reasoning behind the naming, tagging, resource group vs. subscription choice, and release lifecycle.

## Output

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

resource_group_name = "rg-dev-cin"
storage_account_name = "stdevcindiag"
subnet_ids = {
  "apptest" = "/subscriptions/4af04c58-ccfa-49db-b0a9-0aba79f704d6/resourceGroups/rg-dev-cin/providers/Microsoft.Network/virtualNetworks/vnet-dev-cin/subnets/apptest"
}
vm_public_ip = "20.235.114.247"
vnet_id = "/subscriptions/4af04c58-ccfa-49db-b0a9-0aba79f704d6/resourceGroups/rg-dev-cin/providers/Microsoft.Network/virtualNetworks/vnet-dev-cin"