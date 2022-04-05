#!/bin/bash


# 设置虚拟内存
if [ ! -d "/home/swap" ]; then
    dd if=/dev/zero of=/home/swap bs=1024 count=4096000
    mkswap /home/swap
	chmod -R 0600 /home/swap
    swapon /home/swap
    echo '/home/swap swap swap default 0 0' >> /etc/fstab
fi

# see https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org=5.0.6 mongodb-org-database=5.0.6 mongodb-org-server=5.0.6 mongodb-org-shell=5.0.6 mongodb-org-mongos=5.0.6 mongodb-org-tools=5.0.6

apt install -y lbzip2 cmake git uuid-dev libssl-dev libicu-dev libsasl2-dev etcd redis ruby
pip3 install jinja2

tar -xzf /root/software/mongo-c-driver-1.16.2.tar.gz -C /root/build_software
cd /root/build_software/mongo-c-driver-1.16.2/build
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF .. && make  -j4 && make install

tar -xzf /root/software/mongo-cxx-driver-r3.5.0.tar.gz -C /root/build_software
cd /root/build_software/mongo-cxx-driver-r3.5.0/build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && make -j4 && make install


tar -xzf /root/software/redis-6.2.6.tar.gz -C /root/build_software
cd /root/build_software/redis-6.2.6
make  -j4 && make install
cp /root/build_software/redis-6.2.6/src/redis-trib.rb /usr/local/bin/
chmod 755 /usr/local/bin/redis-trib.rb

ldconfig

# install docker
apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker

# 改默认shell，选否
dpkg-reconfigure dash



