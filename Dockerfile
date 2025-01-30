# Используем базовый образ с Docker-in-Docker
FROM docker:24-dind

# Устанавливаем зависимости
RUN apk update && apk add --no-cache \
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
    python3 \
    py3-pip \
    nginx \
    certbot \
    && python3 -m venv /venv \
    && source /venv/bin/activate \
    && pip install --upgrade pip


# Устанавливаем Tutor Open edX версии 18.2.2
RUN pip install "tutor[full]==18.2.2"

# Указываем рабочую директорию
WORKDIR /app

# Указываем, где хранятся данные Tutor
ENV TUTOR_ROOT="/root/.local/share/tutor"
ENV PATH="/root/.local/bin:$PATH"

# Настройка Open edX
RUN tutor config save --set LMS_HOST=uni-books.online \
                       --set CMS_HOST=studio.uni-books.online \
                       --set PLATFORM_NAME="Uni-Books Online" \
                       --set CONTACT_EMAIL="contact@uni-books.online" \
                       --set DEFAULT_LANGUAGE="en" \
                       --set ENABLE_HTTPS=true

# Разворачиваем Open edX
RUN dockerd & \
    sleep 10 && \
    tutor local launch && \
    sleep 60 && \
    tutor local stop

# Открываем порты
EXPOSE 80 443 8000 18000 3030 3306 9200 27017

# Копируем скрипт старта
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Запуск контейнера
CMD ["sh", "-c", "/start.sh"]
