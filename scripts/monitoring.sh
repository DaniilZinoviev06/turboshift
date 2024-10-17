#!/bin/bash

monitoringFunc() {
	PARTITION="/dev/nvme0n1p2"
	MOUNT_DIR="/run/turboshift"

	sudo mkdir -p "$MOUNT_DIR"
	sudo mount -o subvol=/ "$PARTITION" "$MOUNT_DIR"
	  
	SNAPSHOT_DIR="/run/turboshift/timeshift-btrfs/snapshots"

	WORK_DIR="/tmp/timeshift_compare"

	mkdir -p "$WORK_DIR"
	SNAPSHOTS=("$SNAPSHOT_DIR"/*)

	for SNAP in "${SNAPSHOTS[@]}"; do
		SNAP_NAME=$(basename "$SNAP")
		echo $SNAP_NAME
		sudo chroot "$SNAP/@/" pacman -Qq > "$WORK_DIR/packages_${SNAP_NAME}.txt"
	done

	sudo umount /run/turboshift
}
