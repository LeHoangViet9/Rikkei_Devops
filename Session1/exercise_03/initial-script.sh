#!bin/bash
set -e
echo "=== BẮT ĐẦU QUÁ TRÌNH CÀI ĐẶT ==="

# 1. Cập nhật hệ thống
echo "1. Đang cập nhật hệ thống..."
sudo apt-get update && sudo apt-get upgrade -y

# 2. Cài đặt các gói phần mềm bắt buộc
echo "2. Đang cài đặt các phần mềm: openjdk-17-jdk, git, curl..."
sudo apt-get install -y openjdk-17-jdk git curl

# 3. Kiểm tra và tạo group quickbite
echo "3. Kiểm tra nhóm (group) 'quickbite'..."
if getent group quickbite > /dev/null 2>&1; then
    echo " -> Nhóm 'quickbite' đã tồn tại."
else
    echo " -> Đang tạo nhóm 'quickbite'..."
    sudo groupadd quickbite
fi

# 4. Kiểm tra và tạo user quickbite với các ràng buộc bảo mật
echo "4. Kiểm tra người dùng (user) 'quickbite'..."
if id "quickbite" > /dev/null 2>&1; then
    echo " -> Người dùng 'quickbite' đã tồn tại."
else
    echo " -> Đang tạo người dùng hệ thống 'quickbite'..."
    # -r: Tạo system user (thường mặc định không tạo thư mục home)
    # -M: Ép buộc không tạo thư mục home cá nhân (đảm bảo an toàn tuyệt đối)
    # -g: Chỉ định nhóm chính là quickbite
    # -s /bin/false: Khóa quyền đăng nhập trực tiếp
    sudo useradd -r -M -g quickbite -s /bin/false quickbite
fi

echo "=== HOÀN TẤT CÀI ĐẶT BAN ĐẦU! ==="
