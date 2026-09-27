#!/bin/bash

# Định nghĩa mã màu hiển thị
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Xóa định dạng màu

# Cấu hình tên service database (điều chỉnh cho khớp với tên trong docker-compose.yml của bạn)
DB_SERVICE="postgres"

# Kiểm tra tham số đầu vào
if [ "$1" == "clean" ]; then
    echo -e "${GREEN}[CLEAN] Đang dọn dẹp hệ thống...${NC}"
    docker compose down
    exit 0

elif [ "$1" == "run" ]; then
    echo -e "${GREEN}[1/4] Khởi chạy cụm dịch vụ...${NC}"
    docker compose up -d --build

    echo -e "${GREEN}[2/4] Đang kiểm tra trạng thái PostgreSQL...${NC}"
    DB_READY=false
    for i in {1..5}; do
        # Gọi lệnh pg_isready bên trong container của service database
        if docker compose exec -T "$DB_SERVICE" pg_isready > /dev/null 2>&1; then
            DB_READY=true
            echo -e "${GREEN}=> Database đã sẵn sàng!${NC}"
            break
        fi
        echo "Đang chờ database phản hồi... (lần $i/5)"
        sleep 2
    done

    # Quá 10 giây (5 lần x 2s) không ready -> Tắt cụm & exit 1
    if [ "$DB_READY" = false ]; then
        echo -e "${RED}LỖI: PostgreSQL không sẵn sàng sau 10 giây!${NC}"
        echo -e "${RED}Đang dừng và dọn dẹp cụm...${NC}"
        docker compose down
        exit 1
    fi

    echo -e "${GREEN}[3/4] Chờ 5 giây để Spring Boot khởi động các service...${NC}"
    sleep 5

    echo -e "${GREEN}[4/4] Bắt đầu gửi healthcheck request tới Gateway...${NC}"
    # Lấy HTTP status code từ request
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/v1/users/actuator/health)

    if [ "$HTTP_STATUS" == "200" ]; then
        # Thành công
        echo -e "${GREEN}CỔNG GATEWAY HOẠT ĐỘNG ỔN ĐỊNH. HỆ THỐNG LIÊN THÔNG THÀNH CÔNG!${NC}"
        exit 0
    else
        # Lỗi
        echo -e "${RED}LỖI: Hệ thống liên thông thất bại (Mã HTTP: $HTTP_STATUS).${NC}"
        echo -e "${RED}=================== 30 DÒNG LOG CUỐI ===================${NC}"
        docker compose logs --tail=30
        echo -e "${RED}========================================================${NC}"
        echo -e "${RED}Đang tự động dọn dẹp tài nguyên để tránh treo hệ thống...${NC}"
        docker compose down
        exit 1
    fi

else
    echo "Cú pháp không hợp lệ."
    echo "Sử dụng: $0 [run | clean]"
    exit 1
fi