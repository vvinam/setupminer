#!/bin/bash
cd ~/

export OBJECT_MODE=64

if grep -q avx2 /proc/cpuinfo; then

	rm -rf cpuminer-opt/
	rm cpuminer

	git clone https://github.com/JayDDee/cpuminer-opt

	cd cpuminer-opt/

	./autogen.sh
	CFLAGS="-Ofast -march=native -mtune=native -DUSE_ASM" CXXFLAGS="$CFLAGS -std=gnu++11" ./configure --with-curl --with-crypto
	make
	strip -s cpuminer
	mv cpuminer ~/cpuminer

	cd ~/

	chmod +x cpuminer

else

	rm -rf cpuminer-xzc/
	rm cpuminer

	git clone https://github.com/zcoinofficial/cpuminer-xzc

	cd cpuminer-xzc/

	./autogen.sh
	CFLAGS="-Ofast -march=native -mtune=native -DROW_PREFETCH -flto -fuse-linker-plugin -ftree-loop-if-convert-stores -DUSE_ASM" CXXFLAGS="$CFLAGS -std=gnu++11" ./configure --with-crypto --with-curl
	make
	strip -s cpuminer
	mv cpuminer ~/cpuminer

	cd ~/

	chmod +x cpuminer

fi
