#! /bin/bash

###
PACKAGES="timeshift cronie grub-btrfs vi"
USER=$(whoami)
###
#echo "Текущий пользователь: $USER"

echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER

install_libraries_fedora() {
	if ! dnf list installed $1 &> /dev/null; then
		sudo dnf install -y $1
	else
		echo "Library $1 is already installed."
	fi
}

install_libraries_arch() {
	if ! pacman -Q $1 &> /dev/null; then
		sudo pacman -S $1 --noconfirm
	else
		echo "Library $1 is already installed."
	fi
}

packagesMainFunc() {
	EXPECTED_STRING="user_distro"
	
	if [[ -f $CONF ]]; then
		echo "$CONF file found"

		if grep -q "^$EXPECTED_STRING=" "$CONF"; then
			echo "The $EXPECTED_STRING entry was found in the file"
			USER_DISTRO=$(sed -n "s/^$EXPECTED_STRING=\(.*\)/\1/p" "$CONF")
			
			for package in $PACKAGES; do
				if ! ldconfig -p | grep -q $package; then
					if [ $USER_DISTRO = "Arch" ]; then
						install_libraries_arch $package
					elif [ $USER_DISTRO = "Fedora" ]; then
						install_libraries_fedora $package
					fi
				else
					echo "Library $package is already installed."
				fi
			done
			
			if [ $USER_DISTRO = "Fedora" ]; then
				if ! dnf list installed $1 &> /dev/null; then
					sudo dnf install -y dnf-plugins-core
				else
					echo "Library $1 is already installed."
				fi
			fi
			
		else
			echo "Entry $EXPECTED_STRING not found in the file"
		fi
	else
		echo "$CONF file not found"
	fi
}

sudo rm /etc/sudoers.d/$USER
