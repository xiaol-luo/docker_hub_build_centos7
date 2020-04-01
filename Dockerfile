FROM centos:7

MAINTAINER luoxiaolong

RUN yum install -y wget
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
RUN wget -P /etc/yum.repos.d http://mirrors.163.com/.help/CentOS7-Base-163.repo
RUN yum clean all && yum makecache

RUN yum install -y epel-release 
RUN yum install -y centos-release-scl

COPY software /root/software
RUN mkdir -p /root/build_software

RUN yum install -y lbzip2

# WORKDIR  /root
RUN tar -xJf /root/software/gcc-8.3.0.tar.xz -C /root/build_software
RUN cp  /root/software/isl-0.18.tar.bz2 /root/software/mpfr-3.1.4.tar.bz2 /root/software/gmp-6.1.0.tar.bz2 /root/software/mpc-1.0.3.tar.gz   /root/build_software/gcc-8.3.0/
WORKDIR  /root/build_software/gcc-8.3.0

RUN ./contrib/download_prerequisites
RUN yum install -y devtoolset-9

RUN mkdir -p build && cd build
WORKDIR  /root/build_software/gcc-8.3.0/build
RUN scl enable devtoolset-9 " ../configure  --enable-bootstrap --enable-checking=release --enable-languages=c,c++ --disable-multilib && make -j4 &&  make install"

RUN yum install -y cmake3 && ln -s /usr/bin/cmake3 /usr/bin/cmake
RUN yum install -y uuid-devel


