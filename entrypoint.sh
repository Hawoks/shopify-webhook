#!/bin/sh

# Запускаем Docker Daemon
dockerd &

# Ожидаем, пока Docker полностью запустится
sleep 5

# Настраиваем Tutor Open edX для домена uni-books.online
tutor config save --set LMS_HOST=uni-books.online --set CMS_HOST=studio.uni-books.online

# Включаем SSL (Let's Encrypt)
tutor config save --set ENABLE_HTTPS=true

# Проверяем и настраиваем сертификаты SSL
if [ ! -f "/root/.local/share/tutor/env/local/certs/live/uni-books.online/fullchain.pem" ]; then
  echo "🔐 Запускаем Let's Encrypt для uni-books.online..."
  tutor local stop
  tutor local restart
  certbot certonly --standalone --preferred-challenges http --agree-tos -m contact@uni-books.online -d uni-books.online -d studio.uni-books.online
fi

# Запуск Open edX
tutor local start

# Оставляем контейнер запущенным
tail -f /dev/null
