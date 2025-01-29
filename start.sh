#!/bin/sh

echo "🚀 Запуск Docker Daemon..."
dockerd &

echo "⏳ Ожидание 10 секунд, пока Docker полностью запустится..."
sleep 10

echo "🎓 Запуск Open edX..."
tutor local start

echo "✅ Open edX запущен! Система готова к работе."

# Оставляем контейнер запущенным
tail -f /dev/null
