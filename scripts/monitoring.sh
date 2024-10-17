#!/bin/bash

tableFunc() {
	COL_WIDTH=50
	COL_WIDTH_PACKAGE=48
	SEPARATOR=$(printf '%*s' "$COL_WIDTH" | tr ' ' '-')
	TOTAL_WIDTH=$((COL_WIDTH))
	  printf '+%s+%s+\n' "$SEPARATOR" "$SEPARATOR"
	  printf "| %-${COL_WIDTH}s %-${COL_WIDTH_PACKAGE}s |\n" "$1" "$2"
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
		sudo chroot "$SNAP/@/" pacman -Qq > "$WORK_DIR/packages_${SNAP_NAME}.txt"

		PACKAGE_COUNT=$(wc -l < "$WORK_DIR/packages_${SNAP_NAME}.txt")
		tableFunc $SNAP_NAME $PACKAGE_COUNT
	done
	printf '+%s+%s+\n' "$SEPARATOR" "$SEPARATOR"

	sudo umount /run/turboshift
}
