resource "openstack_compute_keypair_v2" "user_key" {
  name       = "user-key"
  public_key = var.public_key
}
