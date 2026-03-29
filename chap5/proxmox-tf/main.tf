# 사용할 프로바이더와 버전 설정
terraform {
  required_providers {
    proxmox = {
      # 참고: 이 코드는 telmate/proxmox 프로바이더 문법을 기준으로 합니다.
      source  = "telmate/proxmox"
      version = "3.0.2-rc06"
    }
  }
}

# Proxmox 프로바이더 구성
# 실제 접속 정보는 terraform.tfvars 파일에서 가져옵니다.
provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

  # 자체 서명 인증서 사용 시 필요
  pm_tls_insecure = true
}

# Proxmox VM 리소스 정의
resource "proxmox_vm_qemu" "ubuntu_vm" {
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
    cores = 2
    # 할당할 CPU 소켓 수
    sockets = 1
  }

  # 할당할 메모리 양 (MB 단위)
  memory = 2048
  # SCSI 컨트롤러 하드웨어 타입 (성능 향상을 위해 VirtIO SCSI 권장)
  scsihw  = "virtio-scsi-pci"
  # 부팅 순서 (scsi0 디스크로 부팅)
  boot    = "order=scsi0"

  # 메인 디스크 설정 (루트 디스크)
  disk {
    # 디스크 슬롯 (scsi0)
    slot    = "scsi0"
    # 디스크 크기 (32GB)
    size    = "32G"
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

  # Cloud-Init을 통한 IP 설정 (DHCP로 IP 자동 할당)
  ipconfig0 = "ip=dhcp"

  # Cloud-Init 커스텀 설정 (QEMU Guest Agent 설정 파일)
  # 스니펫 활성화를 위해 Proxmox 웹 UI에서 아래 경로에 스니펫 활성화 하고 파일을 생성해야 합니다.
  # 데이터센터 -> 스토리지 -> local -> 수정 -> 내용에 스니펫 추가
  # 서버 노드에 root 권한으로 접속하여 /var/lib/vz/snippets/ 경로에 qemu-guest-agent.yml 파일을 생성하면 됩니다 
  #
  # qemu-guest-agent.yml 파일 생성 예시:
  # tee /var/lib/vz/snippets/qemu-guest-agent.yml <<EOF
  # #cloud-config
  # runcmd:
  #  - apt update
  #  - apt install -y qemu-guest-agent
  #  - systemctl start qemu-guest-agent
  # EOF
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml 파일 경로
  # Cloud-Init 업그레이드 활성화
  ciupgrade  = true
  # Cloud-Init 사용자 이름
  ciuser     = "kosa"
  # Cloud-Init 사용자 암호
  cipassword = "kosa1004"
  # SSH 공개 키 (VM에 SSH 접속용)
  sshkeys    = var.ssh_public_key

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
