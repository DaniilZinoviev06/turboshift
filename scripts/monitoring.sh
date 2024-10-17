#!/bin/bash

monitoringFunc() {
	SNAP_DIR="/run/timeshift"
	SNAPSHOT_DIR=$(find "$SNAP_DIR" -type d -regex '.*/[0-9]+$' -print | awk '{print $0 "/backup/timeshift-btrfs/snapshots"}' | head -n 1)

	WORK_DIR="/tmp/timeshift_compare"

	mkdir -p "$WORK_DIR"

	SNAPSHOTS=("$SNAPSHOT_DIR"/*)
	echo "$SNAPSHOT_DIR"
	
	for SNAP in "${SNAPSHOTS[@]}"; do
		SNAP_NAME=$(basename "$SNAP")
		echo $SNAP_NAME
		sudo chroot "$SNAP/@/" pacman -Qq > "$WORK_DIR/packages_${SNAP_NAME}.txt"
	done
}
