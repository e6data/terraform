#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

devices=()
for ssd in /dev/disk/by-id/google-local-ssd-block*; do
  if [ -e "${ssd}" ]; then
    devices+=("${ssd}")
  fi
done
if [ "${#devices[@]}" -eq 0 ]; then
  echo "No Local NVMe SSD disks found."
  exit 0
fi

seen_arrays=(/dev/md/*)
device=${seen_arrays[0]}
echo "Setting RAID array with Local SSDs on device ${device}"
if [ ! -e "$device" ]; then
  device="/dev/md/0"
  echo "y" | mdadm --create "${device}" --level=0 --force --raid-devices=${#devices[@]} "${devices[@]}"
fi

if ! tune2fs -l "${device}" ; then
  echo "Formatting '${device}'"
  mkfs.ext4 -F "${device}"
fi

mountpoint=/tmp
mkdir -p "${mountpoint}"
echo "Mounting '${device}' at '${mountpoint}'"
mount -o discard,defaults "${device}" "${mountpoint}"
chmod a+w "${mountpoint}"
