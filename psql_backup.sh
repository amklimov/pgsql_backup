#!/usr/bin/env bash

DATE=$(date +%F_%H.%M)
DIR="/opt/backup/database"
DATABASES=("opmd" "pg_monitor" "awx" "otrs" "zabbix")

# Создаем директорию бэкапов, если она не существует
mkdir -p "$DIR"

# Бэкап базы данных
for DB in "${DATABASES[@]}"; do
    BACKUP_PATH="$DIR/${DB}_$DATE"
    LOG_FILE="$BACKUP_PATH.log"

    # Запуск pg_dump с логированием
    pg_dump -U postgres -j 4 -v -Fd "$DB" -f "$BACKUP_PATH" &>"$LOG_FILE"

    # Очистка старых бэкапов старше 10 дней
    find "$DIR" -name "${DB}_*" -type d -ctime +10 -exec rm -rf {} +
done

