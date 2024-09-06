#!/bin/bash
    # Получаем текущий день недели (1 = Понедельник, ..., 7 = Воскресенье)
    day_of_week=$(date +%u)

    # Если день суббота (6) или воскресенье (7), проверяем группу
    if [[ "$day_of_week" -gt 5 ]]; then
      # Проверяем, если пользователь в группе admin
      if groups $PAM_USER | grep -q "\\badmin\\b"; then
        exit 0
      else
        exit 1
      fi
    else
      exit 0
    fi'