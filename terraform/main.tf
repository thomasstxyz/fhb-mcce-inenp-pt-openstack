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
