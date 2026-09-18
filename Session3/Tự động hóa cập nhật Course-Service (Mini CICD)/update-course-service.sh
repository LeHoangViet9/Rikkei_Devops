#!/bin/bash

LOG_FILE="/opt/rikkei/deploy.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

touch $LOG_FILE

echo "[$TIMESTAMP] --- Bắt đầu cập nhật Course-Service ---" >> $LOG_FILE

if docker ps -a --format '{{.Names}}' | grep -q "^rikkei-course-service$"; then
    echo "[$TIMESTAMP] Phát hiện container cũ. Tiến hành dừng và xóa..." >> $LOG_FILE
    docker rm -f rikkei-course-service >> $LOG_FILE 2>&1
else
    echo "[$TIMESTAMP] Không có container cũ. Triển khai bản mới..." >> $LOG_FILE
fi

echo "[$TIMESTAMP] Khởi chạy rikkei-course-service từ image nginxdemos/hello (Port 8081)..." >> $LOG_FILE
docker run -d --name rikkei-course-service -p 8081:80 nginxdemos/hello >> $LOG_FILE 2>&1

echo "[$TIMESTAMP] --- Hoàn tất quá trình ---" >> $LOG_FILE
echo "" >> $LOG_FILE