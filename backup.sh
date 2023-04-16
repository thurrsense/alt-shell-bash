#!/bin/bash

# Проверяем, что передано два параметра
if [ $# -ne 2 ]; then
  echo "Неверное количество параметров. Использование: $0 <copy_dir> <backup_dir>"
  exit 1
fi

copy_dir=$1
backup_dir=$2

# Проверяем, что каталог копирования существует
if [ ! -d "$copy_dir" ]; then
  echo "Каталог копирования $copy_dir не существует"
  exit 1
fi

# Создаем директорию резервных копий, если она не существует
if [ ! -d "$backup_dir" ]; then
  mkdir -p "$backup_dir"
fi

# Создаем имя файла архива
backup_file="$backup_dir/$(basename $copy_dir)-$(date +%Y%m%d-%H%M%S).tar.gz"

# Создаем архив и записываем логи
tar -czf "$backup_file" "$copy_dir" 2>&1 | tee "$backup_dir/backup.log"

# Определяем количество существующих резервных копий
existing_backups=$(find "$backup_dir" -maxdepth 1 -name "$(basename $copy_dir)-*.tar.gz" | wc -l)

# Если количество копий больше заданного лимита, удаляем самую старую копию
if [ $existing_backups -gt 5 ]; then
  oldest_backup=$(find "$backup_dir" -maxdepth 1 -name "$(basename $copy_dir)-*.tar.gz" -printf '%T@ %p\n' | sort -n | head -n 1 | awk '{print $2}')
  rm "$oldest_backup"
fi

echo "Резервное копирование $copy_dir успешно выполнено и сохранено в $backup_file"
exit 0

