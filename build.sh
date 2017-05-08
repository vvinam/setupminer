#!/bin/bash
cd ~/
apt-get install -y make curl unzip gedit automake autoconf dh-autoreconf build-essential pkg-config openssh-server screen libtool libcurl4-openssl-dev libncurses5-dev libudev-dev libjansson-dev libssl-dev libgmp-dev gcc g++ cpulimit htop virt-what

// sudo sysctl -w vm.nr_hugepages=$((`grep -c ^processor /proc/cpuinfo` * 8))

export OBJECT_MODE=64

if grep -q avx2 /proc/cpuinfo; then

	rm -rf cpuminer-opt/
	rm cpuminer

	git clone https://github.com/vvinam/cpuminer-opt

	cd cpuminer-opt/

	./autogen.sh
	CFLAGS="-Ofast -march=native -mtune=native -DUSE_ASM" CXXFLAGS="$CFLAGS -std=gnu++11" ./configure --with-curl --with-crypto
	make
	strip -s cpuminer
	cp cpuminer ~/cpuminer

	cd ~/

	chmod +x cpuminer

else

	rm -rf cpuminer-xzc/
	rm cpuminer

	git clone https://github.com/vvinam/cpuminer-xzc

	cd cpuminer-xzc/

	./autogen.sh
	CFLAGS="-Ofast -march=native -mtune=native -DROW_PREFETCH -flto -fuse-linker-plugin -ftree-loop-if-convert-stores -DUSE_ASM" CXXFLAGS="$CFLAGS -std=gnu++11" ./configure --with-crypto --with-curl
	make clean && make
	strip -s cpuminer
	cp cpuminer ~/cpuminer

	cd ~/

	chmod +x cpuminer

fi
