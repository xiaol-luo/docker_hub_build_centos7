# docker_hub_build_centos7
docker_hub_build_centos7

 my git dir locate at /shared/docker/docker_hub_build_centos7

docker build -t lxl_cxx/centos_gcc8 -f /shared/docker/docker_hub_build_centos7/Dockerfile_gcc8  /shared/docker/docker_hub_build_centos7
docker build -t lxl_cxx/centos_yum -f /shared/docker/docker_hub_build_centos7/Dockerfile_yum  /shared/docker/docker_hub_build_centos7
docker build -t lxl_cxx/centos_env -f /shared/docker/docker_hub_build_centos7/Dockerfile_env  /shared/docker/docker_hub_build_centos7

或者
# /shared/docker/docker_hub_build_centos7 是上下文路径
docker build -t lxl_cxx/centos -f /shared/docker/docker_hub_build_centos7/Dockerfile  /shared/docker/docker_hub_build_centos7

或者直接安装在虚拟机上
one_key_setup.sh

# debian
docker build -t lxl_debian -f /shared/docker/docker_hub_build_centos7/Dockerfile_Debian  /shared/docker/docker_hub_build_centos7

docker build -t lxl_debian -f  `pwd`/Dockerfile_Debian  `pwd`
