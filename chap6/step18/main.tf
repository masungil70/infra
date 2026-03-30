module "proxmox_servers" {
  source = "./modules/proxmox_vm"

  # Pass the variables to the module
  vms              = var.vms
  proxmox_node     = var.proxmox_node
  template_name    = var.template_name
  ssh_public_key   = var.ssh_public_key
  ciuser           = var.ciuser
  cipassword       = var.cipassword
}