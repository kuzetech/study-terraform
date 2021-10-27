provider "alicloud" {}

module "master_instance" {
  source                = "./modules/ecs-with-disk-attach"
  for_each              = var.master_instances
  aliyun_instance       = each.value
}

module "worker_instance" {
  source                = "./modules/ecs-with-disk-attach"
  for_each              = var.worker_instances
  aliyun_instance       = each.value
}
