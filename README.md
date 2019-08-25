# arch-firecracker
Docker container to build a linux kernel and ext4 rootfs compatible with [firecracker](https://github.com/firecracker-microvm/firecracker).

Based on the wonderful work done by [bkleiner](https://github.com/bkleiner/ubuntu-firecracker), with significant changes in order to make it build Arch Linux's kernel.

## Usage
Build the container:
```shell
docker build -t arch-firecracker .
```

Build the image:
```shell
docker run --privileged -it --rm -v $(pwd)/output:/output arch-firecracker
```
