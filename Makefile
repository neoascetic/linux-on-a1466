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

install:
	sudo rm -rf /lib/modules/${VERSION}-${SUFFIX}
	cd ${SRC} && sudo make -j${NPROC} modules_install
	sudo dkms autoinstall -k ${VERSION}-${SUFFIX}
	sudo cp ${SRC}/arch/x86/boot/bzImage /boot/vmlinuz-${VERSION}-${SUFFIX}-amd64
	sudo update-grub

build: put-config
	cd ${SRC} && make -j${NPROC} && make -j${NPROC} modules
