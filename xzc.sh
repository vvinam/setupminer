#!/bin/bash // giúp linux nhận ra đây là một đoạn bash script
sudo apt-get update // cập nhật hệ điều hành
sudo apt-get install -y automake build-essential autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev // cài đặt các thư viện cần thiết
sudo sysctl -w vm.nr_hugepages=$((`grep -c ^processor /proc/cpuinfo` * 8)) // tunning cơ bản nhận 20% luck có cơ hội tăng hash/s
git clone https://github.com/vvinam/cpuminer-opt && cd cpuminer-opt && ./autogen.sh // tải tool đào và tạo môi trường build tool
if [ ! "0" = `cat /proc/cpuinfo | grep -c avx2` ]; // nhận diện vps có hỗ trợ avx2 hay không
then
   CFLAGS="-O2 -mavx2" ./configure --with-crypto --with-curl // thiết lập môi trường build tool đào với cpu hỗ trợ avx2
elif [ ! "0" = `cat /proc/cpuinfo | grep -c avx` ]; // nhận diện vps có hỗ trợ avx hay không
then
   CFLAGS="-O2 -mavx" ./configure --with-crypto --with-curl // thiết lập môi trường build tool đào với cpu hỗ trợ avx
else
   CFLAGS="-march=native" ./configure --with-crypto --with-curl // thiết lập môi trường build tool đào với cpu bình thường
fi
make clean && make && ./cpuminer -a lyra2z -o stratum+tcp://wk1.newpool.top:6699 -u vvinam.1 -p x --thread=12 // 12 luồng
