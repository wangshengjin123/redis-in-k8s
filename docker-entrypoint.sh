#!/bin/sh
#端口=7000-7005  共6个
port=7005 
mkdir -p /redis-data/${port}
mkdir -p /redis-conf/${port}
if [  -f /redis-data/${port}/start.conf ]; then
   echo "start.conf文件存在"
   sleep 30
   OLDIP=`cat /redis-data/${port}/start.conf`
   echo "重启前的ip"$OLDIP
   IP=$(hostname -I)
   echo "重启后节点的ip："${IP}
   echo ${IP} > /redis-data/${port}/start.conf
   echo '重写pod的ip到start.conf中'
        #PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-data/${port}/redis.conf
        #PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-conf/${port}/redis.conf

		echo "开始替换...并去除空格"	
                sed -i "s/${OLDIP}/${IP}/g" /redis-data/7000/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/7001/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/7002/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/7003/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/7004/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/7005/nodes.conf  
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/7000/nodes.conf
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/7001/nodes.conf
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/7002/nodes.conf
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/7003/nodes.conf
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/7004/nodes.conf
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/7005/nodes.conf
		echo "替换node.conf完成"
   sleep 30
   
   echo "启动进程..."
#/usr/local/bin/redis-server /redis-data/${port}/redis.conf
#redis-cli  -p ${port} shutdown
/redis/src/redis-server /redis-data/${port}/redis.conf
fi
if [ ! -f /redis-data/${port}/start.conf ]; then
   echo "start.conf文件不存在"
if [ "$1" = 'redis-cluster' ]; then
  IP=$(hostname -I)
  echo "初始创建pod 的ip："${IP}
  echo ${IP} > /redis-data/${port}/start.conf
  echo "查看起使start.conf文件是否有内容"
  cat /redis-data/${port}/start.conf
  PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-data/${port}/redis.conf
    PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-conf/${port}/redis.conf
  sleep 30
  #/usr/local/bin/redis-server /redis-data/${port}/redis.conf
  #redis-cli  -p ${port} shutdown
  /redis/src/redis-server /redis-data/${port}/redis.conf
else
  exec "$@"
fi
fi
