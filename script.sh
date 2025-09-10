#!/bin/bash

# Определение переменных
SOURCE_DIR="/home/stpdcybersec/test/catalog"  # Исходный каталог для копирования
BACKUP_DIR="/home/stpdcybersec/test/backup"  # Каталог для хранения архива
ARCHIVE_NAME="backup_$(date +%Y%m%d_%H%M%S).tar.gz"  # Имя архива с timestamp
LOG_FILE="/home/stpdcybersec/test/logs/backup.log"  # Файл лога
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME" # Путь к архиву

# Функция для логирования
log_message() 
{
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE" 
}

# Обработчик ошибок
set -e  # Выход при любой ошибке
trap 'log_message "ERROR: Script failed at line $LINENO"; exit 1' ERR INT TERM

# Проверка наличия исходного каталога
if [ ! -d "$SOURCE_DIR" ]; then
    log_message "ERROR: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Проверка наличия каталога бэкапа и его создание, если он не существует
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to create backup directory '$BACKUP_DIR'."
        exit 1
    fi
    log_message "INFO: Created backup directory '$BACKUP_DIR'."
fi

# Создание архива
log_message "INFO: Starting backup of '$SOURCE_DIR' to '$ARCHIVE_PATH'."
tar -czf "$ARCHIVE_PATH" -C "$SOURCE_DIR" . >> "$LOG_FILE"
if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to create archive '$ARCHIVE_PATH'."
    exit 1
else
    log_message "SUCCESS: Archive '$ARCHIVE_PATH' created seccessfully."
fi

# Проверка целостности архива:
log_message "INFO: Verifying archive integrity."
if tar -tzf "$ARCHIVE_PATH" 2>> /dev/null ; then
    log_message "SUCCESS: Archive '$ARCHIVE_PATH' verified successfully."
else
    log_message "ERROR: Archive '$ARCHIVE_PATH' integrity check failed."
    rm -f "$ARCHIVE_PATH"  # Удаление архива, если он повреждён
    exit 1
fi

log_message "SUCCESS: Backup process completed successfully."
exit 0
