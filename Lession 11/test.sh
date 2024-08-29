#!/bin/bash

# Настройки
LOG_DIR="/var/log/nginx/"           
EMAIL="atrashyonok2014@gmail.com"    
LOCKFILE="/tmp/send_report.lock"      # файл блокировки для предотвращения одновременного запуска
LAST_RUN_FILE="/tmp/last_run_time.txt" # файл с временной меткой последнего запуска
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S") 
TEMP_LOG="/tmp/temp_log.log"          # временный файл для хранения логов
TEMP_REPORT="/tmp/report.txt"         # временный файл для хранения отчета

# Установка одной ловушки (trap) для очистки ресурсов при завершении или ошибке
trap 'cleanup_and_exit' INT TERM EXIT

# Функция очистки ресов
cleanup_and_exit() {
  rm -f "$TEMP_LOG" "$TEMP_REPORT"
  rm -f "$LOCKFILE"
  exit
}

# Функция проверки на одновременный запуск
check_lock() {
  if [ -f "$LOCKFILE" ]; then
    echo "Скрипт уже выполняется. Завершение."
    exit 1
  fi
  touch "$LOCKFILE"
}

# Функция определения временного диапазона
determine_time_range() {
  if [ -f "$LAST_RUN_FILE" ]; then
    LAST_RUN_TIME=$(cat "$LAST_RUN_FILE")
  else
    LAST_RUN_TIME=$(date -d "@$(($(date +%s) - 3600))" "+%Y-%m-%d %H:%M:%S")
  fi
  echo "$CURRENT_TIME" > "$LAST_RUN_FILE"
}

# Функция загрузки логов
load_logs() {
  find "$LOG_DIR" -type f -name "*.log" -newermt "$LAST_RUN_TIME" -exec cat {} \; > "$TEMP_LOG"
  sed -i 's/[\[\]"]//g' "$TEMP_LOG"
}

# Функция анализа логов
analyze_logs() {
  TOP_IPS=$(awk '{print $1}' "$TEMP_LOG" | sort | uniq -c | sort -nr | head -n 10) #Извлекает IP-адреса из логов
  TOP_URLS=$(awk '{print $7}' "$TEMP_LOG" | sort | uniq -c | sort -nr | head -n 10) #Извлекает URL из логов
  ERRORS=$(grep "error" "$TEMP_LOG") #Ищет все строки, содержащие "error"
  HTTP_CODES=$(awk '{print $9}' "$TEMP_LOG" | grep -E '^[0-9]{3}$' | sort | uniq -c | sort -nr) #Извлекает коды HTTP-ответов
}

# Функция создания отчета
create_report() {
  echo "Отчет за период: $LAST_RUN_TIME - $CURRENT_TIME" > "$TEMP_REPORT"
  echo -e "\nСписок IP адресов с наибольшим количеством запросов:" >> "$TEMP_REPORT"
  echo "$TOP_IPS" >> "$TEMP_REPORT"
  echo -e "\nСписок URL с наибольшим количеством запросов:" >> "$TEMP_REPORT"
  echo "$TOP_URLS" >> "$TEMP_REPORT"
  echo -e "\nОшибки веб-сервера/приложения:" >> "$TEMP_REPORT"
  echo "$ERRORS" >> "$TEMP_REPORT"
  echo -e "\nСписок всех кодов HTTP ответа:" >> "$TEMP_REPORT"
  echo "$HTTP_CODES" >> "$TEMP_REPORT"
}

# Функция отправки отчета по электронной почте
send_report() {
  mail -s "Отчет по логам веб-сервера" "$EMAIL" < "$TEMP_REPORT"
}

# Основная функция запуска скрипта
main() {
  check_lock
  determine_time_range
  load_logs
  analyze_logs
  create_report
  send_report
}

# Запуск основной функции
main
