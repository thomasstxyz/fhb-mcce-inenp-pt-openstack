data "openstack_networking_network_v2" "provider_network" {
  name = "provider"
}

resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "10.0.0.0/24"
  ip_version = 4
}

resource "openstack_networking_router_v2" "generic" {
  name                = "router-generic"
  external_network_id = "${data.openstack_networking_network_v2.provider_network.id}"
}

# Router interface configuration
resource "openstack_networking_router_interface_v2" "http" {
  router_id = openstack_networking_router_v2.generic.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}
