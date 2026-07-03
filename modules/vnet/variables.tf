variable "resource_group_name" {
  description = "Name of the resource group where the VNET will be created."
  type        = string
}

variable "location" {
  description = "Azure region for the VNET."
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
}

variable "address_space" {
  description = "Address space for the VNET, e.g "10.0.0.0/16"
  type        = list(string)
}

variable "dns_servers" {
  description = "Optional custom DNS servers for the VNET. Leave empty to use Azure-provided DNS."
  type        = list(string)
  default     = []
}

variable "subnets" { 
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    delegation = optional(object({
      name                     = string
      service_delegation_name = string
      actions                  = list(string)
    }), null)
    create_nsg = optional(bool, true)
    nsg_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
  }))
}

variable "enable_ddos_protection" {
  description = "Whether to associate a DDoS Network Protection Plan with the VNET. Off by default because it carries significant cost - typically opted into only for prod."
  type        = bool
  default     = false
}

variable "ddos_protection_plan_id" {
  description = "Resource ID of an existing DDoS Protection Plan. Required only if enable_ddos_protection = true."
  type        = string
  default     = null

  validation {
    condition     = var.enable_ddos_protection == false || var.ddos_protection_plan_id != null
    error_message = "ddos_protection_plan_id must be set when enable_ddos_protection = true."
  }
}

variable "tags" {
  description = "Tags applied to every resource this module creates."
  type        = map(string)
  default     = {}
}
