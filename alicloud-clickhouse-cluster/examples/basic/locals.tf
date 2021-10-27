locals {
  master_instances = {
    master-1 = {
      instance_availability_zone        = "cn-hangzhou-b"
      image_id                          = "m-bp1h9nvnwmxtta4ycdm2"
      security_groups                   = alicloud_security_group.default.*.id
      vswitch_id                        = alicloud_vswitch.vsw.id
      instance_type                     = "ecs.xn4.small"
      instance_name                     = "master-1"
      host_name                         = "master-1"
      system_disk_category              = "cloud_efficiency"
      data_disk_zone_id                 = "cn-hangzhou-b"
      data_disk_name                    = "master-disk-1"
      data_disk_category                = "cloud_efficiency"
      data_disk_size                    = 20
      internet_max_bandwidth_out        = 1
    }
  }

  worker_instances = {
    worker-1 = {
      instance_availability_zone        = "cn-hangzhou-b"
      image_id                          = "m-bp1h9nvnwmxtta4ycdm2"
      security_groups                   = alicloud_security_group.default.*.id
      vswitch_id                        = alicloud_vswitch.vsw.id
      instance_type                     = "ecs.xn4.small"
      instance_name                     = "worker-1"
      host_name                         = "worker-1"
      system_disk_category              = "cloud_efficiency"
      data_disk_zone_id                 = "cn-hangzhou-b"
      data_disk_name                    = "worker-disk-1"
      data_disk_category                = "cloud_efficiency"
      data_disk_size                    = 20
      internet_max_bandwidth_out        = 1
    }
  }
}