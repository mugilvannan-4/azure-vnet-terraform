# environments/dev/eastus/terraform.tfvars

environment    = "dev"
location       = "centralindia"
location_short = "cin"
owner          = "platform-team"

vm_admin_username = "azureadmin"
vm_size            = "Standard_D2as_v5"

# Paste the *content* of your public key file here (the .pub file, not the private key).
# On Windows PowerShell, get it with:
#   Get-Content "$env:USERPROFILE\.ssh\azure_dev_vm.pub" -Raw
vm_admin_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... your-key-here... user@host"