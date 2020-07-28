#! /bin/bash
set -ex

pacman --noconfirm -U /mnt/home/build/linux/trunk/linux*.pkg.tar.zst

# add custom packages here if you want them, dmd is included
# since it's an integral part of *my* infrastructure

pacman --noconfirm -S dmd

echo 'arch-firecracker' > /etc/hostname
passwd -d root
mkdir /etc/systemd/system/serial-getty@ttyS0.service.d/
sed -i 's/#IgnorePkg\W*=/IgnorePkg = linux/' /etc/pacman.conf
cat <<EOF > /etc/systemd/system/serial-getty@ttyS0.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root -o '-p -- \\u' --keep-baud 115200,38400,9600 %I $TERM
EOF

exit
