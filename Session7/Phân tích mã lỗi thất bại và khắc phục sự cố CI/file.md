\# Phân tích và Xử lý sự cố: UnsupportedClassVersionError trên GitHub Actions



\## 1. Phân tích nguyên nhân gốc rễ (Root Cause)

Lỗi `UnsupportedClassVersionError` xảy ra trong pipeline CI khi có sự bất đồng bộ giữa phiên bản Java dùng để biên dịch mã nguồn (Compile-time) và phiên bản Java dùng để thực thi (Runtime). Cụ thể, môi trường chạy đang ở phiên bản thấp hơn so với phiên bản đã dùng để biên dịch code.



\*\*Vai trò của số hiệu "class file version":\*\*

Khi trình biên dịch (javac) dịch mã nguồn, nó gán một số hiệu vào file `.class` để đánh dấu phiên bản JDK. Dựa theo tài liệu chuẩn của Java:

\* `version 65.0` tương ứng với \*\*Java 21\*\*.

\* `version 61.0` tương ứng với \*\*Java 17\*\*.

Lỗi trên thông báo rằng: Mã nguồn đã được biên dịch thành công bằng Java 21 (version 65.0), nhưng JVM trên môi trường CI hiện tại chỉ hỗ trợ tối đa Java 17 (version 61.0).



\*\*Sự khác biệt giữa Local và CI:\*\*

\* \*\*Trên máy Local:\*\* Lập trình viên đã cài đặt sẵn JDK 21. Khi code và build trên máy cá nhân, hệ thống sử dụng đúng Java 21 nên không phát sinh lỗi.

\* \*\*Trên GitHub Actions:\*\* Mỗi job chạy trên một máy ảo (runner) độc lập. Phiên bản Java trên runner hoàn toàn phụ thuộc vào cấu hình trong file `ci.yml`. Việc xuất hiện lỗi chứng tỏ file CI đang bị cấu hình cứng ở bản Java cũ (Java 17).



\## 2. Đề xuất giải pháp cấu hình

Dựa trên phân tích, cần rà soát lại bước thiết lập môi trường Java (`actions/setup-java`) trong file `ci.yml` và nâng cấp tham số phiên bản.



\*\*Mã cấu hình YAML điều chỉnh:\*\*

```yaml

&#x20;   steps:

&#x20;     - name: Checkout code

&#x20;       uses: actions/checkout@v4



&#x20;     - name: Setup Java JDK

&#x20;       uses: actions/setup-java@v4

&#x20;       with:

&#x20;         # java-version: '17'  <-- NGUYÊN NHÂN LỖI (Môi trường Runtime cũ, version 61.0)

&#x20;         java-version: '21'    # <-- GIẢI PHÁP: Cập nhật lên JDK 21 (version 65.0)

&#x20;         distribution: 'temurin'

&#x20;         

&#x20;     - name: Build with Gradle

&#x20;       run: |

&#x20;         chmod +x ./gradlew

&#x20;         ./gradlew build

