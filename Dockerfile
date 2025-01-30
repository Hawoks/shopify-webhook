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
    docker-cli \
    docker-compose

# Создаем виртуальное окружение и устанавливаем Tutor
RUN python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip install --upgrade pip \
    && pip install "tutor[full]==18.2.2" \
    && deactivate

# Добавляем виртуальное окружение в PATH
ENV PATH="/venv/bin:$PATH"

# Указываем рабочую директорию
WORKDIR /app

# Указываем, где хранятся данные Tutor
ENV TUTOR_ROOT="/root/.local/share/tutor"

# Запускаем Docker Daemon ВНУТРИ контейнера (БЕЗ ХОСТА)
RUN dockerd --storage-driver=vfs & \
    sleep 10

# Конфигурируем Tutor (автоматически передаём ответы)
RUN printf "Y\nuni-books.online\nstudio.uni-books.online\nUni-Books Online\ncontact@uni-books.online\nen\nY\n" | tutor local launch

# Даём Tutor поработать 60 секунд и корректно останавливаем
RUN sleep 60 && tutor local stop

# Открываем порты
EXPOSE 80 443 8000 18000 3030 3306 9200 27017

# Копируем скрипт старта
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Запуск контейнера
CMD ["sh", "-c", "/start.sh"]
