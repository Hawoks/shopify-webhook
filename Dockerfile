# Используем базовый образ Alpine с Python
FROM python:3.10-alpine

# Устанавливаем зависимости
RUN apk update && apk add --no-cache \
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

# Добавляем `tutor` в PATH
ENV PATH="/root/.local/bin:$PATH"

# Указываем рабочую директорию
WORKDIR /app

# Указываем, где хранятся данные Tutor
ENV TUTOR_ROOT="/root/.local/share/tutor"

# Предварительная настройка Open edX
RUN tutor config save --set LMS_HOST=uni-books.online \
                       --set CMS_HOST=studio.uni-books.online \
                       --set PLATFORM_NAME="Uni-Books Online" \
                       --set CONTACT_EMAIL="contact@uni-books.online" \
                       --set DEFAULT_LANGUAGE="en" \
                       --set ENABLE_HTTPS=true

# Разворачиваем Open edX во время сборки
RUN tutor local start && tutor local stop

# Открываем порты (чтобы Open edX работал при запуске)
EXPOSE 80 443 8000 18000 3030 3306 9200 27017

# Копируем скрипт старта
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Автозапуск Tutor при старте контейнера
CMD ["sh", "-c", "/start.sh"]
