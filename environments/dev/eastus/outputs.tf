output "resource_group_name" {
  description = "Name of the resource group holding this environment - handy for `az` CLI commands / portal links."
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "VNET resource ID - needed if another environment/module wants to peer with this network."
  value       = module.vnet.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet name => ID - used by any future resource that needs to attach to a specific subnet."
  value       = module.vnet.subnet_ids
}

output "vm_public_ip" {
  description = "Public IP of the dev VM, for SSH access during development."
  value       = azurerm_public_ip.vm.ip_address
}

output "storage_account_name" {
  description = "Name of the diagnostics storage account, for troubleshooting VM boot issues."
  value       = azurerm_storage_account.diag.name
}
