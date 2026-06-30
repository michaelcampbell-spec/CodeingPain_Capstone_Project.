locals {
    tags = {
    managed_by = "terraform"
    module = "app_gateway"
  }

 
}

resource "azurerm_public_ip" "appgw" {
  name                = "${var.appgw_name}-publicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1 
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
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

  backend_http_settings {
    name                  = "default-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

# 1. Dynamic Backend Pools (One for each app)
  dynamic "backend_address_pool" {
    for_each = var.apps
    content {
      name         = "${backend_address_pool.key}-backend-pool"
      ip_addresses = backend_address_pool.value.ip
    }
  }

  # 2. Dynamic HTTP Listeners (One for each domain hostname)
  dynamic "http_listener" {
    for_each = var.apps
    content {
      name                           = "${http_listener.key}-listener"
      frontend_ip_configuration_name = "frontend-ip"
      frontend_port_name             = "http-port"
      protocol                       = "Http"
      host_name                      = http_listener.value.hostname
    }
  }

  # 3. Dynamic Routing Rules (Maps each listener to its specific backend pool)
  dynamic "request_routing_rule" {
    for_each = var.apps
    content {
      name                       = "${request_routing_rule.key}-routing-rule"
      rule_type                  = "Basic"
      priority                   = 100 + index(keys(var.apps), request_routing_rule.key)
      http_listener_name         = "${request_routing_rule.key}-listener"
      backend_address_pool_name  = "${request_routing_rule.key}-backend-pool"
      backend_http_settings_name = "default-http-settings"
    }
  }
}