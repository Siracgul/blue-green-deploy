#!/bin/bash

GREEN_PORT=8081
BLUE_PORT=8082

CURRENT_COLOR=$(cat /home/ubuntu/current_color.txt)

if [ "$CURRENT_COLOR" == "blue" ]; then
  NEW_COLOR="green"
  NEW_PORT=$GREEN_PORT
  OLD_PORT=$BLUE_PORT
else
  NEW_COLOR="blue"
  NEW_PORT=$BLUE_PORT
  OLD_PORT=$GREEN_PORT
fi

# Yeni versiyona istek at, içerik içinde kontrol yap
RESPONSE=$(curl -s http://localhost:$NEW_PORT)

if echo "$RESPONSE" | grep -q "HEALTH_CHECK_OK"; then
  echo "✅ Yeni ortam ($NEW_COLOR) çalışıyor ve içerik uygun."
  echo "$NEW_COLOR" > /home/ubuntu/current_color.txt
else
  echo "❌ Yeni ortam hata verdi. Rollback başlatılıyor..."
  docker stop $NEW_COLOR || true
  docker start $CURRENT_COLOR
fi
