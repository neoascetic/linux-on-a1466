all: build install

VERSION:=6.6.74
SUFFIX:=a1466
SRC:=linux-${VERSION}
NPROC:=$(shell nproc)

${SRC}:
	wget -c https://cdn.kernel.org/pub/linux/kernel/v6.x/${SRC}.tar.xz
	tar xf ${SRC}.tar.xz
	rm ${SRC}.tar.xz

get-source: ${SRC}

put-config:
	cp kernel.config ${SRC}/.config

get-config:
	cp ${SRC}/.config kernel.config

config:
	$(MAKE) put-config
	cd ${SRC} && make -j${NPROC} nconfig
	$(MAKE) get-config

install: install-modules install-grub install-efi

install-modules:
	sudo dkms unbuild -k 6.6.74-a1466 -m facetimehd/0.1 --force
	sudo dkms unbuild -k 6.6.74-a1466 -m broadcom-sta/6.30.223.271 --force
	sudo rm -rf /lib/modules/${VERSION}-${SUFFIX}
	cd ${SRC} && sudo make -j${NPROC} modules_install
	sudo dkms autoinstall -k ${VERSION}-${SUFFIX}

install-grub:
	sudo cp ${SRC}/arch/x86/boot/bzImage /boot/vmlinuz-${VERSION}-${SUFFIX}-amd64
	sudo update-grub

install-efi:
	sudo mount /boot/efi
	sudo cp ${SRC}/arch/x86/boot/bzImage /boot/efi/EFI/Linux/vmlinuz
	sudo umount /boot/efi

build: put-config
	cd ${SRC} && make -j${NPROC} && make -j${NPROC} modules
