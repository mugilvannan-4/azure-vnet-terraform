output "vnet_id" {
  description = "Resource ID of the created VNET. Needed by anything that peers with, or attaches resources to, this network (e.g. private DNS zone links, peering)."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the created VNET."
  value       = azurerm_virtual_network.this.name
}

output "vnet_address_space" {
  description = "Address space of the VNET. Useful for downstream modules that need to avoid CIDR overlap (e.g. VPN/ExpressRoute routing, peering)."
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_ids" {
  description = "Map of subnet name => subnet resource ID. Consuming code (e.g. a VM's NIC) looks up the subnet it needs by name from this map."
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "nsg_ids" {
  description = "Map of subnet name => associated NSG resource ID, for subnets where create_nsg = true. Useful for attaching extra rules or diagnostic settings outside the module."
  value       = { for k, v in azurerm_network_security_group.this : k => v.id }
}
