#!/bin/bash

cd /home/le_hoang_viet/workspace/OMNICHANNEL-E-COMMERCE-PLATFORM
git pull

./gradlew clean bootJar
if [ $? -ne 0 ]; then
    echo -e "\e[31m[LỖI FAIL-FAST] Biên dịch thất bại! Dừng triển khai.\e[0m"
    exit 1
fi

if [ "$1" == "user" ]; then
    PORT=8080
    TARGET_DIR="/opt/quickbite/dev/user-service"
    USER_SVC="user-svc"
    
# Chỉ đích danh vào thư mục build của module product-service
JAR_FILE="/home/le_hoang_viet/workspace/SimpleServer.jar"

    OLD_PID=$(ss -tulpn | grep :$PORT | grep -o -E 'pid=[0-9]+' | cut -d= -f2 | head -n 1)
    if [ ! -z "$OLD_PID" ]; then 
        kill -9 $OLD_PID 
    fi

    cp $JAR_FILE $TARGET_DIR/app.jar
    chown -R $USER_SVC:quickbite-apps $TARGET_DIR
    
    # [THAY ĐỔI QUAN TRỌNG]: Dùng sudo -u trực tiếp với java, để root xử lý việc ghi file log

# Ép ứng dụng luôn khởi chạy ở cổng 8080
    nohup sudo -u $USER_SVC java -jar $TARGET_DIR/app.jar --server.port=8080 > $TARGET_DIR/app.log 2>&1 &    
    echo -e "\e[32m[THÀNH CÔNG] Triển khai User Service hoàn tất!\e[0m"
fi
