variable "location" { 
    type = string 
}
variable "resource_group_name" {
    type = string 
}
variable "vnet_subnet_id" {
  type        = string
  description = "The subnet ID passed from the network module output."
}