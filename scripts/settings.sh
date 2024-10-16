#! /bin/bash
###
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
CONF="$(realpath "$SCRIPT_DIR/../conf.conf")"
PACKAGES_ARCH_SETTING=$(sed -n 's/^PackagesArch=//p' $CONF | tr -d '"' )
###

####### SETTINGS FUNCTIONS ##########
SCFAAWPFunc() {
HOOK_FILE="/etc/pacman.d/hooks/turboshift-$1.hook"
sudo bash -c "cat > $HOOK_FILE" << EOF
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Package
Target = *

[Action]
Description = "Creating snapshot before $1 transaction..."
When = PreTransaction
Exec = /bin/sh -c 'command -v timeshift >/dev/null 2>&1 && timeshift --create --comments "Automatic snapshot before $1 transaction"'
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
				for package in $PACKAGES_ARCH_SETTING; do 
					SCFAAWPFunc $package
				done
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

enableSCFAAWPFunc() {
	EXPECTED_ENTRY="isEnableSCFAAWP"

	if [[ -f  $CONF ]]; then
		echo "$CONF file found"
	  
		if grep -q "$EXPECTED_ENTRY" "$CONF"; then
			echo "The $EXPECTED_ENTRY entry was found in the file"
		else
			echo "The $EXPECTED_ENTRY entry was not found in the file"
			echo "isEnableSCFAAWP=no" >> $CONF 
			echo "$EXPECTED_ENTRY is now defined"
		fi
	else
		echo "$CONF file not found"
	fi	
}


isShortcut() {
	clear
	EXPECTED_STRING="isEnableShortcut"

	if [[ -f $CONF ]]; then
		echo -e "\n########################################################"
		echo "$CONF file found"

		if grep -q "^$EXPECTED_STRING=" "$CONF"; then
			echo "The $EXPECTED_STRING entry was found in the file"
			Shortcut=$(sed -n "s/^$EXPECTED_STRING=\(.*\)/\1/p" "$CONF")
			
			if [ $Shortcut = "yes" ]; then
				sudo sed -i "s/^$EXPECTED_STRING=.*/$EXPECTED_STRING=no/" "$CONF"
				deleteShortcut
				echo -e "\e[32mNow disabled\e[0m"
			elif [ $Shortcut = "no" ]; then
				sudo sed -i "s/^$EXPECTED_STRING=.*/$EXPECTED_STRING=yes/" "$CONF"
				createShortcut
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
	sudo rm /usr/share/applications/turboshift.desktop
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

CheckConfDistroFunc() {
	EXPECTED_ENTRY="user_distro"

	if [[ -f  $CONF ]]; then
		echo "$CONF file found"
	  
		if grep -q "$EXPECTED_ENTRY" "$CONF"; then
			echo "The $EXPECTED_ENTRY entry was found in the file"
			DISTRO=$user_distro
			if [ -z "$DISTRO" ]; then
				DISTRO=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"' | sed 's/ Linux//')
				sed -i "/^user_distro=/s/=.*/=$DISTRO/" "$CONF"
				echo "$EXPECTED_ENTRY is defined"
			fi
		else
			echo "The $EXPECTED_ENTRY entry was not found in the file"
			DISTRO=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"' | sed 's/ Linux//')
			echo "user_distro=\"$DISTRO\"" >> $CONF 
			echo "$EXPECTED_ENTRY is now defined"
		fi
	else
		echo "$CONF file not found"
	fi	
}

deleteShortcut() {
	LOGO_FILE="/usr/share/applications/turboshift.desktop"
    
	sudo rm $LOGO_FILE
	sudo mv "$(realpath "$SCRIPT_DIR/../timeshift-gtk.desktop")" /usr/share/applications
}

createShortcut() {
	LOGO_FILE="/usr/share/applications/turboshift.desktop"

	SCRIPT_PATH="$(realpath script.sh)"
	ICON_PATH="$(realpath "$SCRIPT_DIR/../logo.jpg")"

	sudo bash -c "cat > $LOGO_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Turboshift
Comment=Console interface Timeshift
Exec=$SCRIPT_PATH
Icon=$ICON_PATH
Terminal=true
EOF
	
	TIMESHIFT_SHORTCUT="/usr/share/applications/timeshift-gtk.desktop"
	if [[ -f $TIMESHIFT_SHORTCUT ]]; then
		sudo mv /usr/share/applications/timeshift-gtk.desktop "$(realpath "$SCRIPT_DIR/..")"
	else
		echo -e "Timeshift shortcut not found or moved..."
	fi
}

#############################################
