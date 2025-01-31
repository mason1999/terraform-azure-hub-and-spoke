locals {
  hub = {
    private_static_ip_address = "10.0.0.4"
    address_space             = "10.0.0.0"
  }
  spoke_1 = {
    private_static_ip_address = "10.1.0.4"
    address_space             = "10.1.0.0"
  }
  spoke_2 = {
    private_static_ip_address = "10.2.0.4"
    address_space             = "10.2.0.0"
  }
  spoke_3 = {
    private_static_ip_address = "10.3.0.4"
    address_space             = "10.3.0.0"
  }
  spoke_4 = {
    private_static_ip_address = "10.4.0.4"
    address_space             = "10.4.0.0"
  }
}
