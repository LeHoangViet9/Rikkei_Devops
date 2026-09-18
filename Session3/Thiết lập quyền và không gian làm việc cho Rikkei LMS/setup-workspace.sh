#!/bin/bash

# Tạo user
sudo useradd -m rikkeilms

# Tạo thư mục
sudo mkdir -p /opt/rikkei/course-service

# Chuyển quyền sở hữu
sudo chown rikkeilms:rikkeilms /opt/rikkei/course-service

# Phân quyền 755
sudo chmod 755 /opt/rikkei/course-service