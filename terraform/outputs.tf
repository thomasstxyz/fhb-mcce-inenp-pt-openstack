output "floatingip_1_ip" {
  description = "ID of floatingip_1"
  value       = openstack_networking_floatingip_v2.floatingip_1.*.address
}
