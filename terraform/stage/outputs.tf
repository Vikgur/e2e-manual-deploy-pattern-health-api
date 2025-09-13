output "external_ips" {
  value = module.vm.k3s_external_ips
}

output "master_ip" {
  value = module.vm.k3s_master_ip
}
