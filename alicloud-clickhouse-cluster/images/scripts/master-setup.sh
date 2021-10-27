#!/bin/bash
set -x

# 安装 clickhouse
sudo apt-get install apt-transport-https ca-certificates dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4

echo "deb https://repo.clickhouse.com/deb/stable/ main/" | sudo tee \
    /etc/apt/sources.list.d/clickhouse.list
sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y clickhouse-server

# 安装 jdk1.8
sudo apt-get install openjdk-8-jdk -y

# 安装 zookeeper
cd /opt

wget https://archive.apache.org/dist/zookeeper/zookeeper-3.6.3/apache-zookeeper-3.6.3-bin.tar.gz

tar -xvzf apache-zookeeper-3.6.3-bin.tar.gz

mv apache-zookeeper-3.6.3-bin zookeeper
