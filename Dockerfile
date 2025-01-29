# Используем базовый образ Alpine Linux с Python 3.10
FROM python:3.10-alpine

# Устанавливаем необходимые зависимости
RUN apk update && apk add --no-cache \
    docker-cli \
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
    && pip install --upgrade pip

# Устанавливаем Tutor Open edX версии 18.2.2
RUN pip install "tutor[full]==18.2.2"

# Указываем рабочую директорию
WORKDIR /app

# Открываем порты (если нужно)
EXPOSE 8000 80 443

# Указываем команду по умолчанию
CMD ["/bin/sh"]
