#! /bin/bash

###
PACKAGES="timeshift cronie grub-btrfs vi"
USER=$(whoami)
###
#echo "Текущий пользователь: $USER"

echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER

install_libraries_arch() {
	if ! pacman -Q $1 &> /dev/null; then
		sudo pacman -S $1 --noconfirm
	else
		echo "Library $1 is already installed."
	fi
}

for package in $PACKAGES; do
	if ! ldconfig -p | grep -q $package; then
		install_libraries_arch $package
	else
		echo "Library $package is already installed."
	fi
done

sudo rm /etc/sudoers.d/$USER
