terraform {
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "1.82.89"
    }
  }
}

provider "tencentcloud" {
  region = "ap-guangzhou"
}

# ---------------------------
# VPC
# ---------------------------
resource "tencentcloud_vpc" "vpc" {
  name       = "tf-vpc"
  cidr_block = "10.0.0.0/16"
}

# ---------------------------
# Subnet
# ---------------------------
resource "tencentcloud_subnet" "subnet" {
  name              = "tf-subnet"
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-guangzhou-3"  # safer default zone
}

# ---------------------------
# Security Group
# ---------------------------
resource "tencentcloud_security_group" "sg" {
  name = "tf-sg"
}

# Allow SSH
resource "tencentcloud_security_group_rule" "allow_ssh" {
  security_group_id = tencentcloud_security_group.sg.id
  type              = "ingress"
  port_range        = "22"
  cidr_ip           = "0.0.0.0/0"
  policy            = "ACCEPT"
}

# ---------------------------
# VM Instance
# ---------------------------
resource "tencentcloud_instance" "vm" {
  instance_name     = "tf-vm"
  availability_zone = "ap-guangzhou-2"

  instance_type = "S1.SMALL1"

  # ⚠️ IMPORTANT: Replace with a valid image from your account
  image_id = "img-mmytdhbn" # Example Ubuntu image (may vary)

  system_disk_type = "CLOUD_PREMIUM"
  system_disk_size = 50

  vpc_id     = tencentcloud_vpc.vpc.id
  subnet_id  = tencentcloud_subnet.subnet.id

  security_groups = [tencentcloud_security_group.sg.id]

  allocate_public_ip           = true
  internet_max_bandwidth_out   = 10

  depends_on = [
    tencentcloud_security_group_rule.allow_ssh
  ]
}

# ---------------------------
# Output
# ---------------------------
output "public_ip" {
  value = tencentcloud_instance.vm.public_ip
}
