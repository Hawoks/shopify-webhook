#!/bin/sh

echo "🚀 Запуск Docker Daemon..."
dockerd &

echo "⏳ Ожидаем, пока Docker запустится..."
sleep 10

echo "🔧 Настраиваем Tutor Open edX..."
tutor config save --set LMS_HOST=uni-books.online \
                  --set CMS_HOST=studio.uni-books.online \
                  --set PLATFORM_NAME="Uni-Books Online" \
                  --set CONTACT_EMAIL="contact@uni-books.online" \
                  --set DEFAULT_LANGUAGE="en" \
                  --set ENABLE_HTTPS=true

echo "🌍 Запускаем Tutor Open edX..."
tutor local launch <<EOF
y
uni-books.online
studio.uni-books.online
Uni-Books Online
contact@uni-books.online
en
y
EOF

echo "🛑 Останавливаем Tutor перед загрузкой образа..."
tutor local stop

echo "✅ Tutor полностью настроен! Готово к загрузке в Docker Hub."
