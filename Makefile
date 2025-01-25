all: build install

VERSION:=6.6.74
SUFFIX:=a1466
SRC:=linux-${VERSION}

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
	cd ${SRC} && make nconfig
	$(MAKE) get-config

install:
	cd ${SRC} && sudo make modules_install
	sudo dkms autoinstall -k ${VERSION}-${SUFFIX}
	sudo cp ${SRC}/arch/x86/boot/bzImage /boot/vmlinuz-${VERSION}-${SUFFIX}-amd64
	sudo update-grub

build: put-config
	cd ${SRC} && make -j4 && make -j4 modules
