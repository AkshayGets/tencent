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

data "tencentcloud_availability_zones" "zones" {}

output "zones" {
  value = data.tencentcloud_availability_zones.zones.zones
}
