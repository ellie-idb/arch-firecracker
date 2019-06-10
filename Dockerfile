FROM archlinux/base

ENV KERNEL_SOURCE_VERSION 5.1.5

RUN pacman -Sy && pacman --noconfirm -S asp base-devel pacman-contrib

RUN useradd --shell=/bin/false build && usermod -L build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER build
WORKDIR /home/build
CMD /bin/bash -l 
RUN sudo chown -R build:build /home/build
RUN sudo chmod -R 777 /home/build
WORKDIR /home/build/
RUN asp update linux && asp checkout linux
ADD config/kernel-config /home/build/linux/trunk/config

WORKDIR /home/build/linux/trunk
RUN ls
RUN sed -i '/#pkgbase=linux-custom/c\' PKGBUILD
RUN sed -i '/pkgbase=linux/c\pkgbase=linux-firecracker' PKGBUILD
RUN updpkgsums
RUN MAKEFLAGS="-j$(nproc)" makepkg --noconfirm --skippgpcheck -s 
RUN sudo pacman -S --noconfirm arch-install-scripts
WORKDIR /

VOLUME [ "/output", "/rootfs" ]

RUN sudo mkdir /script
RUN sudo chmod -R 777 /script

WORKDIR /script

RUN echo " downloading latest scripts from github "
RUN sudo curl -O https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux
RUN sudo curl -O https://raw.githubusercontent.com/hatf0/arch-firecracker/master/script/image.sh
RUN sudo curl -O https://raw.githubusercontent.com/hatf0/arch-firecracker/master/script/provision.sh

CMD [ "/bin/bash", "/script/image.sh" ]
