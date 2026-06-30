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
  description = "The VM administrator username retrieved from Key Vault."
}
variable "admin_password" {
  type        = string
  description = "The VM administrator password retrieved from Key Vault."
  sensitive   = true # Hides the value in your console terminal logs
}
