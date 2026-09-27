package com.example.transactionservice.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api/transactions")
public class TransactionController {

    @Autowired
    private RestTemplate restTemplate;

    // Lấy URL từ biến môi trường, mặc định là http://account-service:8080
    private final String ACCOUNT_SERVICE_URL = "http://account-service:8080/api/accounts/";

    @PostMapping("/transfer")
    public ResponseEntity<String> transferMoney(@RequestParam Long sourceAccountId, @RequestParam Double amount) {
        System.out.println("Bắt đầu xử lý giao dịch cho tài khoản nguồn: " + sourceAccountId);

        try {
            // 1. GỌI LIÊN SERVICE: Kiểm tra tài khoản nguồn có tồn tại không
            String url = ACCOUNT_SERVICE_URL + sourceAccountId;
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

            if (response.getStatusCode().is2xxSuccessful()) {
                // Đã tìm thấy tài khoản, tiếp tục xử lý logic chuyển tiền...
                System.out.println("Đã tìm thấy tài khoản tại account-service. Phản hồi: " + response.getBody());
                return ResponseEntity.ok("Giao dịch thành công (Đã xác thực tài khoản nguồn qua account-service)!");
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi gọi account-service: " + e.getMessage());
            return ResponseEntity.badRequest().body("Giao dịch thất bại: Không tìm thấy tài khoản nguồn hợp lệ.");
        }

        return ResponseEntity.badRequest().body("Giao dịch thất bại!");
    }
}
