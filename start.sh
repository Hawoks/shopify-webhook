#!/bin/sh

echo "🚀 Запуск Docker Daemon..."
if [ -e /var/run/docker.pid ]; then
    rm /var/run/docker.pid
fi
nohup dockerd > /dev/null 2>&1 &
sleep 10

echo "🎓 Запуск Open edX..."
tutor local start

echo "✅ Open edX запущен! Система готова к работе."

# Оставляем контейнер запущенным
tail -f /dev/null
