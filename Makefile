clean:
	rm -rfv ./dqib_riscv64-virt/ riscv64-virt.zip

setup: clean
	sudo apt-get install opensbi u-boot-qemu qemu-system-riscv64 -y

build: setup
	wget -c 'https://gitlab.com/api/v4/projects/giomasce%2Fdqib/jobs/artifacts/master/download?job=convert_riscv64-virt' -O riscv64-virt.zip
	unzip riscv64-virt.zip
	cd dqib_riscv64-virt/
	qemu-system-riscv64  \
		-machine 'virt' \
		-smp 1 \
		-cpu 'rv64' \
		-m 1G \
		-device virtio-blk-device,drive=hd \
		-drive file=./dqib_riscv64-virt/image.qcow2,if=none,id=hd \
		-device virtio-net-device,netdev=net \
		-netdev user,id=net,hostfwd=tcp::2222-:22 \
		-bios /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf \
		-kernel /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf \
		-object rng-random,filename=/dev/urandom,id=rng \
		-device virtio-rng-device,rng=rng -nographic \
		-append "root=LABEL=rootfs console=ttyS0"
