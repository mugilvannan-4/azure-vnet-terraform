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

Run `terraform apply` (or `terraform output` afterwards) and paste the actual result here: