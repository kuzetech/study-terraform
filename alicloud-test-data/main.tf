
provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "cn-hangzhou"
}

data "alicloud_slb_zones" "zones_ids" {
    enable_details = true
}

output "slb_zones"{
  value = "${data.alicloud_slb_zones.zones_ids}"
}