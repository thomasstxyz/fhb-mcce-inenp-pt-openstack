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

resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "a security group"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_port_v2" "port_1" {
  name               = "port_1"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    subnet_id  = "${openstack_networking_subnet_v2.subnet_1.id}"
    ip_address = "10.0.0.10"
  }
}

resource "openstack_compute_keypair_v2" "user_key" {
  name       = "user-key"
  public_key = var.public_key
}

resource "openstack_compute_instance_v2" "instance_1" {
  name            = "instance_1"
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]
  key_pair    = openstack_compute_keypair_v2.user_key.name

  user_data   = file("scripts/first-boot.sh")

  network {
    port = "${openstack_networking_port_v2.port_1.id}"
  }

  image_name  = "Ubuntu-20.04"
  flavor_name = "m1.large"

  block_device {
    source_type           = "image"
    uuid                  = "33c44345-6056-4634-80b9-04ae32fdf8e2"
    destination_type      = "volume"
    volume_size           = 8
    delete_on_termination = true
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "floatingip_1" {
  pool = data.openstack_networking_network_v2.provider_network.name
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "floatingip_1" {
  floating_ip = openstack_networking_floatingip_v2.floatingip_1.address
  instance_id = openstack_compute_instance_v2.instance_1.id
}
