#!/bin/bash

# Định nghĩa mã màu hiển thị terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Bắt đầu khởi tạo môi trường Staging..."
echo "--------------------------------------"

# Giai đoạn 1: Dọn dẹp tài nguyên (Clean up)
if [ "$(docker ps -aq -f name=^quickbite-db$)" ]; then
    echo "Phát hiện container quickbite-db cũ. Đang dọn dẹp..."
    docker stop quickbite-db > /dev/null 2>&1
    docker rm quickbite-db > /dev/null 2>&1
    echo "Dọn dẹp container thành công."
else
    echo "Không có container quickbite-db cũ cần dọn dẹp."
fi

# Giai đoạn 2: Kiểm soát cổng mạng (Port Check - Fail fast)
# Kiểm tra xem cổng 5432 có đang lắng nghe hay không
if ss -tuln | grep -q ":5432 "; then
    echo -e "${RED}CẢNH BÁO LỖI: Cổng 5432 trên máy host đang bị chiếm dụng bởi một tiến trình khác!${NC}"
    exit 1
fi

# Giai đoạn 3: Khởi tạo Database
echo "Khởi chạy container PostgreSQL mới..."
docker run -d \
    --name quickbite-db \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=12345678 \
    postgres:15-alpine > /dev/null

# Giai đoạn 4: Kiểm thử độ sẵn sàng (Smoke Test)
echo "Đang tạm dừng 5 giây để đợi Database khởi tạo..."
sleep 5

echo "Thực hiện thăm dò trạng thái bằng pg_isready..."
if docker exec quickbite-db pg_isready -U postgres > /dev/null 2>&1; then
    # Lệnh trả về exit code 0
    echo -e "${GREEN}DATABASE STAGING KHỞI TẠO THÀNH CÔNG!${NC}"
    exit 0
else
    # Lệnh trả về lỗi
    echo -e "${RED}LỖI: DATABASE KHỞI TẠO THẤT BẠI!${NC}"
    echo "Trích xuất 20 dòng log cuối cùng từ container:"
    echo "--------------------------------------"
    docker logs --tail 20 quickbite-db
    exit 1
fi