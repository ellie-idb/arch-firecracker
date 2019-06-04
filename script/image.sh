#! /bin/bash
set -ex

rm -rf /output/*

sudo cp /home/build/linux/trunk/pkg/linux-firecracker/boot/vmlinuz-linux-firecracker /output/vmlinuz
sudo cp /home/build/linux/trunk/config /output/config

sudo truncate -s 3G /output/image.ext4
sudo mkfs.ext4 /output/image.ext4

sudo mount /output/image.ext4 /rootfs
sudo pacstrap /rootfs base base-devel 
sudo mount --bind / /rootfs/mnt

sudo chroot /rootfs /bin/bash /mnt/script/provision.sh

sudo umount /rootfs/mnt
sudo umount /rootfs

cd /output
# tar czvf image.ext4 vmlinux config
cd /
