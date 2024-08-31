#!/bin/bash

# вывод заголовка таблицы
printf "%-10s %-6s %-6s %-8s %-10s %-3s %-7s %-15s %-9s %-8s %s\n" "COMMAND" "PID" "TID" "TASKCMD" "USER" "FD" "TYPE" "DEVICE" "SIZE/OFF" "NODE" "NAME"

# перебираем все процессы в /proc
for pid in $(ls /proc | grep -E '^[0-9]+$'); do


    #получаем имя 
    process_name=$(cat /proc/$pid/comm 2>/dev/null)
    user_name=$(ps -o user= -p $pid 2>/dev/null)

    # если информация о процессе доступна, перебираем открытые дескрипторы в /proc/<pid>/fd
    if [ -n "$process_name" ]; then
        if [ -d "/proc/$pid/fd" ]; then
            for fd in /proc/$pid/fd/*; do
                if [ -e "$fd" ]; then
                    file_path=$(readlink -f "$fd" 2>/dev/null)
                    fd_num=$(basename "$fd")
                    file_type=$(stat --format=%F "$fd" 2>/dev/null)
                    inode=$(stat --format=%i "$fd" 2>/dev/null)
                    device=$(stat --format=%D "$fd" 2>/dev/null)
                    size=$(stat --format=%s "$fd" 2>/dev/null)

                    # меняем названия типов файлов как в lsof
                    case "$file_type" in
                        "directory") file_type="DIR" ;;
                        "regular file") file_type="REG" ;;
                        "symbolic link") file_type="LNK" ;;
                        "socket") file_type="SOCK" ;;
                        "FIFO"|"pipe") file_type="FIFO" ;;
                        "character special file") file_type="CHR" ;;
                        *) file_type="UNKNOWN" ;;
                    esac

                    # Вывод в данных в виде таблицы
                    printf "%-10s %-6s %-6s %-8s %-10s %-3s %-7s %-15s %-9s %-8s %s\n" "$process_name" "$pid" "-" "-" "$user_name" "$fd_num" "$file_type" "$device" "$size" "$inode" "$file_path"
                fi
            done
        fi
    fi
done
