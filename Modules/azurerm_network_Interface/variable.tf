variable "nics" {
  type = map(object({
    name                 = string
    location             = string
    resource_group_name  = string
    virtual_network_name = optional(string)
    subnet_name          = optional(string)
    pip_name             = optional(string)

    ip_configuration = map(object({
      name                                               = string
      private_ip_address_allocation                      = string
      private_ip_address_version                         = optional(string)
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
      primary                                            = optional(bool)
      private_ip_address                                 = optional(string)
    }))

    auxiliary_mode                 = optional(string)
    auxiliary_sku                  = optional(string)
    dns_servers                    = optional(list(string))
    edge_zone                      = optional(string)
    ip_forwarding_enabled          = optional(bool)
    accelerated_networking_enabled = optional(bool)
    internal_dns_name_label        = optional(string)
    tags                           = optional(map(string))
  }))
}














