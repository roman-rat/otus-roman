#!/bin/bash

# Функция для вывода доступных дисков
list_disks() {
  echo "Доступные диски:"
  lsblk -d -n -o NAME,SIZE | grep -E '^sd[a-z]+'
}

# Функция для проверки, что диски существуют и достаточно для выбранного типа RAID
validate_disks() {
  IFS=',' read -ra selected_disks <<< "$1"
  for disk in "${selected_disks[@]}"; do
    if ! lsblk -d -n -o NAME | grep -q "^$disk$"; then
      echo "Диск /dev/$disk не существует."
      exit 1
    fi
  done

  # Проверяем, достаточно ли дисков для выбранного типа RAID
  case $2 in
    0)
      if [ ${#selected_disks[@]} -lt 2 ]; then
        echo "Для RAID 0 необходимо как минимум 2 диска."
        exit 1
      fi
      ;;
    1)
      if [ ${#selected_disks[@]} -lt 2 ]; then
        echo "Для RAID 1 необходимо как минимум 2 диска."
        exit 1
      fi
      ;;
    5)
      if [ ${#selected_disks[@]} -lt 3 ]; then
        echo "Для RAID 5 необходимо как минимум 3 диска."
        exit 1
      fi
      ;;
    6)
      if [ ${#selected_disks[@]} -lt 4 ]; then
        echo "Для RAID 6 необходимо как минимум 4 диска."
        exit 1
      fi
      ;;
    10)
      if [ ${#selected_disks[@]} -lt 4 ]; then
        echo "Для RAID 10 необходимо как минимум 4 диска."
        exit 1
      fi
      ;;
    *)
      echo "Неверный тип RAID."
      exit 1
      ;;
  esac
}

# Функция для создания GPT раздела
create_gpt_partition() {
  local raid_device=$1
  echo "Создание GPT раздела на $raid_device"
  parted --script $raid_device mklabel gpt
  parted --script $raid_device mkpart primary ext4 1MiB 100%
}

# Основная программа

# Запрашиваем тип RAID
echo "Выберите тип RAID (0, 1, 5, 6, 10):"
read -r raid_level

# Выводим список доступных дисков
list_disks

# Запрашиваем диски для RAID
echo "Введите диски для создания RAID (через запятую, например: sdb,sdc,sdd):"
read -r disks

# Проверяем корректность выбранных дисков и их достаточность для RAID
validate_disks "$disks" "$raid_level"

# Создаем RAID массив
raid_device="/dev/md0"
sudo mdadm --create --verbose $raid_device --level=$raid_level --raid-devices=${#selected_disks[@]} /dev/${disks//,/ /dev/}

# Создаем GPT раздел
create_gpt_partition $raid_device

# Форматируем раздел в ext4
sudo mkfs.ext4 "${raid_device}p1"

# Монтируем раздел
mount_point="/mnt/raid"
sudo mkdir -p $mount_point
sudo mount "${raid_device}p1" $mount_point

# Добавляем RAID в mdadm.conf для автосборки при загрузке
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf

# Обновляем initramfs для поддержки RAID
sudo dracut --force --add mdadm

# Добавляем раздел в fstab для автоматического монтирования
echo "${raid_device}p1 $mount_point ext4 defaults 0 0" | sudo tee -a /etc/fstab

echo "RAID $raid_level успешно создан и настроен. Раздел смонтирован."
