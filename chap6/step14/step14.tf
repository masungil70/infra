# Proxmox VM 리소스 정의
resource "proxmox_vm_qemu" "ubuntu_vm" {
  # toset(var.static_ips) (list 타입)의 각 요소에 대해 반복합니다.
  for_each = toset(var.static_ips)

  # VM의 이름 설정
  name        = var.vm_name
  # VM이 배포될 Proxmox 노드의 이름
  target_node = var.proxmox_node
  # 복제할 템플릿의 이름
  clone       = var.template_name
  # VM 생성 시 풀 클론(독립적인 복사본)을 수행할지 여부
  full_clone  = true

  # 운영체제 타입 설정 (Cloud-Init을 사용)
  os_type = "cloud-init"
  # QEMU Guest Agent 활성화 (VM과 호스트 간 통신)
  agent   = 1

  # CPU 설정
  cpu {
    # 할당할 CPU 코어 수
    cores = 1
    # 할당할 CPU 소켓 수
    sockets = 1
  }

  # 할당할 메모리 양 (MB 단위)
  memory  = 1024
  # 메모리 벌루닝 활성화 (최소 512MB 보장)
  balloon = 512
  # SCSI 컨트롤러 하드웨어 타입 (성능 향상을 위해 VirtIO SCSI 권장)
  scsihw  = "virtio-scsi-pci"
  # 부팅 순서 (scsi0 디스크로 부팅)
  boot    = "order=scsi0"

  # 메인 디스크 설정 (루트 디스크)
  disk {
    # 디스크 슬롯 (scsi0)
    slot    = "scsi0"
    # 디스크 크기 (8GB)
    size    = "8G"
    # 디스크 종류 (일반 디스크)
    type    = "disk"
    # 디스크 저장소 (예: local-lvm)
    storage = "local-lvm"
  }

  # Cloud-Init 드라이브 설정
  disk {
    # 디스크 슬롯 (ide2는 일반적으로 Cloud-Init CD-ROM 드라이브에 사용)
    slot    = "ide2"
    # 디스크 종류 (Cloud-Init 드라이브)
    type    = "cloudinit"
    # 디스크 저장소
    storage = "local-lvm"
  }


  # 네트워크 인터페이스 설정
  network {
    # 네트워크 인터페이스 ID (net0)
    id     = 0
    # 네트워크 카드 모델 (VirtIO는 성능이 좋음)
    model  = "virtio"
    # 연결할 가상 브릿지
    bridge = "vmbr0"
  }

  # Cloud-Init을 통한 IP 설정 (정적 IP 할당)
  # set의 각 요소를 반복하면서 각각의 IP 주소를 할당합니다.
  # set의 각 요소를 each.key는 for_each로 반복되는 현재 요소의 값입니다. 
  # set의 각 요소를 each.value는 for_each로 반복되는 현재 요소의 값입니다. 
  # 즉 set의 각 요소를 each.key와 each.value는 동일한 값을 가리킵니다.
  ipconfig0 = "ip=${each.key}/${var.static_ip_cidr},gw=${var.static_gateway}"

  # Cloud-Init 업그레이드 활성화
  ciupgrade  = true
  
  # Cloud-Init 사용자 이름과 비밀번호 및 ssh 키 설정
  ciuser     = var.ciValue.user
  cipassword = var.ciValue.password
  sshkeys    = var.ciValue.ssh_key

  # 사용자 정의 Cloud-Init 설정 적용
  # 위에서 생성한 스니펫 파일을 'vendor' 데이터로 이 VM에 적용합니다.
  cicustom = "vendor=local:snippets/cloud_init.yml"

  # VGA 설정
  vga {
    # VGA 타입 (표준)
    type = "std"
  }

  # Terraform 라이프사이클 관리 설정
  lifecycle {
    # 특정 속성의 변경을 Terraform이 무시하도록 설정 (수동 변경 시 유용)
    ignore_changes = [
      network, # 네트워크 설정 변경 무시
      disk     # 디스크 설정 변경 무시
    ]
  }
}
