#! /bin/bash

###
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
CONF="$(realpath "$SCRIPT_DIR/../setgs.conf")"
###
echo -e "\e[36m####################################################################################\e[0m"

cat << "EOF"
▗▄▄▖  ▗▄▖  ▗▄▄▖▗▖ ▗▖ ▗▄▖  ▗▄▄▖▗▄▄▄▖ ▗▄▄▖
▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌▗▞▘▐▌ ▐▌▐▌   ▐▌   ▐▌
▐▛▀▘ ▐▛▀▜▌▐▌   ▐▛▚▖ ▐▛▀▜▌▐▌▝▜▌▐▛▀▀▘ ▝▀▚▖
▐▌   ▐▌ ▐▌▝▚▄▄▖▐▌ ▐▌▐▌ ▐▌▝▚▄▞▘▐▙▄▄▖▗▄▄▞▘
EOF

echo "Install the required packages..."
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
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo -e "\e[36m####################################################################################\e[0m"
###

############## MAIN FUNCTIONS ##############
createBackupFunc() {
	clear
	echo -e "descr: \e[34mHere you can create a snapshot that will be automatically added to grub.\e[0m"
	echo -e "\e[32m| 1 - Move on to create\e[0m\n"
	echo -e "\e[34m| 2 - Back\n\e[0m\n"
	read -p "Enter value: " sub_action

	case $sub_action in
	1)
		echo -e "\n"
		read -p "Enter comment: " comment
		sudo timeshift --create --comments "$comment"
		sudo grub-mkconfig -o /boot/grub/grub.cfg
		break
	;;
	2)
		break
	;;
	*)
		echo -e "\e[31mInvalid value\e[0m"
	;;
	esac
}

restoreBackupFunc() {
	clear
	echo -e "descr: \e[34mHere you can restore your system.\e[0m"
	echo -e "\e[32m| 1 - Move on to restore\e[0m\n"
	echo -e "\e[34m| 2 - Back\n\e[0m\n"
	read -p "Enter value: " sub_action

	case $sub_action in
	1)
		echo -e "\n"
		echo -e "\e[32m$(sudo timeshift --list)\e[0m"
		read -p "Enter backup name: " name
		sudo timeshift --restore --snapshot $name
		break
	;;
	2)
		break
	;;
	*)
		clear
		echo -e "\n\e[31m(-_-)/ |Incorrect value|\e[0m"
		break
	;;
	esac
}

timeshiftAutoBackupsFunc() {
	clear
	echo -e "\e[32m| 1 - Create snapshot (hourly)\e[0m\n"
	echo -e "\e[32m| 2 - Create snapshot (daily)\e[0m\n"
	echo -e "\e[32m| 3 - Create snapshot (weekly)\e[0m\n"
	echo -e "\e[32m| 4 - Create snapshot (monthly)\e[0m\n"
	echo -e "\e[32m| 5 - Create snapshot (boot)\e[0m\n"
	echo -e "\e[34m| 6 - Back\n\e[0m\n"
	read -p "Enter value: " sub_action
	case $sub_action in
		1)
			clear
			sudo timeshift --create --tags H
			sudo grub-mkconfig -o /boot/grub/grub.cfg
			break
		;;
		2)
			clear
			sudo timeshift --create --tags D
			sudo grub-mkconfig -o /boot/grub/grub.cfg
			break
		;;
		3)
			clear
			sudo timeshift --create --tags W
			sudo grub-mkconfig -o /boot/grub/grub.cfg
			break
		;;
		4)
			clear
			sudo timeshift --create --tags M
			sudo grub-mkconfig -o /boot/grub/grub.cfg
			break
		;;
		5)
			clear
			sudo timeshift --create --tags B
			sudo grub-mkconfig -o /boot/grub/grub.cfg
			break
		;;
		6)
			clear
			break
		;;
		*)
			clear
			echo -e "\n\e[31m(-_-)/ |Incorrect value|\e[0m"
			break
		;;
	esac
}

autoBackupFunc() {
	clear
	echo -e "descr: \e[34mHere you can create autobackups.\e[0m"
	echo -e "\e[32m| 1 - Create snapshot (Timeshift original)\e[0m\n"
	echo -e "\e[32m| 2 - Create snaphot (More customizable schedule)\e[0m\n"
	echo -e "\e[32m| 3 - Clear autosnapshots (2 point)\e[0m\n"
	echo -e "\e[34m| 4 - Back\n\e[0m\n"
	read -p "Enter value: " sub_action
	case $sub_action in
		1)
			clear
			timeshiftAutoBackupsFunc
		;;
		2)
			clear
			read -p "Comment: " comment
			echo -e "1 - January\n2 - February\n3 - March\n4 - April\n5 - May\n6 - June\n7 - July\n8 - August\n9 - September\n10 - October\n11 - November\n12 - December\n"
			read -p "Month" month
			0 - Sunday 1 - Monday 3 - Tuesday 4 - Wednesday 5 - Thursday 6 - Friday 7 - Saturday
			echo -e "0 - Sunday\n1 - Monday\n3 - Tuesday\n4 - Wednesday\n5 - Thursday\n6 - Friday\n7 - Saturday\n"
			read -p "Day of the week: " day
			read -p "Enter time(e.g, 12:45): " time

			IFS=':' read -r hour minute <<< "$time"

			if [[ ! $hour =~ ^[0-9]+$ ]] || [[ ! $minute =~ ^[0-9]+$ ]] || [[ "$hour" -lt 0 ]] || [[ "$hour" -gt 23 ]] || [[ "$minute" -lt 0 ]] || [[ "$minute" -gt 59 ]]; then
			    echo "Incorrect time"
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
			echo -e "\n\e[34m### \e[32mCOMMANDS IN CRON(Script delete this commands)\e[34m ###\e[0m\n"
			echo -e "\e[31m$(sudo crontab -l)\e[0m"
			echo -e "\e[34m#################################################################################################\e[0m\n"
			echo -e "\e[31m//////////////////////////////////////////////////////////////////\n"
			sudo crontab -r
			echo -e "\n//////////////////////////////////////////////////////////////////\e[0m"
			echo -e "\n\e[34m### \e[32mCOMMANDS IN CRON(Now)\e[34m###\e[0m\n"
			echo -e "\e[31m$(sudo crontab -l)\e[0m"
			echo -e "\e[34m###############################################################\e[0m\n"
			sleep 10
			break
		;;
	       *)
			clear
			echo -e "\n\e[31m(-_-)/ |Incorrect value|\e[0m"
			break
	       	;;
	esac
}

deleteBackupFunc() {
	clear
	echo -e "descr: \e[34mHere you can delete your backup.\e[0m"
	echo -e "\e[32m| 1 - Move on to delete\e[0m\n"
	echo -e "\e[34m| 2 - Back\n\e[0m\n"
	read -p "Enter value: " sub_action

	case $sub_action in
	1)
		clear
		echo -e "\e[34m################################## \e[32mBACKUPS\e[34m ##################################\e[0m"
		echo -e "\e[32m$(sudo timeshift --list)\e[0m"
		echo -e "\e[34m#####################################################################################\e[0m\n"
		read -p "Enter backup name (name! Not comment!): " name
		sudo timeshift --delete --snapshot $name
	;;
	2)
		break
	;;
	*)
		clear
		echo -e "\n\e[31m(-_-)/ |Incorrect value|\e[0m"
		break
	;;
	esac
}

SCFAAWPFunc() {
HOOK_FILE="/etc/pacman.d/hooks/turboshift-$1.hook"
sudo bash -c "cat > $HOOK_FILE" << 'EOF'
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Package
Target = *

[Action]
Description = Creating snapshot before pacman transaction...
When = PreTransaction
Exec = /bin/sh -c "command -v timeshift >/dev/null 2>&1 && timeshift --create --comments "Automatic snapshot before pacman transaction""
EOF
}

changeSCFAAWPFunc() {
	clear
	EXPECTED_STRING="isEnableSCFAAWP"

	if [[ -f $CONF ]]; then
		echo -e "\n########################################################"
		echo "$CONF file found"

		if grep -q "^$EXPECTED_STRING=" "$CONF"; then
			echo "The $EXPECTED_STRING entry was found in the file"
			SCFAAWP=$(sed -n "s/^$EXPECTED_STRING=\(.*\)/\1/p" "$CONF")
			
			if [ $SCFAAWP = "yes" ]; then
				sudo sed -i "s/^$EXPECTED_STRING=.*/$EXPECTED_STRING=no/" "$CONF"
				sudo rm -rf /etc/pacman.d/hooks
				echo -e "\e[32mNow disabled\e[0m"
			elif [ $SCFAAWP = "no" ]; then
				sudo sed -i "s/^$EXPECTED_STRING=.*/$EXPECTED_STRING=yes/" "$CONF"
				sudo mkdir /etc/pacman.d/hooks
				SCFAAWPFunc pacman
				echo -e "\e[32mNow enabled\e[0m"
			fi

		else
			echo "Entry $EXPECTED_STRING not found in the file"
		fi
	else
		echo "$CONF file not found"
	fi
	echo -e "########################################################\n"
}

deleteScriptFunc() {
	clear
	sudo mv /usr/share/applications/script.desktop "$(realpath "$SCRIPT_DIR/..")"
	sudo mv "$(realpath "$SCRIPT_DIR/../timeshift-gtk.desktop")" /usr/share/applications/
	TARGET_DIR=$(realpath "$SCRIPT_DIR/..")
	if [ -d "$TARGET_DIR" ]; then
		sudo rm -rf /etc/pacman.d/hooks
		rm -rf "$TARGET_DIR"
		echo "The directory has been deleted"
		exit
	else
		echo "error"
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

	echo -e "\e[32m\n| 1 - Snapshots\n\e[0m"
	echo -e "\e[32m| 2 - Settings\n\e[0m"
	echo -e "\e[32m| 3 - Run Timeshift\n\e[0m"
	echo -e "\e[34m| 4 - Exit\n\e[0m\n"
	read -p "Enter value: " action

	while true; do
		case $action in
		1)
			clear
			echo -e "\e[32m\n| 1 - Create snapshot\n\e[0m"
			echo -e "\e[32m| 2 - View snapshots\n\e[0m"
			echo -e "\e[32m| 3 - Restore system\n\e[0m"
			echo -e "\e[32m| 4 - Set up auto snapshots\n\e[0m"
			echo -e "\e[32m| 5 - Delete backup\n\e[0m"
			echo -e "\e[34m| 6 - Back\n\e[0m\n"
			read -p "Enter value: " sub_action

				case $sub_action in
				1)
					createBackupFunc
				;;

				2)
					clear
					echo -e "\e[34m################################## \e[32mBACKUPS\e[34m ##################################\e[0m"
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
			echo -e "\n\e[32m| 1 - Enable/Disable snapshots for every action with the package\n\e[0m"
			echo -e "\e[32m| 2 - Delete script\n\e[0m"
			echo -e "\e[34m| 3 - Back\n\e[0m\n"
			read -p "Enter value" settings_action
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
				echo -e "\n\e[31m(-_-)/ |Incorrect value|\e[0m"
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
			echo -e "\n\e[31m(-_-)/ |Incorrect value|\e[0m"
			break
		;;
		esac
	done
done
