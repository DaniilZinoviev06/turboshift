#! /bin/bash

###
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
CONF="$(realpath "$SCRIPT_DIR/../setgs.conf")"
###

if [[ -f $CONF ]]; then
	source "$CONF"
	echo "User email / Почта пользователя: $user_email"
fi

####### SETTINGS FUNCTIONS ##########
CheckConfDistroFunc() {
	EXPECTED_ENTRY="user_distro"

	if [[ -f  $CONF ]]; then
		echo "$CONF file found / Файл $CONF найден"
	  
		if grep -q "$EXPECTED_ENTRY" "$CONF"; then
			echo "The $EXPECTED_ENTRY entry was found in the file / Запись $EXPECTED_ENTRY найдена в файле"
			DISTRO=$user_distro
			if [ -z "$DISTRO" ]; then
				DISTRO=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"' | sed 's/ Linux//')
				sed -i "/^user_distro=/s/=.*/=$DISTRO/" "$CONF"
				echo "$EXPECTED_ENTRY is defined / $EXPECTED_ENTRY определен"
			fi
		else
			echo "The $EXPECTED_ENTRY entry was not found in the file / Запись $EXPECTED_ENTRY не найдена в файле"
			DISTRO=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"' | sed 's/ Linux//')
			echo "user_distro=\"$DISTRO\"" >> $CONF 
			echo "$EXPECTED_ENTRY is now defined / $EXPECTED_ENTRY теперь определен"
		fi
	else
		echo "$CONF file not found / Файл $CONF не найден"
	fi	
}

enableSCFAAWPFunc() {
	EXPECTED_ENTRY="isEnableSCFAAWP"

	if [[ -f  $CONF ]]; then
		echo "$CONF file found / Файл $CONF найден"
	  
		if grep -q "$EXPECTED_ENTRY" "$CONF"; then
			echo "The $EXPECTED_ENTRY entry was found in the file / Запись $EXPECTED_ENTRY найдена в файле"
		else
			echo "The $EXPECTED_ENTRY entry was not found in the file / Запись $EXPECTED_ENTRY не найдена в файле"
			echo "isEnableSCFAAWP=no" >> $CONF 
			echo "$EXPECTED_ENTRY is now defined / $EXPECTED_ENTRY теперь определен"
		fi
	else
		echo "$CONF file not found / Файл $CONF не найден"
	fi	
}

createShortcut() {
	EXPECTED_ENTRY1="Exec"
	EXPECTED_ENTRY2="Icon"
	EXPECTED_ENTRY3="Terminal"
	echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
	SHORTCUT="$(pwd)/../script.desktop"
	if [[ -f $SHORTCUT ]]; then
		echo "$SHORTCUT file found / Файл $SHORTCUT найден"
		
		if grep -q "$EXPECTED_ENTRY1" "$SHORTCUT" || grep -q "$EXPECTED_ENTRY2" "$SHORTCUT" || grep -q "$EXPECTED_ENTRY3" "$SHORTCUT"; then
			echo "The entry was found in the file / Записи найдены в файле"
		else
			sudo chown $(whoami) $(pwd)
			echo "The entry was not found in the file / Запись не найдена в файле"
			echo "Exec=$(pwd)/script.sh" >> $SHORTCUT 
			echo "Icon=$(realpath "$SCRIPT_DIR/../logo.jpg")" >> $SHORTCUT
			echo "Terminal=true" >> $SHORTCUT
		fi
		
		chmod +x $SHORTCUT
		sudo mv $SHORTCUT /usr/share/applications/
		sudo mv /usr/share/applications/timeshift-gtk.desktop $(pwd)/../
		echo "Shortcut created / Ярлык создан"
	else
		echo " .desktop file does not exist or has it already been created / Для ярлыка не найден соответствующий файл или ярлык уже был создан"
	fi
	sudo rm /etc/sudoers.d/$(whoami)
}
#############################################
echo "---------------------------------------------------------------------------"
CheckConfDistroFunc
echo "---------------------------------------------------------------------------"
enableSCFAAWPFunc
echo "---------------------------------------------------------------------------"
createShortcut
echo "---------------------------------------------------------------------------"

echo -e "\e[32mYour distro / Ваш дистрибутив\e[0m"
echo $DISTRO
