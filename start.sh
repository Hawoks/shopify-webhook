#!/bin/bash

echo "🚀 Запускаем Docker Daemon..."
dockerd &

echo "⏳ Ожидание запуска Docker..."
sleep 10

echo "🚀 Запускаем Open edX..."
tutor local start
