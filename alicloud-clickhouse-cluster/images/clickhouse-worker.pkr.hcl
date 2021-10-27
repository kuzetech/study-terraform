variable "access_key" {
  type = string
  default = "xxx"
}

variable "secret_key" {
  type = string
  default = "xxx"
}

variable "region" {
  type = string
  default = "cn-hangzhou"
}

variable "source_image" {
  type = string
  default = "ubuntu_20_04_x64_20G_alibase_20210927.vhd"
}

variable "instance_type" {
  type = string
  default = "ecs.xn4.small"
}

source "alicloud-ecs" "ubuntu-clickhouse-worker" {
      access_key = var.access_key
      secret_key = var.secret_key
      region = var.region
      image_name = "ubuntu-clickhouse-worker"
      source_image = var.source_image
      image_ignore_data_disks = true
      ssh_username = "root"
      instance_type = var.instance_type
      io_optimized = true
      internet_charge_type = "PayByTraffic"
      image_force_delete = true
}

build {
  sources = ["sources.alicloud-ecs.ubuntu-clickhouse-worker"]

  provisioner "file" {
    source      = "./scripts/setup-disk.sh"
    destination = "/root/setup-disk.sh"
  }

  provisioner "shell" {
    script = "./scripts/worker-setup.sh"
  }

}

