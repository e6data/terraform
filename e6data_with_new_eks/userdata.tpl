# Install NVMe CLI
yum install nvme-cli -y

# Check if NVMe drives are present
if nvme list | grep -q "Amazon EC2 NVMe Instance Storage" 
then
    # NVMe drives are detected
    nvme_drives=$(nvme list | grep "Amazon EC2 NVMe Instance Storage" | cut -d " " -f 1 || true)
    readarray -t nvme_drives <<< "$nvme_drives"
    num_drives=$(echo "${#nvme_drives[*]}")
    if [ "$num_drives" -gt 1 ]
    then
        # Multiple NVMe drives detected, skip RAID creation
        echo "Multiple NVMe drives detected. Skipping RAID creation."
    else
        # Single NVMe drive detected, format and mount it
        for disk in "${nvme_drives[*]}"
        do
            mkfs.ext4 -F "$disk"
            uuid=$(blkid -o value -s UUID "$disk")
            mount_location="/mnt/fast-disks/${uuid}"
            mkdir -p "$mount_location"
            mount "$disk" "$mount_location"
            echo "$disk $mount_location ext4 defaults,noatime 0 2" >> /etc/fstab 
        done
    fi
else
    # NVMe drives are not detected, exit gracefully
    echo "No NVMe drives detected. Skipping NVMe-specific commands."
fi
