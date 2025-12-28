# This file is automatically loaded by Terraform (due to .auto.tfvars extension)
# It defines the 'vms' variable of type map(object)
vms = {
  "web1" = {
    name    = "prod-web-01"
    cores   = 2
    memory  = 2048 # MB
    disk_gb = 25
    tags    = "web;prod"
  },
  "web2" = {
    name    = "prod-web-02"
    cores   = 2
    memory  = 2048 # MB
    disk_gb = 25
    tags    = "web;prod"
  },
  "db1" = {
    name    = "prod-db-01"
    cores   = 4
    memory  = 4096 # MB
    disk_gb = 50
    tags    = "db;prod"
  }
}
