#! /bin/bash
set -ex

pacman --noconfirm -U /mnt/home/build/linux/trunk/linux*.tar.xz

pacman --noconfirm -S dmd

echo 'arch-firecracker' > /etc/hostname
passwd -d root
mkdir /etc/systemd/system/serial-getty@ttyS0.service.d/
echo 'IgnorePkg = linux' >> /etc/pacman.conf
cat <<EOF > /etc/systemd/system/serial-getty@ttyS0.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root -o '-p -- \\u' --keep-baud 115200,38400,9600 %I $TERM
EOF

exit
