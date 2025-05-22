#!/bin/bash

# Aktif portları tanımla
GREEN_PORT=8081
BLUE_PORT=8082

# Hangi port şu anda aktif?
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

# Yeni ortama istek at
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$NEW_PORT)

if [ "$STATUS_CODE" == "200" ]; then
  echo "✅ Yeni ortam ( $NEW_COLOR ) çalışıyor."
  echo "$NEW_COLOR" > /home/ubuntu/current_color.txt
else
  echo "❌ Yeni ortam hata verdi. Rollback başlatılıyor..."
  docker stop $NEW_COLOR || true
  docker start $CURRENT_COLOR
fi
