locals {
  tags = {
    managed_by = "terraform"
    module = "app_gateway"
  }
}
resource "azurerm_public_ip" "appgw" {
  name = "${var.appgw_name}-pip"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
  sku = "Standard"
}
resource "azurerm_application_gateway" "appgw" {
  name = var.appgw_name
  location = var.location
  resource_group_name = var.resource_group_name
  tags = local.tags
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration {
    name = "gateway-ip-config"
    subnet_id = var.subnet_id
  }
  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }
  frontend_port {
    name = "http-port"
    port = 80
  }
  dynamic "backend_address_pool" {
    for_each = var.backend_pools
    content {
      name = backend_address_pool.key
      ip_addresses = backend_address_pool.value.ip_addresses
    }
  }
  backend_http_settings {
    name                  = "default-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }
  dynamic "http_listener" {
    for_each = var.listeners
    content {
      name = http_listener.key
      frontend_ip_configuration_name = "frontend-ip"
      frontend_port_name = "http-port"
      protocol = "Http"
      host_name = http_listener.value.host_name
    }
  }
  request_routing_rule {
    name                       = "default-rule"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = keys(var.listeners)[0]
    backend_address_pool_name  = keys(var.backend_pools)[0]
    backend_http_settings_name = "default-http-settings"
  }
}
