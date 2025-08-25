variable "vnet_name" {
  description = "Required. Virtual network name"
  type        = string
}

variable "location" {
  description = "The Azure region where the Bastion should be deployed"
  type        = string
  default     = ""
}

variable "subnet_list" {
  description = "A list of subnets"
  type        = list(string)
  default     = ["default"]
}

variable "network_cidr" {
  description = "Network CIDR"
  type        = string
  default     = "10.135.0.0/16"
}

variable "add_gateway_subnet" {
  description = "Create a VPN Gateway subnet. Only set to true if you intend to deploy a VPN"
  type        = bool
  default     = false
}

variable "add_bastion_subnet" {
  description = "Create a Bastion subnet. Only set to true if you intend to deploy Bastion to this network"
  type        = bool
  default     = false
}

variable "web_server_farm_delegation" {
  description = "Subnets listed will have webServerFarm Delegation"
  type        = list(string)
  default     = []
}

variable "dns_resolver_delegation" {
  description = "Subnets listed will have dnsResolverDelegation"
  type        = list(string)
  default     = []
}

variable "storage_global_endpoints" {
  description = "This subnet will have global storage endpoint instead of storage endpoint"
  type        = list(string)
  default     = [""]
}
