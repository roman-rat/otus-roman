## Описание Vagrantfile (сразу собирает RAID5)

Этот Vagrantfile создаёт виртуальную машину с CentOS 9 Stream и настраивает её для работы с RAID массивом:

1. **Настройка виртуальной машины в VirtualBox**:
   - Образ и ресурсы аналогичны ВМ из предыдушего задания.
   - Назвали виртуальную машину `"CentRAID"`.
   - Создали три дополнительных диска по 5 ГБ каждый для создания RAID массива и подключили их.

2. **Автоматическая настройка через shell**:
   - Создаётся пользователь `"roman"` с паролем и добавляется в группу администраторов (`wheel`).
   - Устанавливаем `mdadm`, чтобы работать с RAID.
   - На этих дополнительных дисках собирается RAID 5.
   - RAID массив форматируется в файловую систему `ext4`.
   - Создаётся папка `/mnt/raid`, и туда монтируется RAID массив.
   - Убедились, что RAID автоматически собирается и монтируется после перезагрузки с помощью настроек в `mdadm.conf` и `fstab`.


## Скрипт для создания и настройки RAID массива

Написали скрипт для создания RAID массива любого типа, а не только RAID5, который использовался в vagrantfile для задания. Вот что он делает:

1. Выводит список дисков, которые можно использовать для RAID.

2. Проверяет, что выбранные диски существуют и их достаточно для создания RAID выбранного типа. Если что-то не так, выводит ошибку и прекращает свою раюоту.

3. Собирает RAID массив из выбранных дисков с указанным уровнем RAID.

4. Создаёт GPT раздел на RAID массиве, форматирует его в `ext4` и монтируем.

5. Добавляет настройки, чтобы RAID автоматически собирался и монтировался при загрузке системы.

После запуска этого скрипта RAID массив будет готов к использованию и автоматически смонтируется в системе.
