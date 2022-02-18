#!/bin/bash



mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
cp software/mongo-org-4.2.repo /etc/yum.repos.d/mongo-org-4.2.repo
cp software/CentOS7-Base-163.repo /etc/yum.repos.d/CentOS7-Base-163.repo
yum clean all && yum makecache

yum install -y epel-release 
# yum install -y centos-release-scl
yum clean all && yum makecache

yum install -y gcc-c++ lbzip2 
yum install -y make

cp -r software /root/software
mkdir -p /root/build_software

# cd  /root
tar -xJf /root/software/gcc-8.3.0.tar.xz -C /root/build_software
cp  /root/software/isl-0.18.tar.bz2 /root/software/mpfr-3.1.4.tar.bz2 /root/software/gmp-6.1.0.tar.bz2 /root/software/mpc-1.0.3.tar.gz   /root/build_software/gcc-8.3.0/
cd  /root/build_software/gcc-8.3.0

./contrib/download_prerequisites

mkdir -p build && cd build
cd  /root/build_software/gcc-8.3.0/build
../configure  --enable-bootstrap --enable-checking=release --enable-languages=c,c++ --disable-multilib && make -j12 
yum remove -y gcc
make install
rm -f /lib64/libstdc++.so.6
cp /usr/local/lib64/libstdc++.so.6.0.25 /lib64/libstdc++.so.6.0.25
ln -s /lib64/libstdc++.so.6.0.25 /lib64/libstdc++.so.6
rm -f /usr/bin/cc
ln -s /usr/local/bin/gcc /usr/bin/cc

yum install -y cmake3 && ln -s /usr/bin/cmake3 /usr/bin/cmake
yum install -y git libuuid-devel openssl-devel cyrus-sasl-devel libicu-devel 

tar -xzf /root/software/mongo-c-driver-1.16.2.tar.gz -C /root/build_software
cd /root/build_software/mongo-c-driver-1.16.2/build
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF .. && make  -j4 && make install

tar -xzf /root/software/mongo-cxx-driver-r3.5.0.tar.gz -C /root/build_software
cd /root/build_software/mongo-cxx-driver-r3.5.0/build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && make -j4 && make install

ln -s /usr/local/lib64/libmongocxx.so._noabi  /lib64/libmongocxx.so._noabi
ln -s /usr/local/lib64/libbsoncxx.so._noabi  /lib64/libbsoncxx.so._noabi
ln -s /usr/local/lib64/libbson-1.0.so.0  /lib64/libbson-1.0.so.0
ln -s /usr/local/lib64/libmongoc-1.0.so.0  /lib64/libmongoc-1.0.so.0

tar -xzf /root/software/redis-5.0.8.tar.gz -C /root/build_software
cd /root/build_software/redis-5.0.8
make  -j4 && make install

yum install -y redis-trib
yum install -y net-tools bind-utils mongodb-org etcd
yum install -y python3
pip3 install jinja2




