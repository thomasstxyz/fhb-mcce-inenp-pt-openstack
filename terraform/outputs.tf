# Generate Ansible inventory
resource "local_file" "hosts" {
  content = templatefile("${path.module}/templates/hosts.tftpl",
    {
      kube_masters = openstack_networking_floatingip_v2.floatingip_kube_master.*.address
      kube_nodes = openstack_networking_floatingip_v2.floatingip_kube_node.*.address
    }
  )
  filename = "../ansible/inventory"
}

# Output IP addresses in console
output "floatingip_kube_master" {
  description = "Floating IP addresses of Kubernetes Masters"
  value       = openstack_networking_floatingip_v2.floatingip_kube_master.*.address
}

output "floatingip_kube_node" {
  description = "Floating IP addresses of Kubernetes Nodes"
  value       = openstack_networking_floatingip_v2.floatingip_kube_node.*.address
}
