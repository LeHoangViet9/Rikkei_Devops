#!/bin/bash

# Khởi chạy container quickbite-user với Volume Mounting
docker run -d \
  --name quickbite-user \
  -p 8081:8081 \
  -v "/đường/dẫn/tuyệt/đối/tới/thư/mục/chứa/jar:/app" \
  -w /app \
  --add-host=host.docker.internal:host-gateway \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/postgres \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=secret \
  eclipse-temurin:17-jre-alpine \
  java -jar [tên_file_jar].jar