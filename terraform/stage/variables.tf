variable "env" {}
variable "yc_token" {}
variable "yc_cloud_id" {}
variable "yc_folder_id" {}
variable "yc_zone" {}
variable "image_id" {}
variable "ssh_key_path" {}
variable "cidr_blocks" {
  type = list(string)
}

variable "master_name" {}

variable "k3s_nodes" {
  type = list(object({
    name     = string
    cores    = number
    memory   = number
    disk     = number
    fraction = number
    platform = string
  }))
}
