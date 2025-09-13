module "network" {
  source       = "../modules/network"
  env          = var.env
  yc_zone      = var.yc_zone
  cidr_blocks  = var.cidr_blocks

  providers = {
    yandex = yandex
  }
}

module "vm" {
  source        = "../modules/vm"
  nodes         = var.k3s_nodes
  yc_zone       = var.yc_zone
  image_id      = var.image_id
  subnet_id     = module.network.this_subnet_id
  ssh_key_path  = var.ssh_key_path
  master_name   = var.master_name
  env           = var.env

  providers = {
    yandex = yandex
  }
}
