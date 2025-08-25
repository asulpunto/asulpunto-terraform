
locals {
  private_ip_pref = split(var.network_cidr, ".")
  start_ip        = tonumber(local.private_ip_pref[2])

  subnets = var.add_gateway_subnet ? concat(var.subnet_list, ["GatewaySubnet"]) : var.subnet_list
  subnets2 = var.add_bastion_subnet ? concat(local.subnets, ["AzureBastionSubnet"]) : local.subnets

  subnet_configs = [
    for idx, subnet_name in local.subnets2 : {
      name           = subnet_name
      address_prefix = "${local.private_ip_pref[0]}.${local.private_ip_pref[1]}.${idx + local.start_ip}.0/24"
      service_endpoints = [
        contains(var.storage_global_endpoints, subnet_name) ? "Microsoft.Storage.Global" : "Microsoft.Storage",
        "Microsoft.KeyVault",
        "Microsoft.Sql",
        "Microsoft.Web"
      ]
      delegation = contains(var.web_server_farm_delegation, subnet_name) ? {
        name = "Microsoft.Web/serverFarms"
        service_delegation = {
          name = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      } : contains(var.dns_resolver_delegation, subnet_name) ? {
        name = "Microsoft.Network/dnsResolvers"
        service_delegation = {
          name = "Microsoft.Network/dnsResolvers"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      } : null
    }
  ]
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location != "" ? var.location : data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  address_space = [var.network_cidr]
}

resource "azurerm_subnet" "this" {
  for_each             = { for s in local.subnet_configs : s.name => s }
  name                 = each.value.name
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]

  service_endpoints    = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

