output "vsw" {
  description = "vsw"
  value       = alicloud_vswitch.vsw
}

output "security_group" {
  description = "security_group"
  value       = alicloud_security_group.default
}