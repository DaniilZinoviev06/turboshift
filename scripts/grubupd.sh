#! /bin/bash

EXPECTED_ENTRY="user_distro"

grubUpdArchFunc() {
	sudo grub-mkconfig -o /boot/grub/grub.cfg
}

if [[ -f  $CONF ]]; then
	echo "$CONF file found / Файл $CONF найден"
  
	if grep -q "$EXPECTED_ENTRY" "$CONF"; then
		echo "The $EXPECTED_ENTRY entry was found in the file / Запись $EXPECTED_ENTRY найдена в файле"
		DISTRO=$user_distro
		if [ "$DISTRO" = "Arch" ]; then
			echo "Arch linux(btw) / Арч"
			grubUpdArchFunc
		else
			echo "Distribution not found / Дистрибутив не найден"
		fi
	fi
fi
