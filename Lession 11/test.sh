#!/bin/bash

# Настройки
LOG_FILE="/var/log/messages"          # файл логов системных сообщений
EMAIL="atrashyonok2014@gmail.com"           # email для отправки отчета
LOCKFILE="/tmp/send_report.lock"      # файл блокировки для предотвращения одновременного запуска
LAST_RUN_FILE="/tmp/last_run_time.txt" # файл с временной меткой последнего запуска
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S") # текущее время
TEMP_LOG="/tmp/temp_log.log"          # временный файл для хранения логов
TEMP_REPORT="/tmp/report.txt"         # временный файл для хранения отчета

# Установка одной ловушки (trap) для очистки ресурсов при завершении или ошибке
trap 'cleanup_and_exit' INT TERM EXIT

# Функция очистки ресурсов
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
  # Используем awk для выбора строк по временной метке
  awk -v last_run="$LAST_RUN_TIME" '$0 > last_run' "$LOG_FILE" > "$TEMP_LOG"
}

# Функция анализа логов
analyze_logs() {
  # Анализ данных по системному логу /var/log/messages
  TOP_SERVICES=$(awk '{print $5}' "$TEMP_LOG" | sort | uniq -c | sort -nr | head -n 10)
  ERRORS=$(grep -i "error" "$TEMP_LOG")
  WARNINGS=$(grep -i "warning" "$TEMP_LOG")
}

# Функция создания отчета
create_report() {
  echo "Отчет за период: $LAST_RUN_TIME - $CURRENT_TIME" > "$TEMP_REPORT"
  echo -e "\nСписок служб с наибольшим количеством сообщений:" >> "$TEMP_REPORT"
  echo "$TOP_SERVICES" >> "$TEMP_REPORT"
  echo -e "\nОшибки:" >> "$TEMP_REPORT"
  echo "$ERRORS" >> "$TEMP_REPORT"
  echo -e "\nПредупреждения:" >> "$TEMP_REPORT"
  echo "$WARNINGS" >> "$TEMP_REPORT"
}

# Функция отправки отчета по электронной почте
send_report() {
  mail -s "Отчет по системным логам" "$EMAIL" < "$TEMP_REPORT"
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
