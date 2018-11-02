# redis-in-k8s
通过修改脚本的port，7000-7005，创建三主三从的redis集群
时间：2018.11.01


下载后，通过修改端口，创建6个镜像  
vim docker-entrypoint.sh

docker build -t xxx/wangsj/redis0:0.3 .

docker push xxx/wangsj/redis0:0.3

vim docker-entrypoint.sh

docker build -t xxx/wangsj/redis1:0.3 .

docker push xxx/wangsj/redis1:0.3

vim docker-entrypoint.sh

docker build -t xxx/wangsj/redis2:0.3 .

docker push xxx/wangsj/redis2:0.3

vim docker-entrypoint.sh

docker xxx/wangsj/redis3:0.3 .

docker xxx/wangsj/redis3:0.3

vim docker-entrypoint.sh

docker xxx/wangsj/redis4:0.3 .

docker xxx/wangsj/redis4:0.3

vim docker-entrypoint.sh

docker xxx/wangsj/redis5:0.3 .

docker xxx/wangsj/redis5:0.3

k8s创建deploy 和service
通过模板和修改模板，创建6个deploy和6个service
此处省略一大堆


更新：更新（使用StatefulSet方式部署，更为简单，不要打6个镜像，使用ubuntu的方式还是一样的）（2018.11.02）


创建一个ubuntu镜像开始配置集群
如果没有打包好的镜像，那么你就需要使用官方的ubuntu镜像，然后安装一些必要的软件
apt-get update 

apt-get install -y vim wget python2.7 python-pip redis-tools dnsutils


cat > /etc/apt/sources.list << EOF

deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse

EOF

pip install redis-trib
使用unbuntu创建集群
实际测试发现，不能使用service的ip，要使用pod的ip

redis-trib.py create 172.20.6.43:7000 172.20.12.107:7002 172.20.10.77:7004

redis-trib.py replicate --master-addr 172.20.6.43:7000 --slave-addr 172.20.3.80:7001

redis-trib.py replicate --master-addr 172.20.12.107:7002 --slave-addr 172.20.11.179:7003

redis-trib.py replicate --master-addr 172.20.10.77:7004 --slave-addr 172.20.8.248:7005

安装完成

登陆查看cluster nodes

