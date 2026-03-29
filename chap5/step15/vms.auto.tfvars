# 생성할 VM들의 정보를 맵(map) 형태로 정의
vms = {
  "web1" = {
    name    = "production-web-01"
    cores   = 2
    memory  = 2048
    disk_gb = 25
    tags    = "web;prod"
  },
  "web2" = {
    name    = "production-web-02"
    cores   = 2
    memory  = 2048
    disk_gb = 25
    tags    = "web;prod"
  },
  "db1" = {
    name    = "production-db-01"
    cores   = 4
    memory  = 4096
    disk_gb = 50
    tags    = "db;prod"
  }
}
