# Используем базовый образ Alpine Linux с Python 3.10
FROM python:3.10-alpine

# Устанавливаем необходимые зависимости
RUN apk update && apk add --no-cache \
    docker \
    docker-cli \
    docker-compose \
    bash \
    curl \
    git \
    gcc \
    libc-dev \
    linux-headers \
    musl-dev \
    libffi-dev \
    openssl-dev \
    cargo \
    nginx \
    certbot \
    && pip install --upgrade pip

# Устанавливаем Tutor Open edX версии 18.2.2
RUN pip install "tutor[full]==18.2.2"

# Указываем рабочую директорию
WORKDIR /app

# Открываем порты (HTTPS, HTTP, LMS, CMS)
EXPOSE 80 443 8000 18000 3030 3306 9200 27017

# Добавляем автоконфигурацию Open edX при запуске контейнера
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Запуск Docker Daemon и Tutor Open edX
CMD ["sh", "-c", "dockerd & /entrypoint.sh"]
