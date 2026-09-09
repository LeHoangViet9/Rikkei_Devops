# Báo cáo Chẩn đoán mạng và Xử lý lỗi

## Tình huống 1: Giải phóng cổng 8080 bị chiếm dụng
* **Mục đích:** Tìm và tắt tiến trình đang chiếm giữ cổng 8080 khiến ứng dụng không thể khởi động.
* **Lệnh kiểm tra:** `sudo ss -tulpn | grep :8080`
  * *Giải thích:* Lệnh `ss -tulpn` liệt kê các cổng đang lắng nghe (listening) cùng thông tin tiến trình. Lệnh `grep :8080` giúp lọc để chỉ hiển thị dòng chứa cổng 8080.
* **Lệnh tắt tiến trình:** `sudo kill -9 1233`
  * *Giải thích:* Gửi tín hiệu SIGKILL để ép buộc hệ điều hành dừng ngay lập tức tiến trình có mã số PID là 1233.

## Tình huống 2: Kiểm tra kết nối tới Database PostgreSQL
* **Mục đích:** Xác định nguyên nhân ứng dụng lỗi kết nối tới DB tại IP 10.0.1.20 cổng 5432.
* **Lệnh kiểm tra vật lý:** `ping -c 4 10.0.1.20`
  * *Giải thích:* Gửi gói tin ICMP tới máy chủ đích để xem đường truyền mạng có thông suốt và máy chủ có phản hồi hay không.
* **Lệnh kiểm tra cổng:** `nc -vz 10.0.1.20 5432`
  * *Giải thích:* Dùng Netcat quét thăm dò xem cổng 5432 trên IP 10.0.1.20 có đang mở để nhận kết nối TCP hay không.
