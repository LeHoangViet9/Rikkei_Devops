# Bài tập 4: Xây dựng hệ thống Reverse Proxy với Nginx

## 1. Phân tích lỗi 502 Bad Gateway
- **Nguyên nhân:** Ban đầu, file cấu hình sử dụng `proxy_pass http://localhost:8081/`. Trong môi trường Docker, `localhost` bên trong container Nginx chỉ trỏ về chính Nginx container đó, chứ không trỏ ra máy host hay các container khác. Do Nginx không có dịch vụ nào chạy ở port 8081 bên trong nó, kết nối bị từ chối và Nginx trả về lỗi `502 Bad Gateway`.

## 2. Giải pháp khắc phục (DNS nội bộ)
- **Sửa lỗi:** Thay vì dùng `localhost`, ta sử dụng trực tiếp tên service đã khai báo trong `docker-compose.yml` là `user_service` và `product_service`.
- **Cơ chế:** Docker Compose có tích hợp sẵn một DNS Server nội bộ. Khi Nginx gọi tới `http://user_service:8081`, DNS của Docker sẽ tự động phân giải tên này thành địa chỉ IP chuẩn xác của container `user_service`.

## 3. Cơ chế Rewrite Path
- Bằng cách thêm dấu gạch chéo `/` vào cuối địa chỉ đích (`proxy_pass http://user_service:8081/;`), Nginx sẽ tự động cắt bỏ phần tiền tố của `location` trước khi chuyển tiếp.
- **Ví dụ:** Khi client gọi `http://localhost/users/api/info`, Nginx sẽ chuyển tiếp request đó vào `user_service` thành `http://user_service:8081/api/info`. Điều này giúp backend không cần phải cấu hình thêm prefix `/users/` trong code của mình.