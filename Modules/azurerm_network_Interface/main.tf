resource "azurerm_network_interface" "nic" {
  for_each = var.nics

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = data.azurerm_subnet.subnet[each.key].id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address_version    = try(ip_configuration.value.private_ip_address_version, null)
      # public_ip_address_id                               = data.azurerm_public_ip.pip[each.key].id
      gateway_load_balancer_frontend_ip_configuration_id = try(ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id, null)
      primary                                            = try(ip_configuration.value.primary, null)
      private_ip_address                                 = try(ip_configuration.value.private_ip_address, null)
    }
  }

  auxiliary_mode                 = try(each.value.auxiliary_mode, null)
  auxiliary_sku                  = try(each.value.auxiliary_sku, null)
  dns_servers                    = try(each.value.dns_servers, null)
  edge_zone                      = try(each.value.edge_zone, null)
  ip_forwarding_enabled          = try(each.value.ip_forwarding_enabled, false)
  accelerated_networking_enabled = try(each.value.accelerated_networking_enabled, false)
  internal_dns_name_label        = try(each.value.internal_dns_name_label, null)
  tags                           = try(each.value.tags, null)
}

















