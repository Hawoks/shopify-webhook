# Используем официальный образ Docker-in-Docker (DinD)
FROM docker:latest

# Устанавливаем необходимые пакеты
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    docker-cli \
    && ln -sf python3 /usr/bin/python \
    && pip install --upgrade pip

# Устанавливаем Python 3.9+
RUN pip install --upgrade pip setuptools wheel \
    && pip install "tutor[full]==18.2.2"

# Открываем порты (если нужно)
EXPOSE 2375 8000 80 443

# Запуск Docker Daemon в контейнере (DinD)
CMD ["dockerd-entrypoint.sh"]
