#!/bin/bash

# --- ĐỊNH NGHĨA MÃ MÀU ANSI ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Xóa màu (No Color)

# --- CÁC BIẾN CẤU HÌNH ---
TARGET_DIR="/opt/quickbite/user-service"
JAR_NAME="user-service-0.0.1.jar" # Tên file JAR được tạo ra
TARGET_JAR="$TARGET_DIR/user-service-0.0.1.jar"
LOG_FILE="$TARGET_DIR/app.log"
APP_USER="quickbite"

echo -e "${YELLOW}=== BẮT ĐẦU QUY TRÌNH DEPLOY TỰ ĐỘNG ===${NC}"

# BƯỚC 1: Biên dịch mã nguồn (Áp dụng Fail-fast)
echo -e "${YELLOW}[Bước 1] Đang biên dịch mã nguồn và đóng gói JAR...${NC}"
./gradlew clean bootJar
# Kiểm tra Exit Code ($?) của lệnh trước đó
if [ $? -ne 0 ]; then
    echo -e "${RED}[LỖI FAIL-FAST] Quá trình Build thất bại! Hủy bỏ deploy để bảo vệ hệ thống.${NC}"
    exit 1
fi
echo -e "${GREEN}[Thành công] Đã đóng gói thành công file JAR.${NC}"

# BƯỚC 2: Chuẩn bị hạ tầng thư mục
echo -e "${YELLOW}[Bước 2] Kiểm tra thư mục triển khai...${NC}"
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    echo "Đã tạo mới thư mục: $TARGET_DIR"
fi
chown -R $APP_USER:$APP_USER /opt/quickbite
echo -e "${GREEN}[Thành công] Thư mục đã sẵn sàng.${NC}"

# BƯỚC 3: Sao chép ứng dụng
echo -e "${YELLOW}[Bước 3] Dừng tiến trình cũ và cập nhật ứng dụng...${NC}"
# Tìm PID đang chạy ở cổng 8080 (nếu có) và tắt nó
OLD_PID=$(ss -tulpn | grep :8080 | grep -o -E 'pid=[0-9]+' | head -1 | cut -d= -f2)
if [ ! -z "$OLD_PID" ]; then
    kill -9 $OLD_PID
    echo "Đã giải phóng cổng 8080 (Dừng PID: $OLD_PID)."
fi

# Copy từ thư mục build của Gradle sang thư mục deploy
cp build/libs/$JAR_NAME $TARGET_JAR
chown $APP_USER:$APP_USER $TARGET_JAR
echo -e "${GREEN}[Thành công] Đã cập nhật ứng dụng mới.${NC}"

# BƯỚC 4: Khởi động dịch vụ
echo -e "${YELLOW}[Bước 4] Khởi chạy dịch vụ...${NC}"
# Chạy tiến trình ngầm (background) dưới quyền user quickbite
su - $APP_USER -c "nohup java -jar $TARGET_JAR > $LOG_FILE 2>&1 &"
echo -e "${GREEN}[Thành công] Đã gửi lệnh khởi động hệ thống.${NC}"

# BƯỚC 5: Smoke Test
echo -e "${YELLOW}[Bước 5] Đang kiểm tra trạng thái hoạt động (Smoke Test)...${NC}"
echo "Chờ 5 giây để máy ảo Java (JVM) khởi động..."
sleep 5

# Kiểm tra xem cổng 8080 đã mở hay chưa
if ss -tulpn | grep -q ":8080"; then
    echo -e "${GREEN}===========================================${NC}"
    echo -e "${GREEN}       DEPLOY DỊCH VỤ THÀNH CÔNG!          ${NC}"
    echo -e "${GREEN}===========================================${NC}"
else
    echo -e "${RED}[LỖI] Dịch vụ không khởi động được (Cổng 8080 vẫn đóng)!${NC}"
    echo -e "${RED}--- TRÍCH XUẤT 30 DÒNG LOG CUỐI CÙNG TỪ FILE $LOG_FILE ---${NC}"
    tail -n 30 $LOG_FILE
    exit 1
fi
