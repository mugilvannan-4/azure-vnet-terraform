variable "environment" {
  description = "Environment name. Drives resource names and tags."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region, full name (used in `location = ` arguments)."
  type        = string
  default     = "eastus"
}

variable "location_short" {
  description = "Short code for the region, used in resource names to keep them within Azure length limits (e.g. eastus -> eus)."
  type        = string
  default     = "eus"
}

variable "owner" {
  description = "Team or individual accountable for these resources - lands in the 'owner' tag."
  type        = string
  default     = "platform-team"
}

variable "vm_admin_username" {
  description = "Admin username for the dev VM."
  type        = string
  default     = "azureadmin"
}

variable "vm_admin_ssh_public_key" {
  description = "SSH public key for the dev VM admin user. Passed in via CI secret, never committed."
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "VM SKU. Small/cheap by default since this is a dev box."
  type        = string
  default     = "Standard_B1s"
}
