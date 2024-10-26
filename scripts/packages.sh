#! /bin/bash

###
PACKAGES="timeshift cronie grub-btrfs vi"
###
#echo "Текущий пользователь: $USER"

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
