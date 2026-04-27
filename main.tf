terraform {
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "1.82.89"
    }
  }
}

provider "tencentcloud" {
  # Configuration options
  region = "ap-guangzhou"
}

resource "tencentcloud_instance" "simple_vm" {
  instance_name     = "simple-vm"
  image_id          = "img-9qabwvbn"  # Ubuntu 20.04 LTS image ID (example, verify in your account)
  instance_type     = "S1.SMALL1"
  system_disk_type  = "CLOUD_PREMIUM"
  system_disk_size  = 50
  allocate_public_ip = true
  internet_max_bandwidth_out = 10
}
