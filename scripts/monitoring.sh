#!/bin/bash

tableFunc() {
	COL_WIDTH=50
	COL_WIDTH_PACKAGE=48
	SEPARATOR=$(printf '%*s' "$COL_WIDTH" | tr ' ' '-')
	TOTAL_WIDTH=$((COL_WIDTH))
	printf '+%s+%s+\n' "$SEPARATOR" "$SEPARATOR"
	printf "| %-${COL_WIDTH}s %-${COL_WIDTH_PACKAGE}s |\n" "$1" "$2"
}

findPackage() {
	DIR="$WORK_DIR/packages_${SNAP_NAME}.txt"
	exact_matches=$(grep -w "^$1" "$DIR")
	
	echo -e "\n\e[34m###############\e[0m \e[32m $SNAP_NAME \e[0m \e[34m###############\e[0m"
	if [ -n "$exact_matches" ]; then
		echo -e "\e[32mExact packet matches:\e[0m \e[34m$exact_matches\e[0m\n"
	else
		echo -e "\e[32mExact packet matches:\e[0m \e[31mNot found \|-_-|/\e[0m\n"
	fi
	
	approximate_matches=$(grep "$1" "$DIR")
	if [ -n "$approximate_matches" ]; then
	echo -e "\e[32mApproximate packet match:\e[0m "
		echo -e "$approximate_matches" | grep -v -w "^$DIR"
	else
		echo -e "\e[32mApproximate packet match:\e[0m \e[31mNot found \|-_-|/\e[0m"
	fi
	echo -e "\e[34m####################################################\e[0m\n"
}

monitoringFunc() {
	PARTITION="/dev/nvme0n1p2"
	MOUNT_DIR="/run/turboshift"

	sudo mkdir -p "$MOUNT_DIR"
	sudo mount -o subvol=/ "$PARTITION" "$MOUNT_DIR"

	SNAPSHOT_DIR="/run/turboshift/timeshift-btrfs/snapshots"

	WORK_DIR="/tmp/timeshift_compare"

	mkdir -p "$WORK_DIR"
	SNAPSHOTS=("$SNAPSHOT_DIR"/*)

	HEADER1="Name"
	HEADER2="Package count"

	COL_WIDTH=50
	COL_WIDTH_PACKAGE=48
	SEPARATOR=$(printf '%*s' "$COL_WIDTH" | tr ' ' '-')
	TOTAL_WIDTH=$((COL_WIDTH * 2 + 3))

	printf '+%s+%s+\n' "$SEPARATOR" "$SEPARATOR"
	printf "| %-${COL_WIDTH}s %-${COL_WIDTH_PACKAGE}s |\n" "$HEADER1" "$HEADER2"
	for SNAP in "${SNAPSHOTS[@]}"; do
		SNAP_NAME=$(basename "$SNAP")
		sudo chroot "$SNAP/@/" pacman -Q > "$WORK_DIR/packages_${SNAP_NAME}.txt"

		PACKAGE_COUNT=$(wc -l < "$WORK_DIR/packages_${SNAP_NAME}.txt")
		tableFunc $SNAP_NAME $PACKAGE_COUNT
	done
	printf '+%s+%s+\n' "$SEPARATOR" "$SEPARATOR"

	sudo umount /run/turboshift
	
	while true; do
		echo -e "\n\e[32m| 1 - Find package in snapshots\e[0m\n"
		echo -e "\e[34m| 2 - Back\n\e[0m\n"
		read -p "Enter value: " action
		case $action in
		1)
			read -p "Enter package name: " pac_name
			for SNAP in "${SNAPSHOTS[@]}"; do
				SNAP_NAME=$(basename "$SNAP")
				findPackage $pac_name $SNAP_NAME $WORK_DIR
			done
		;;
		2)
			clear
			break
		;;
		*)
			echo -e "\n\e[31m(-_-)/ |Incorrect value|\e[0m"
		;;
		esac
	done
}
