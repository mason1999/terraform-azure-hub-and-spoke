########## Resource Groups ##########
resource "azurerm_resource_group" "hub_rg" {
  name     = "hub-rg"
  location = "australiaeast"
}
resource "azurerm_resource_group" "spoke_1_rg" {
  name     = "spoke-1-rg"
  location = "australiaeast"
}

resource "azurerm_resource_group" "spoke_2_rg" {
  name     = "spoke-2-rg"
  location = "australiaeast"
}

resource "azurerm_resource_group" "spoke_3_rg" {
  name     = "spoke-3-rg"
  location = "australiaeast"
}

resource "azurerm_resource_group" "spoke_4_rg" {
  name     = "spoke-4-rg"
  location = "australiaeast"
}

########## Hub Virtual Network and VM ##########
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "hub-vnet"
  address_space       = ["${local.hub.address_space}/16"]
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
}

resource "azurerm_subnet" "hub_subnet" {
  name                 = "hub-subnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["${local.hub.address_space}/24"]
}

resource "azurerm_network_security_group" "hub_nsg" {
  name                = "hub-nsg"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
}

resource "azurerm_network_security_rule" "hub_network_security_rule" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = local.hub.private_static_ip_address
  resource_group_name         = azurerm_resource_group.hub_rg.name
  network_security_group_name = azurerm_network_security_group.hub_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "hub_nsg_association" {
  subnet_id                 = azurerm_subnet.hub_subnet.id
  network_security_group_id = azurerm_network_security_group.hub_nsg.id
}

module "hub_linux_vm" {
  source                        = "./linux-vm"
  resource_group_name           = azurerm_resource_group.hub_rg.name
  location                      = azurerm_resource_group.hub_rg.location
  admin_username                = "hub-user"
  admin_password                = "HelloWorld123"
  enable_public_ip_address      = true
  private_ip_address            = local.hub.private_static_ip_address
  private_ip_address_allocation = "Static"
  run_init_script               = true
  suffix                        = "hub"
  subnet_id                     = azurerm_subnet.hub_subnet.id
  enable_ip_forwarding          = true
}

########## Spoke 1 Virtual Network and VM ##########
resource "azurerm_virtual_network" "spoke_1_vnet" {
  name                = "spoke-1-vnet"
  address_space       = ["${local.spoke_1.address_space}/16"]
  location            = azurerm_resource_group.spoke_1_rg.location
  resource_group_name = azurerm_resource_group.spoke_1_rg.name
}

resource "azurerm_subnet" "spoke_1_subnet" {
  name                 = "spoke-1-subnet"
  resource_group_name  = azurerm_resource_group.spoke_1_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_1_vnet.name
  address_prefixes     = ["${local.spoke_1.address_space}/24"]
}

resource "azurerm_network_security_group" "spoke_1_nsg" {
  name                = "spoke-1-nsg"
  location            = azurerm_resource_group.spoke_1_rg.location
  resource_group_name = azurerm_resource_group.spoke_1_rg.name
}

resource "azurerm_network_security_rule" "spoke_1_network_security_rule" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = local.spoke_1.private_static_ip_address
  resource_group_name         = azurerm_resource_group.spoke_1_rg.name
  network_security_group_name = azurerm_network_security_group.spoke_1_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "spoke_1_nsg_association" {
  subnet_id                 = azurerm_subnet.spoke_1_subnet.id
  network_security_group_id = azurerm_network_security_group.spoke_1_nsg.id
}

resource "azurerm_route_table" "spoke_1_route_table" {
  name                = "spoke-1-route-table"
  location            = azurerm_resource_group.spoke_1_rg.location
  resource_group_name = azurerm_resource_group.spoke_1_rg.name

  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.hub.private_static_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "spoke_1_route_table_subnet_association" {
  subnet_id      = azurerm_subnet.spoke_1_subnet.id
  route_table_id = azurerm_route_table.spoke_1_route_table.id
}

module "spoke_1_linux_vm" {
  source                        = "./linux-vm"
  resource_group_name           = azurerm_resource_group.spoke_1_rg.name
  location                      = azurerm_resource_group.spoke_1_rg.location
  admin_username                = "spoke-1-user"
  admin_password                = "HelloWorld123"
  enable_public_ip_address      = false
  private_ip_address            = local.spoke_1.private_static_ip_address
  private_ip_address_allocation = "Static"
  run_init_script               = false
  suffix                        = "spoke-1"
  subnet_id                     = azurerm_subnet.spoke_1_subnet.id
}

resource "azurerm_virtual_network_peering" "peer_hub_to_spoke_1" {
  name                      = "peer-hub-to-spoke-1"
  resource_group_name       = azurerm_resource_group.hub_rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_1_vnet.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peer_spoke_1_to_hub" {
  name                      = "peer-spoke-1-to-hub"
  resource_group_name       = azurerm_resource_group.spoke_1_rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_1_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic   = true
}

########## Spoke 2 Virtual Network and VM ##########
resource "azurerm_virtual_network" "spoke_2_vnet" {
  name                = "spoke-2-vnet"
  address_space       = ["${local.spoke_2.address_space}/16"]
  location            = azurerm_resource_group.spoke_2_rg.location
  resource_group_name = azurerm_resource_group.spoke_2_rg.name
}

resource "azurerm_subnet" "spoke_2_subnet" {
  name                 = "spoke-2-subnet"
  resource_group_name  = azurerm_resource_group.spoke_2_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_2_vnet.name
  address_prefixes     = ["${local.spoke_2.address_space}/24"]
}

resource "azurerm_network_security_group" "spoke_2_nsg" {
  name                = "spoke-2-nsg"
  location            = azurerm_resource_group.spoke_2_rg.location
  resource_group_name = azurerm_resource_group.spoke_2_rg.name
}

resource "azurerm_network_security_rule" "spoke_2_network_security_rule" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = local.spoke_2.private_static_ip_address
  resource_group_name         = azurerm_resource_group.spoke_2_rg.name
  network_security_group_name = azurerm_network_security_group.spoke_2_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "spoke_2_nsg_association" {
  subnet_id                 = azurerm_subnet.spoke_2_subnet.id
  network_security_group_id = azurerm_network_security_group.spoke_2_nsg.id
}

resource "azurerm_route_table" "spoke_2_route_table" {
  name                = "spoke-2-route-table"
  location            = azurerm_resource_group.spoke_2_rg.location
  resource_group_name = azurerm_resource_group.spoke_2_rg.name

  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.hub.private_static_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "spoke_2_route_table_subnet_association" {
  subnet_id      = azurerm_subnet.spoke_2_subnet.id
  route_table_id = azurerm_route_table.spoke_2_route_table.id
}


module "spoke_2_linux_vm" {
  source                        = "./linux-vm"
  resource_group_name           = azurerm_resource_group.spoke_2_rg.name
  location                      = azurerm_resource_group.spoke_2_rg.location
  admin_username                = "spoke-2-user"
  admin_password                = "HelloWorld123"
  enable_public_ip_address      = false
  private_ip_address            = local.spoke_2.private_static_ip_address
  private_ip_address_allocation = "Static"
  run_init_script               = false
  suffix                        = "spoke-2"
  subnet_id                     = azurerm_subnet.spoke_2_subnet.id
}

resource "azurerm_virtual_network_peering" "peer_hub_to_spoke_2" {
  name                      = "peer-hub-to-spoke-2"
  resource_group_name       = azurerm_resource_group.hub_rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_2_vnet.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peer_spoke_2_to_hub" {
  name                      = "peer-spoke-2-to-hub"
  resource_group_name       = azurerm_resource_group.spoke_2_rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_2_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic   = true
}
########## Spoke 3 Virtual Network and VM ##########
resource "azurerm_virtual_network" "spoke_3_vnet" {
  name                = "spoke-3-vnet"
  address_space       = ["${local.spoke_3.address_space}/16"]
  location            = azurerm_resource_group.spoke_3_rg.location
  resource_group_name = azurerm_resource_group.spoke_3_rg.name
}

resource "azurerm_subnet" "spoke_3_subnet" {
  name                 = "spoke-3-subnet"
  resource_group_name  = azurerm_resource_group.spoke_3_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_3_vnet.name
  address_prefixes     = ["${local.spoke_3.address_space}/24"]
}

resource "azurerm_network_security_group" "spoke_3_nsg" {
  name                = "spoke-3-nsg"
  location            = azurerm_resource_group.spoke_3_rg.location
  resource_group_name = azurerm_resource_group.spoke_3_rg.name
}

resource "azurerm_network_security_rule" "spoke_3_network_security_rule" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = local.spoke_3.private_static_ip_address
  resource_group_name         = azurerm_resource_group.spoke_3_rg.name
  network_security_group_name = azurerm_network_security_group.spoke_3_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "spoke_3_nsg_association" {
  subnet_id                 = azurerm_subnet.spoke_3_subnet.id
  network_security_group_id = azurerm_network_security_group.spoke_3_nsg.id
}

resource "azurerm_route_table" "spoke_3_route_table" {
  name                = "spoke-3-route-table"
  location            = azurerm_resource_group.spoke_3_rg.location
  resource_group_name = azurerm_resource_group.spoke_3_rg.name

  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.hub.private_static_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "spoke_3_route_table_subnet_association" {
  subnet_id      = azurerm_subnet.spoke_3_subnet.id
  route_table_id = azurerm_route_table.spoke_3_route_table.id
}

module "spoke_3_linux_vm" {
  source                        = "./linux-vm"
  resource_group_name           = azurerm_resource_group.spoke_3_rg.name
  location                      = azurerm_resource_group.spoke_3_rg.location
  admin_username                = "spoke-3-user"
  admin_password                = "HelloWorld123"
  enable_public_ip_address      = false
  private_ip_address            = local.spoke_3.private_static_ip_address
  private_ip_address_allocation = "Static"
  run_init_script               = false
  suffix                        = "spoke-3"
  subnet_id                     = azurerm_subnet.spoke_3_subnet.id
}

resource "azurerm_virtual_network_peering" "peer_hub_to_spoke_3" {
  name                      = "peer-hub-to-spoke-3"
  resource_group_name       = azurerm_resource_group.hub_rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_3_vnet.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peer_spoke_3_to_hub" {
  name                      = "peer-spoke-3-to-hub"
  resource_group_name       = azurerm_resource_group.spoke_3_rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_3_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic   = true
}
########## Spoke 4 Virtual Network and VM ##########
resource "azurerm_virtual_network" "spoke_4_vnet" {
  name                = "spoke-4-vnet"
  address_space       = ["${local.spoke_4.address_space}/16"]
  location            = azurerm_resource_group.spoke_4_rg.location
  resource_group_name = azurerm_resource_group.spoke_4_rg.name
}

resource "azurerm_subnet" "spoke_4_subnet" {
  name                 = "spoke-4-subnet"
  resource_group_name  = azurerm_resource_group.spoke_4_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_4_vnet.name
  address_prefixes     = ["${local.spoke_4.address_space}/24"]
}

resource "azurerm_network_security_group" "spoke_4_nsg" {
  name                = "spoke-4-nsg"
  location            = azurerm_resource_group.spoke_4_rg.location
  resource_group_name = azurerm_resource_group.spoke_4_rg.name
}

resource "azurerm_network_security_rule" "spoke_4_network_security_rule" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = local.spoke_4.private_static_ip_address
  resource_group_name         = azurerm_resource_group.spoke_4_rg.name
  network_security_group_name = azurerm_network_security_group.spoke_4_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "spoke_4_nsg_association" {
  subnet_id                 = azurerm_subnet.spoke_4_subnet.id
  network_security_group_id = azurerm_network_security_group.spoke_4_nsg.id
}

resource "azurerm_route_table" "spoke_4_route_table" {
  name                = "spoke-4-route-table"
  location            = azurerm_resource_group.spoke_4_rg.location
  resource_group_name = azurerm_resource_group.spoke_4_rg.name

  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.hub.private_static_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "spoke_4_route_table_subnet_association" {
  subnet_id      = azurerm_subnet.spoke_4_subnet.id
  route_table_id = azurerm_route_table.spoke_4_route_table.id
}

module "spoke_4_linux_vm" {
  source                        = "./linux-vm"
  resource_group_name           = azurerm_resource_group.spoke_4_rg.name
  location                      = azurerm_resource_group.spoke_4_rg.location
  admin_username                = "spoke-4-user"
  admin_password                = "HelloWorld123"
  enable_public_ip_address      = false
  private_ip_address            = local.spoke_4.private_static_ip_address
  private_ip_address_allocation = "Static"
  run_init_script               = false
  suffix                        = "spoke-4"
  subnet_id                     = azurerm_subnet.spoke_4_subnet.id
}

resource "azurerm_virtual_network_peering" "peer_hub_to_spoke_4" {
  name                      = "peer-hub-to-spoke-4"
  resource_group_name       = azurerm_resource_group.hub_rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_4_vnet.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peer_spoke_4_to_hub" {
  name                      = "peer-spoke-4-to-hub"
  resource_group_name       = azurerm_resource_group.spoke_4_rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_4_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic   = true
}
