#! /bin/bash

###
PACKAGES="timeshift cronie grub-btrfs vi mailutils mailx"
USER=$(whoami)
###
#echo "Текущий пользователь: $USER"

echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER

install_libraries_arch() {
	if ! pacman -Q $1 &> /dev/null; then
		echo "Устанавливаем timeshift $1..."
		sudo pacman -S $1 --noconfirm
	else
		echo "Библиотека $1 уже установлена."
	fi
}

for package in $PACKAGES; do
	if ! ldconfig -p | grep -q $package; then
		install_libraries_arch $package
	else
		echo "библиотека $package установлена."
	fi
done

sudo rm /etc/sudoers.d/$USER
