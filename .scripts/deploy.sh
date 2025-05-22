#!/bin/bash

# Aktif ortamı belirle
if [ -f /home/ubuntu/current_color.txt ]; then
  CURRENT_COLOR=$(cat /home/ubuntu/current_color.txt)
else
  CURRENT_COLOR=green
fi

if [ "$CURRENT_COLOR" = "blue" ]; then
  TARGET_COLOR=green
  TARGET_PORT=8081
else
  TARGET_COLOR=blue
  TARGET_PORT=8080
fi

# Container’ı temizle
docker stop $TARGET_COLOR || true
docker rm $TARGET_COLOR || true

# Yeni container’ı başlat
docker run -d \
  --name $TARGET_COLOR \
  -p 80:80 \
  -v /home/ubuntu/blue-green-deploy:/usr/share/nginx/html \
  nginx

# Yeni ortamı kaydet
echo "$TARGET_COLOR" > /home/ubuntu/current_color.txt
echo "✅ Yeni ortam deploy edildi: $TARGET_COLOR"
