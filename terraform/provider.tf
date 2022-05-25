terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.47.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  project_domain_name = "Default"
  auth_url    = "http://172.20.41.1:5000/v3/"
}
