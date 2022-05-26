variable "public_key" {
  type = string
  default = ""
}

variable "kube_master_count" {
  default = 1
}

variable "kube_node_count" {
  default = 2
}