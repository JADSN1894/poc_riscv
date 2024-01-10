# Debian risc-v image

## Manual devcontainer setup

***Run:*** `./.devcontainer/install_tooling.sh `

## Qemu (Manually changing the number of cores and memory)

```sh

qemu-system-riscv64  \
		-machine 'virt' \
		-smp $(echo "$(nproc)-1" | bc) \
		-cpu 'rv64' \
		-m $(echo "$(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 / 1024 / 2" | bc)G \
		-device virtio-blk-device,drive=hd \
		-drive file=./dqib_riscv64-virt/image.qcow2,if=none,id=hd \
		-device virtio-net-device,netdev=net \
		-netdev user,id=net,hostfwd=tcp::2222-:22 \
		-bios /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf \
		-kernel /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf \
		-object rng-random,filename=/dev/urandom,id=rng \
		-device virtio-rng-device,rng=rng -nographic \
		-append "root=LABEL=rootfs console=ttyS0"

```

## Inside qemu

1. debian login: `root`
1. Password: `root`
1. `apt update`
1. `apt list --upgradable`
1. `apt upgrade -y`
1. `apt install build-essential -y`
1. `apt install cargo -y`
1. `apt install rustup -y`
1. `apt install software-properties-common git vim -y`
1. `rustup update stable`

## Links

[**DQIB, the Debian Quick Image Baker**](https://www.giovannimascellani.eu/dqib-debian-quick-image-baker.html)

[**Setting up a riscv64 virtual machine**](https://wiki.debian.org/RISC-V)

[**Getting started with RISC-V in QEMU**](https://colatkinson.site/linux/riscv/2021/01/27/riscv-qemu/)