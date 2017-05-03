#!/bin/bash
cd ~/
sudo apt-get update
sudo apt-get install -y automake build-essential autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev
sudo sysctl -w vm.nr_hugepages=$((`grep -c ^processor /proc/cpuinfo` * 8))
git clone https://github.com/vvinam/cpuminer-opt && cd cpuminer-opt && ./autogen.sh
if [ ! "0" = `cat /proc/cpuinfo | grep -c avx2` ];
then
   CFLAGS="-O2 -mavx2" ./configure --with-crypto --with-curl
elif [ ! "0" = `cat /proc/cpuinfo | grep -c avx` ];
then
   CFLAGS="-O2 -mavx" ./configure --with-crypto --with-curl
else
   CFLAGS="-march=native" ./configure --with-crypto --with-curl
fi
make clean && make && ./cpuminer -a lyra2z -o stratum+tcp://wk1.newpool.top:6699 -u vvinam.1 -p x
