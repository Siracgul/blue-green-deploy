#!/bin/bash

GREEN_PORT=8081
BLUE_PORT=8082

CURRENT_COLOR=$(cat /home/ubuntu/current_color.txt)

if [ "$CURRENT_COLOR" == "blue" ]; then
  TARGET_COLOR="green"
  TARGET_PORT=$GREEN_PORT
else
  TARGET_COLOR="blue"
  TARGET_PORT=$BLUE_PORT
fi

# Container'ı temizle
docker stop $TARGET_COLOR || true
docker rm $TARGET_COLOR || true

# Yeni container'ı başlat
docker run -d \
  --name $TARGET_COLOR \
  -p 80:80 \
  -v /home/ubuntu/blue-green-deploy:/usr/share/nginx/html \
  nginx

# Yeni ortamı aktif olarak kaydet
echo "$TARGET_COLOR" > /home/ubuntu/current_color.txt

echo "✅ Yeni ortam deploy edildi: $TARGET_COLOR"
