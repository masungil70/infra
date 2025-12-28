module "proxmox_server" {
  source = "./modules/proxmox_vm"

  vm_name       = var.vm_name
  proxmox_node  = var.proxmox_node
  template_name = var.template_name
  ciValue       = var.ciValue
}
