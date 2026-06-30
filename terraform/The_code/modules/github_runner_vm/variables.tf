variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "virtual_machines" {
  type = map(object({
    size = string
    private_ip_address_allocation = string
  }))
}
