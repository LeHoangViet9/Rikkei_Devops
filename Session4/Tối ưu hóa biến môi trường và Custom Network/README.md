# Bài tập 3: Tối ưu hóa biến môi trường và Custom Network

## 1. Biến môi trường
- Đã tách các thông tin nhạy cảm (DB_USER, DB_PASS) ra khỏi file compose bằng cú pháp `${VARIABLE_NAME}`.
- Docker sẽ đọc dữ liệu từ file `.env` (file này đã được đưa vào `.gitignore` để tránh bị lộ mật khẩu khi đẩy lên Git).
- File `.env.example` được tạo ra làm mẫu cấu trúc cho dev team.

## 2. Đóng Port Database
- Đã xóa cấu hình `ports: - "5432:5432"` ở service `postgres` nhằm chặn quyền truy cập trực tiếp từ bên ngoài. DB hiện chỉ nhận kết nối nội bộ từ các container cùng mạng.

## 3. Custom Network
- Tạo custom network tên là `storex-net` với driver là bridge.
- Backend và Database kết nối chung vào network này, giúp chúng giao tiếp an toàn và cô lập hoàn toàn với các network mặc định khác của Docker.