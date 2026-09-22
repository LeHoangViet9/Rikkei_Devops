# Bài tập 1: Khởi tạo môi trường phát triển cơ bản với Docker Compose

## 1. Giải thích nguyên nhân lỗi (Connection refused)
- **Lý do:** Khi cấu hình `SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/storex`, ứng dụng Backend đang cố gắng tìm kiếm Database ở `localhost`. Tuy nhiên, do tính chất cô lập (isolation) của Docker, `localhost` bên trong container `backend` chỉ trỏ về chính nội bộ container đó. Vì Database thực chất đang chạy ở một container khác nên Backend không thể tìm thấy port 5432, dẫn đến lỗi `Connection refused`.

## 2. Cách khắc phục (Cơ chế mạng của Docker Compose)
- **Giải pháp:** Đổi `localhost` thành `postgres` (tên của service chạy database trong file cấu hình).
- **Cơ chế:** Khi khởi chạy bằng `docker-compose`, Docker tự động tạo ra một mạng nội bộ (default internal network) và tích hợp sẵn một máy chủ DNS. Các container trong cùng một mạng này có thể tự động phân giải (resolve) tên service của nhau thành địa chỉ IP tương ứng. Do đó, Backend chỉ cần gọi `postgres` là Docker sẽ tự động điều hướng kết nối đến đúng container chứa Database.