
# 阿里云 ECS 部署 Clickhouse 集群

## 技术方案

- 使用 packer 制作安装好 zookeeper 和 clickhouse 的阿里云镜像
- 使用 terraform 部署和管理由上一步镜像生成的实例，以及网络设施
- 使用 ansible 管理和部署实例中的 zookeeper 和 clickhouse 的配置

## 节点分配

Clickhouse 集群中包含两种角色：
- 主节点：同时包含 zk 和 ch
- 工作节点：仅包含 ch

## 目录结构
- examples
  - basic (快速启动案例)
- images（packer 制作镜像目录）
  - scripts（镜像初始化脚本）
  - clickhouse-master.pkr.hcl 为主节点镜像代码
  - clickhouse-worker.pkr.hcl 为工作节点镜像代码

## 软件要求（安装请参考官网）

- packer
- terraform

## 快速启动案例使用说明

1. packer build ./images/clickhouse-master.pkr.hcl（制作主节点镜像）
2. packer build ./images/clickhouse-worker.pkr.hcl（制作工作节点镜像）
3. 镜像构建完成后会打印镜像 ID 或者从阿里云后台管理界面获取，分别将其填入 ./example/basic/locals.tf 中 master_instances 和 worker_instances 的 image_id 字段中
4. 生成阿里云账号连接密钥，并通过如下方式初始化会话窗口：
    - export ALICLOUD_ACCESS_KEY="xxx"
    - export ALICLOUD_SECRET_KEY="xxx"
    - export ALICLOUD_REGION="cn-hangzhou"
5. terrform init（需要进入 examples/basic 文件夹，并使用此命令初始化插件）
6. terrform apply（需要进入 examples/basic 文件夹，并使用此命令创建阿里云实例）
7. 可以在阿里云后台查看创建的集群
