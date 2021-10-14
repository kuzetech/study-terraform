variable "access_key" {
  type = string
  default = ["us-west-1a"]
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

source "alicloud-ecs" "basic-example" {
      access_key = var.access_key
      secret_key = var.secret_key
      region = var.secret_key
      image_name = "packer_test"
      source_image = "centos_7_06_64_20G_alibase_20190711.vhd"
      image_ignore_data_disks = true
      ssh_username = "root"
      instance_type = "ecs.xn4.small"
      io_optimized = true
      internet_charge_type = "PayByTraffic"
      image_force_delete = true
}

build {
  sources = ["sources.alicloud-ecs.basic-example"]

  provisioner "shell" {
    inline = [
      "sleep 30", 
      "yum install redis.x86_64 -y"
    ]
  }

  provisioner "file" {
    source      = "../ssh/tf-packer.pub"
    destination = "/tmp/tf-packer.pub"
  }

  provisioner "shell" {
    script = "../scripts/setup.sh"
  }
}

"post-processors":[
    {
      "access_key":"{{user `access_key`}}",
      "secret_key":"{{user `secret_key`}}",
      "type":"alicloud-import",
      "oss_bucket_name": "packer",
      "image_name": "packer_import",
      "image_os_type": "linux",
      "image_platform": "CentOS",
      "image_architecture": "x86_64",
      "image_system_size": "40",
      "region":"cn-beijing"
    }
  ]

