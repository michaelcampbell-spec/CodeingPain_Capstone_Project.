variable "location" {
  type        = string
  description = "The Azure region for the Application Gateway."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the gateway will be deployed."
}

variable "appgw_name" {
  type        = string
  description = "The name of the Application Gateway."
}

variable "subnet_id" {
  type        = string
  description = "The dedicated subnet ID passed from the network module output."
}

variable "listeners" {
  type = map(object({
    hostname = string
    ip       = list(string)
  }))
  description = "The application map passed down from the root variable."
}