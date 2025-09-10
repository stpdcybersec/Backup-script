# Backup-script
Bash-скрипт для создания резервных копий каталогов с проверкой целостности и логированием.
## Инструкция
1. Клонируйте репозиторий или скачайте скрипт;
2. Сделайте скрипт исполняемым (chmod +x script.sh);
3. Настройте пути в скрипте под себя:
     - SOURCE_DIR="/path/to/your/source/directory"   #Что архивировать
	 - BACKUP_DIR="/path/to/your/backup/directory"   #Куда сохранять архивы
	 - LOG_FILE="/path/to/your/logs/backup.log"      #Где хранить логи
