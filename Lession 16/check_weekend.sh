#!/bin/bash

# Получаем текущий день недели (1 - Понедельник, 7 - Воскресенье)
current_day=$(date +%u)

# Проверяем, если день недели суббота (6) или воскресенье (7)
if [[ $current_day -gt 5 ]]; then
  # Проверяем, если пользователь не в группе admin
  if ! groups $PAM_USER | grep -qw admin; then
    exit 1
  fi
fi

# Разрешаем доступ
exit 0