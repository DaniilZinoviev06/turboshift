#! /bin/bash

###
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
echo $SCRIPT_DIR
CONF="$(realpath "$SCRIPT_DIR/../setgs.conf")"
echo $CONF
echo "$(realpath "$SCRIPT_DIR/..")"
###
echo -e "\e[36m####################################################################################\e[0m"

cat << "EOF"
▗▄▄▖  ▗▄▖  ▗▄▄▖▗▖ ▗▖ ▗▄▖  ▗▄▄▖▗▄▄▄▖ ▗▄▄▖
▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌▗▞▘▐▌ ▐▌▐▌   ▐▌   ▐▌
▐▛▀▘ ▐▛▀▜▌▐▌   ▐▛▚▖ ▐▛▀▜▌▐▌▝▜▌▐▛▀▀▘ ▝▀▚▖
▐▌   ▐▌ ▐▌▝▚▄▄▖▐▌ ▐▌▐▌ ▐▌▝▚▄▞▘▐▙▄▄▖▗▄▄▞▘

EOF

echo "Install the required packages / Установим необходимы пакеты..."
source $SCRIPT_DIR/packages.sh
###
echo -e "\e[36m####################################################################################\e[0m"

cat << "EOF"
 ▗▄▄▖▗▄▄▄▖▗▄▄▄▖▗▄▄▄▖▗▄▄▄▖▗▖  ▗▖ ▗▄▄▖ ▗▄▄▖
▐▌   ▐▌     █    █    █  ▐▛▚▖▐▌▐▌   ▐▌
 ▝▀▚▖▐▛▀▀▘  █    █    █  ▐▌ ▝▜▌▐▌▝▜▌ ▝▀▚▖
▗▄▄▞▘▐▙▄▄▖  █    █  ▗▄█▄▖▐▌  ▐▌▝▚▄▞▘▗▄▄▞▘

EOF

source $SCRIPT_DIR/settings.sh
echo -e "\e[36m####################################################################################\e[0m"
###
source $SCRIPT_DIR/grubupd.sh
echo -e "\e[36m####################################################################################\e[0m"
###

############## MAIN FUNCTIONS ##############
createBackupFunc() {
	clear
	echo -e "En: \e[34mHere you can create a snapshot that will be automatically added to grub.\e[0m"
	echo -e "Ru: \e[34mЗдесь Вы можете создать снимок системы, который сразу добавится в grub.\e[0m\n"
	echo -e "\e[32m| 1 - Move on to create / Перейти к созданию\e[0m\n"
	echo -e "\e[34m| 2 - Back / Назад\n\e[0m\n"
	read -p "Enter value / Введите действие: " sub_action

	case $sub_action in
	1)
		echo -e "\n"
		read -p "Enter comment / Введите комментарий для бэкапа: " comment
		sudo timeshift --create --comments "$comment"
		source $SCRIPT_DIR/grubupd.sh
		break
	;;
	2)
		break
	;;
	*)
		echo -e "\e[31mInvalid value / Некорректный ввод \e[0m"
	;;
	esac
}

restoreBackupFunc() {
	clear
	echo -e "En: \e[34mHere you can restore your system.\e[0m"
	echo -e "Ru: \e[34mЗдесь Вы можете восстановить систему.\e[0m\n"
	echo -e "\e[32m| 1 - Move on to restore / Перейти к восстановлению системы\e[0m\n"
	echo -e "\e[34m| 2 - Back / Назад\n\e[0m\n"
	read -p "Enter value / Введите действие: " sub_action

	case $sub_action in
	1)
		echo -e "\n"
		echo -e "\e[32m$(sudo timeshift --list)\e[0m"
		read -p "Enter backup name / Введите название бэкапа: " name
		sudo timeshift --restore --snapshot $name
		break
	;;
	2)
		break
	;;
	*)
		echo -e "\e[31mInvalid value / Некорректный ввод \e[0m"
	;;
	esac
}

timeshiftAutoBackupsFunc() {
	clear
	echo -e "\e[32m| 1 - Create autobackup (hourly) / Создать автобэкап (почасовые)\e[0m\n"
	echo -e "\e[32m| 2 - Create autobackup (daily) / Создать автобэкап (дневные)\e[0m\n"
	echo -e "\e[32m| 3 - Create autobackup (weekly) / Создать автобэкап (еженедельные)\e[0m\n"
	echo -e "\e[32m| 4 - Create autobackup (monthly) / Создать автобэкап (ежемесячные)\e[0m\n"
	echo -e "\e[32m| 5 - Create autobackup (boot) / Создать автобэкап (при запуске системы)\e[0m\n"
	echo -e "\e[34m| 6 - Back / Назад\n\e[0m\n"
	read -p "Enter value / Введите действие: " sub_action
	case $sub_action in
		1)
			clear
			sudo timeshift --create --tags H
			source $SCRIPT_DIR/grubupd.sh
			break
		;;
		2)
			clear
			sudo timeshift --create --tags D
			source $SCRIPT_DIR/grubupd.sh
			break
		;;
		3)
			clear
			sudo timeshift --create --tags W
			source $SCRIPT_DIR/grubupd.sh
			break
		;;
		4)
			clear
			sudo timeshift --create --tags M
			source $SCRIPT_DIR/grubupd.sh
			break
		;;
		5)
			clear
			sudo timeshift --create --tags B
			source $SCRIPT_DIR/grubupd.sh
			break
		;;
		6)
			clear
			break
		;;
		*)
			clear
			echo -e "\n\e[31m(-_-)/ |Incorrect value / Неправильный ввод|\e[0m"
			break
		;;
	esac
}

autoBackupFunc() {
	clear
	echo -e "En: \e[34mHere you can create autobackups.\e[0m"
	echo -e "Ru: \e[34mЗдесь Вы можете настроить бэкапы по расписанию.\e[0m\n"
	echo -e "\e[32m| 1 - Create autobackup (Timeshift original) / Создать автобэкап (из Timeshift)\e[0m\n"
	echo -e "\e[32m| 2 - Create autobackup / Создать автобэкап\e[0m\n"
	echo -e "\e[32m| 3 - Clear autobackups / Очистить бэкапы по расписанию\e[0m\n"
	echo -e "\e[34m| 4 - Back / Назад\n\e[0m\n"
	read -p "Enter value / Введите действие: " sub_action
	case $sub_action in
		1)
			clear
			timeshiftAutoBackupsFunc
		;;
		
		2)
			clear
			read -p "Comment / Введите комментарий для бэкапа: " comment
			read -p "Month / Введите месяц (число, например, 9 для сентября): " month
			read -p "Day of the week / Введите день недели (0 для воскресенья, 1 для понедельника и т.д.): " day
			read -p "Enter time / Введите время (например, 12:45): " time

			IFS=':' read -r hour minute <<< "$time"

			if [[ ! $hour =~ ^[0-9]+$ ]] || [[ ! $minute =~ ^[0-9]+$ ]] || [[ "$hour" -lt 0 ]] || [[ "$hour" -gt 23 ]] || [[ "$minute" -lt 0 ]] || [[ "$minute" -gt 59 ]]; then
			    echo "Incorrect time / Некорректное время."
			    exit 1
			fi

			crontab -l > cron
			(crontab -l 2>/dev/null; echo "$minute $hour * $month $day sudo timeshift --create --comments \"$comment\"") >> cron
			(crontab -l 2>/dev/null; echo "$minute $hour * $month $day sudo grub-mkconfig -o /boot/grub/grub.cfg") >> cron
			sudo crontab cron
			rm cron
			break
		;;

		3)
			clear
			echo -e "\n\e[34m### \e[32mCOMMANDS IN CRON(Script delete this commands)\e[0m / \e[32mКОМАНДЫ CRON(Скрипт удалит команды снизу)\e[34m ###\e[0m\n"
			echo -e "\e[31m$(sudo crontab -l)\e[0m"
			echo -e "\e[34m#################################################################################################\e[0m\n"
			echo -e "\e[31m//////////////////////////////////////////////////////////////////\n"
			sudo crontab -r
			echo -e "\n//////////////////////////////////////////////////////////////////\e[0m"
			echo -e "\n\e[34m### \e[32mCOMMANDS IN CRON(Now)\e[0m / \e[32mКОМАНДЫ CRON(Текущее состояние)\e[34m ###\e[0m\n"
			echo -e "\e[31m$(sudo crontab -l)\e[0m"
			echo -e "\e[34m###############################################################\e[0m\n"
			sleep 10
			break
		;;

	       *)
			clear
			echo -e "\n\e[31m(-_-)/ |Incorrect value / Неправильный ввод|\e[0m"
			break
	       	;;
	esac
}

deleteBackupFunc() {
	clear
	echo -e "En: \e[34mHere you can delete your backup.\e[0m"
	echo -e "Ru: \e[34mЗдесь Вы можете удалить бэкап.\e[0m\n"
	echo -e "\e[32m| 1 - Move on to delete / Перейти к удалению\e[0m\n"
	echo -e "\e[34m| 2 - Back / Назад\n\e[0m\n"
	read -p "Enter value / Введите действие: " sub_action

	case $sub_action in
	1)
		clear
		echo -e "\e[34m################################## \e[32mBACKUPS\e[0m / \e[32mБЭКАПЫ\e[34m ##################################\e[0m"
		echo -e "\e[32m$(sudo timeshift --list)\e[0m"
		echo -e "\e[34m#####################################################################################\e[0m\n"
		read -p "Enter backup name (name! Not comment!) / Введите название бэкапа (из поля name, не комментарий!): " name
		sudo timeshift --delete --snapshot $name
	;;
	2)
		break
	;;
	*)
		clear
		echo -e "\n\e[31m(-_-)/ |Incorrect value / Неправильный ввод|\e[0m"
		break
	;;
	esac
}

changeSCFAAWPFunc() {
	clear
	EXPECTED_STRING="isEnableSCFAAWP"

	if [[ -f $CONF ]]; then
		echo -e "\n########################################################"
		echo "$CONF file found / Файл $CONF найден"

		if grep -q "^$EXPECTED_STRING=" "$CONF"; then
			echo "The $EXPECTED_STRING entry was found in the file / Запись $EXPECTED_STRING найдена в файле"
			SCFAAWP=$(sed -n "s/^$EXPECTED_STRING=\(.*\)/\1/p" "$CONF")
			
			if [ $SCFAAWP = "yes" ]; then
				sudo sed -i "s/^$EXPECTED_STRING=.*/$EXPECTED_STRING=no/" "$CONF"
				echo -e "\e[32mNow disabled / Сейчас отключено\e[0m"
			elif [ $SCFAAWP = "no" ]; then
				sudo sed -i "s/^$EXPECTED_STRING=.*/$EXPECTED_STRING=yes/" "$CONF"
				echo -e "\e[32mNow enabled / Сейчас включено\e[0m"
			fi

		else
			echo "Entry $EXPECTED_STRING not found in the file / Запись $EXPECTED_STRING не найдена в файле"
		fi
	else
		echo "$CONF file not found / Файл $CONF не найден"
	fi
	echo -e "########################################################\n"
}

deleteScriptFunc() {
	clear
	sudo mv /usr/share/applications/script.desktop "$(realpath "$SCRIPT_DIR/..")"
	sudo mv "$(realpath "$SCRIPT_DIR/../timeshift-gtk.desktop")" /usr/share/applications/
	TARGET_DIR=$(realpath "$SCRIPT_DIR/..")
	if [ -d "$TARGET_DIR" ]; then
		rm -rf "$TARGET_DIR"
		echo "The directory has been deleted / Директория удалена"
		exit
	else
		echo "error / Ошибка"
	fi
}
######################################

while true; do

echo -e "\e[32m"

cat << "EOF"
  _______ _    _ _____  ____   ____   _____ _    _ _____ ______ _______ 
 |__   __| |  | |  __ \|  _ \ / __ \ / ____| |  | |_   _|  ____|__   __|
    | |  | |  | | |__) | |_) | |  | | (___ | |__| | | | | |__     | |   
    | |  | |  | |  _  /|  _ <| |  | |\___ \|  __  | | | |  __|    | |   
    | |  | |__| | | \ \| |_) | |__| |____) | |  | |_| |_| |       | |   
    |_|   \____/|_|  \_\____/ \____/|_____/|_|  |_|_____|_|       |_|   
EOF

echo -e "\e[0m"

	echo -e "\n\e[33mUser:\e[0m $(whoami) \e[34m|\e[0m \e[33mTimeshift:\e[0m $(timeshift --version) \e[34m|\e[0m \e[33mAuthor:\e[0m https://github.com/DaniilZinoviev06 \e[34m"

	echo -e "\e[32m\n| 1 - Backups / Бэкапы\n\e[0m"
	echo -e "\e[32m| 2 - Settings / Настройки\n\e[0m"
	echo -e "\e[32m| 3 - Run / Запустить timeshift\n\e[0m"
	echo -e "\e[34m| 4 - Exit / Выход\n\e[0m\n"
	read -p "Enter value / Введите действие: " action

	while true; do
		case $action in
		1)
			clear
			echo -e "\e[32m\n| 1 - Create backup / Создать бэкап\n\e[0m"
			echo -e "\e[32m| 2 - View backups / Посмотреть бэкапы\n\e[0m"
			echo -e "\e[32m| 3 - Restore system / Восстановить систему\n\e[0m"
			echo -e "\e[32m| 4 - Set up auto backups / Настроить автобэкапы\n\e[0m"
			echo -e "\e[32m| 5 - Delete backup / Удалить бэкап\n\e[0m"
			echo -e "\e[34m| 6 - Back / Назад\n\e[0m\n"
			read -p "Enter value / Введите действие: " sub_action

				case $sub_action in
				1)
					createBackupFunc
				;;

				2)
					clear
					echo -e "\e[34m################################## \e[32mBACKUPS\e[0m / \e[32mБЭКАПЫ\e[34m ##################################\e[0m"
					sudo timeshift --list
					echo -e "\e[34m#####################################################################################\e[0m"
					break
				;;

				3)
					restoreBackupFunc
				;;

				4)
					autoBackupFunc
				;;
				5)
					deleteBackupFunc
				;;

				6)
					clear
					break
				;;
			esac
		;;
		2)
			clear
			echo -e "\n\e[32m| 1 - Enable/Disable snapshots for every action with the package / Включить/Выключить снимки для каждого действия с пакетом\n\e[0m"
			echo -e "\e[32m| 2 - Delete script / Удалить скрипт\n\e[0m"
			echo -e "\e[34m| 3 - Back / Назад\n\e[0m\n"
			read -p "Enter value / Введите действие: " settings_action
			case $settings_action in
			1)
				changeSCFAAWPFunc
				break
			;;
			2)
				deleteScriptFunc
			;;
			3)
				clear
				break
			;;
			*)
				clear
				echo -e "\n\e[31m(-_-)/ |Incorrect value / Неправильный ввод|\e[0m"
				break
			;;
			esac
		;;
		3)
			clear
			sudo timeshift-gtk
			break
		;;
		4)
			exit
		;;
		*)
			clear
			echo -e "\n\e[31m(-_-)/ |Incorrect value / Неправильный ввод|\e[0m"
			break
		;;
		esac
	done
done
