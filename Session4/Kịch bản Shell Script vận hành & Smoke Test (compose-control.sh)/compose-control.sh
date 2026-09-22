#!/bin/bash

# Cấu hình biến môi trường
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Biến tên service (Tùy chỉnh lại cho khớp với file docker-compose.yml của bạn nếu cần)
DB_SERVICE="postgres"
DB_USER="postgres" 
BACKEND_SERVICE="backend"
API_URL="http://localhost:8080/actuator/health"

case "$1" in
    start)
        echo "Bắt đầu khởi động hệ thống Quickbite..."
        docker compose up -d --build

        echo "Đang kiểm tra trạng thái Database..."
        TIMEOUT=10
        INTERVAL=2
        ELAPSED=0
        DB_READY=false

        # Vòng lặp check Database (timeout 10s)
        while [ $ELAPSED -lt $TIMEOUT ]; do
            # Chạy lệnh pg_isready thẳng vào trong container
            if docker compose exec -T $DB_SERVICE pg_isready -U $DB_USER >/dev/null 2>&1; then
                DB_READY=true
                echo "-> Database đã sẵn sàng!"
                break
            fi
            echo "Đợi Database... (${ELAPSED}s / ${TIMEOUT}s)"
            sleep $INTERVAL
            ELAPSED=$((ELAPSED + INTERVAL))
        done

        API_READY=false
        # Vòng lặp check Backend API (nếu DB đã lên)
        if [ "$DB_READY" = true ]; then
            echo "Đang kiểm tra Backend API (/actuator/health)..."
            # Cho backend 1 khoảng thời gian timeout (vd 10s) để boot xong Spring Boot
            API_TIMEOUT=10
            API_ELAPSED=0
            while [ $API_ELAPSED -lt $API_TIMEOUT ]; do
                # Lấy mã HTTP status (ví dụ: 200 là thành công)
                HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $API_URL)
                if [ "$HTTP_STATUS" -eq 200 ]; then
                    API_READY=true
                    break
                fi
                sleep 2
                API_ELAPSED=$((API_ELAPSED + 2))
            done
        fi

        # Đánh giá kết quả cuối cùng
        if [ "$DB_READY" = true ] && [ "$API_READY" = true ]; then
            echo -e "${GREEN}HỆ THỐNG QUICKBITE HOẠT ĐỘNG ỔN ĐỊNH!${NC}"
            exit 0
        else
            echo -e "${RED}PHÁT HIỆN LỖI: Timeout kết nối DB hoặc API báo lỗi!${NC}"
            echo -e "${RED}--- 20 DÒNG LOG CUỐI CỦA BACKEND ---${NC}"
            docker compose logs --tail=20 $BACKEND_SERVICE
            
            echo -e "${RED}--- TỰ ĐỘNG DỌN DẸP HỆ THỐNG ---${NC}"
            docker compose down
            exit 1
        fi
        ;;
        
    stop)
        echo "Đang tạm dừng hệ thống (Stop)..."
        docker compose stop
        ;;
        
    clean)
        echo "Dọn dẹp toàn bộ tài nguyên, networks và volumes..."
        docker compose down -v
        ;;
        
    *)
        echo "Cú pháp không hợp lệ!"
        echo "Sử dụng lệnh: ./compose-control.sh {start|stop|clean}"
        exit 1
        ;;
esac