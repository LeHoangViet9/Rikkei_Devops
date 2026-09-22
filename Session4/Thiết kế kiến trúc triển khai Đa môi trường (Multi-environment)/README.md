# Bài tập 5: Thiết kế kiến trúc triển khai Đa môi trường (Multi-environment)

Hệ thống sử dụng cơ chế Compose File Override của Docker Compose để tách biệt cấu hình giữa Staging/Dev và Production, tuân thủ nguyên tắc DRY (Don't Repeat Yourself).

---

## 1. Kiến trúc phân tách file

* **`docker-compose.yml` (Base):** Chứa các định nghĩa dịch vụ dùng chung (images, volumes, networks cơ bản).
* **`docker-compose.override.yml` (Staging/Dev):** Tự động được áp dụng khi chạy local/staging. Mở port `8080` (Backend) và `5432` (PostgreSQL) ra máy host để lập trình viên dễ debug và kiểm tra dữ liệu.
* **`docker-compose.prod.yml` (Production):** Thiết lập an toàn cho môi trường thực tế:
  * Scale 3 bản sao (`replicas: 3`) cho service Backend.
  * Giới hạn tài nguyên (`memory: 512M`, `cpus: 0.50`) để tránh rò rỉ bộ nhớ làm sập server.
  * Chính sách `restart: always` giúp dịch vụ tự hồi sinh nếu xảy ra sự cố.
  * Không mở port trực tiếp ra máy host, bảo vệ database tối đa.

---

## 2. Kịch bản và Lệnh triển khai

### A. Môi trường Staging / Dev (Local)
Docker Compose tự động tìm và kết hợp `docker-compose.yml` + `docker-compose.override.yml`:

```bash
docker-compose up -d