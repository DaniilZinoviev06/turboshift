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

}

monitoringFunc() {
	
}
