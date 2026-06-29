variable "appgw_name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "backend_pools" {
  type = map(object({
    ip_addresses = list(string)
  }))
}
variable "listeners" {
  type = map(object({
    host_name = string
  }))
}
