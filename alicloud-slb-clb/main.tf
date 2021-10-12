provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "cn-hangzhou"
}

resource "alicloud_vpc" "vpc" {
  vpc_name       = "tf_test_foo"
  cidr_block = "172.16.0.0/12"
}

resource "alicloud_vswitch" "vsw" {
  vpc_id            = "${alicloud_vpc.vpc.id}"
  cidr_block        = "172.16.0.0/21"
  zone_id = "cn-hangzhou-b"
}

resource "alicloud_security_group" "default" {
  name = "default"
  vpc_id = "${alicloud_vpc.vpc.id}"
}

resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = "${alicloud_security_group.default.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_slb" "slb" {
  load_balancer_name       = "test-slb-tf"
  vswitch_id = "${alicloud_vswitch.vsw.id}"
  address_type = "internet"
}

resource "alicloud_slb_listener" "http" {
  load_balancer_id = "${alicloud_slb.slb.id}"
  backend_port = 8080
  frontend_port = 80
  bandwidth = 10
  protocol = "http"
  sticky_session = "on"
  sticky_session_type = "insert"
  cookie = "testslblistenercookie"
  cookie_timeout = 86400
  health_check="on"
  health_check_type = "http"
  health_check_connect_port = 8080
}

output "slb_public_ip"{
  value = "${alicloud_slb.slb.address}"
}

resource "alicloud_ess_scaling_group" "scaling" {
  min_size = 2
  max_size = 4
  scaling_group_name = "tf-scaling"
  vswitch_ids=["${alicloud_vswitch.vsw.id}"]
  loadbalancer_ids = ["${alicloud_slb.slb.id}"]
  removal_policies   = ["OldestInstance", "NewestInstance"]
  depends_on = ["alicloud_slb_listener.http"]
}

resource "alicloud_ess_scaling_configuration" "config" {
  scaling_group_id = "${alicloud_ess_scaling_group.scaling.id}"
  image_id = "centos_7_06_64_20G_alibase_20190711.vhd"
  instance_type = "ecs.xn4.small"
  security_group_id = "${alicloud_security_group.default.id}"
  active=true
  enable=true
  user_data = "#!/bin/bash\necho \"Hello, World\" > index.html\nnohup busybox httpd -f -p 8080&"
  internet_max_bandwidth_in=10
  internet_max_bandwidth_out=10
  internet_charge_type = "PayByTraffic"
  force_delete= true
}

resource "alicloud_ess_scaling_rule" "rule" {
  scaling_group_id = "${alicloud_ess_scaling_group.scaling.id}"
  adjustment_type  = "TotalCapacity"
  adjustment_value = 2
  cooldown = 60
}