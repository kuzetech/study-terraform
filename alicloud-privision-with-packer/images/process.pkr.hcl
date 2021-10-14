
"post-processors":[{
    "type":"alicloud-import",
    "access_key": var.access_key,
    "secret_key": var.secret_key,
    "oss_bucket_name": "packer",
    "image_name": "packer_import",
    "image_os_type": "linux",
    "image_platform": "CentOS",
    "image_architecture": "x86_64",
    "image_system_size": "20",
    "region": var.region
}]