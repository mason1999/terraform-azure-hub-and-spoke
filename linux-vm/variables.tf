variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group in which the Linux Virtual Machine should be exist. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure location where the Linux Virtual Machine should exist. Changing this forces a new resource to be created."
}

variable "suffix" {
  type        = string
  description = "(Required) The suffix to append to the name of all the resources in this module."
}

variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the subnet which the Linux Virtual Machine should attach to."
}

variable "enable_public_ip_address" {
  type        = bool
  description = "(Optional) Boolean flag to determine whether the Linux Virtual Machine should have a public ip address. Defaults to false. "
  default     = false
}

variable "private_ip_address_allocation" {
  type        = string
  description = "(Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static."
}

variable "private_ip_address" {
  type        = string
  description = "(Optional) The Static IP Address which should be used if private_ip_address_allocation is set to static."
}

variable "enable_ip_forwarding" {
  type        = bool
  description = "(Optional) Enable IP forwarding. Reccomended if you're linux vm operating as a network virtual appliance. Defaults to false."
  default     = false
}

variable "admin_username" {
  type        = string
  description = "(Required) The username of the local administrator used for the Linux Virtual Machine. Changing this forces a new resource to be created."
}

variable "admin_password" {
  type        = string
  description = "(Required) The Password which should be used for the local-administrator on this Linux Virtual Machine. Changing this forces a new resource to be created."
}

variable "identity" {
  description = <<EOF
  (Optional) A user assigned managed identity object block. Defaults to an empty object. The following attributes are supported

  type - (Required) Specifies the type of managed service identity that should be configured on this linux virtual machine. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).
  identity_ids - (Optional) Specifies a list of user assigned managed identity IDs to be assigned to this linux virtual machine. This is required when type is either UserAssgined or both UserAssigned and SystemAssigned.
  EOF
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  default = null
}

variable "run_init_script" {
  type        = bool
  description = "(Optional) Boolean flag to determine whether the Linux Virtual Machine should run the init script. Defaults to false. "
  default     = false
}
