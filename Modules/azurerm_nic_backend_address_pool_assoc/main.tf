resource "azurerm_network_interface_backend_address_pool_association" "nic1_bpepool_assoc" {
  for_each                = var.nic_ba_pool_assoc
  network_interface_id    = data.azurerm_network_interface.nic[each.key].id
  ip_configuration_name   = each.value.ip_configuration_name # yeh confirm karna ki NIC ke andar ip_config ka naam kya hai
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.bpepool[each.key].id
}







