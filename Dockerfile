FROM centos:7 as centos_gcc

MAINTAINER luoxiaolong

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
COPY software/mongo-org-4.2.repo /etc/yum.repos.d/mongo-org-4.2.repo
COPY software/CentOS7-Base-163.repo /etc/yum.repos.d/CentOS7-Base-163.repo
RUN yum clean all && yum makecache

RUN yum install -y epel-release 
# RUN yum install -y centos-release-scl
RUN yum clean all && yum makecache

RUN yum install -y gcc-c++ lbzip2 
RUN yum install -y make

COPY software /root/software
RUN mkdir -p /root/build_software

# WORKDIR  /root
RUN tar -xJf /root/software/gcc-8.3.0.tar.xz -C /root/build_software
RUN cp  /root/software/isl-0.18.tar.bz2 /root/software/mpfr-3.1.4.tar.bz2 /root/software/gmp-6.1.0.tar.bz2 /root/software/mpc-1.0.3.tar.gz   /root/build_software/gcc-8.3.0/
WORKDIR  /root/build_software/gcc-8.3.0

RUN ./contrib/download_prerequisites

RUN mkdir -p build && cd build
WORKDIR  /root/build_software/gcc-8.3.0/build
RUN ../configure  --enable-bootstrap --enable-checking=release --enable-languages=c,c++ --disable-multilib && make -j12 
RUN yum remove -y gcc
RUN make install
RUN rm -f /lib64/libstdc++.so.6
RUN cp /usr/local/lib64/libstdc++.so.6.0.25 /lib64/libstdc++.so.6.0.25
RUN ln -s /lib64/libstdc++.so.6.0.25 /lib64/libstdc++.so.6
RUN rm -f /usr/bin/cc
RUN ln -s /usr/local/bin/gcc /usr/bin/cc

RUN yum remove -y cmake
RUN yum install -y cmake3
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake
RUN yum install -y git libuuid-devel openssl-devel cyrus-sasl-devel libicu-devel 

RUN tar -xzf /root/software/mongo-c-driver-1.16.2.tar.gz -C /root/build_software
WORKDIR /root/build_software/mongo-c-driver-1.16.2/build
RUN cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF .. && make  -j4 && make install

RUN tar -xzf /root/software/mongo-cxx-driver-r3.5.0.tar.gz -C /root/build_software
WORKDIR /root/build_software/mongo-cxx-driver-r3.5.0/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && make -j4 && make install

RUN ln -s /usr/local/lib64/libmongocxx.so._noabi  /lib64/libmongocxx.so._noabi
RUN ln -s /usr/local/lib64/libbsoncxx.so._noabi  /lib64/libbsoncxx.so._noabi
RUN ln -s /usr/local/lib64/libbson-1.0.so.0  /lib64/libbson-1.0.so.0
RUN ln -s /usr/local/lib64/libmongoc-1.0.so.0  /lib64/libmongoc-1.0.so.0

RUN tar -xzf /root/software/redis-5.0.8.tar.gz -C /root/build_software
WORKDIR /root/build_software/redis-5.0.8
RUN make  -j4 && make install

RUN yum install -y redis-trib
RUN yum install -y net-tools bind-utils mongodb-org etcd
RUN yum install -y python3
RUN pip3 install jinja2

FROM centos:7

COPY --from=centos_gcc /usr /usr

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
COPY software/CentOS7-Base-163.repo /etc/yum.repos.d/CentOS7-Base-163.repo
RUN yum clean all && yum makecache
RUN yum install -y epel-release 
# RUN yum install -y centos-release-scl


