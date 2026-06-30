variable "location" {
  type        = string
  description = "The Azure Region where resources will be deployed."
  default     = "southafricanorth"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the target Resource Group."
  default     = azurerm.resource_group.rg.name
}

variable "apps" {
  type = map(object({
    hostname = string
    ip       = list(string)
  }))
  description = "A complex map of workloads defining routing hostnames and target application backend IPs."
}