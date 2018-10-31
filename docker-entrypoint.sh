#!/bin/sh
port=7005
if [  -f /redis-data/${port}/start.conf ]; then
   sleep 30
   OLDIP=`cat /redis-data/${port}/start.conf`
   echo "重启前的ip"$OLDIP
   IP=$(hostname -I)
   echo "重启后节点的ip："${IP}
        PORT=${port} envsubst < /redis-conf/redis-cluster-auth.tmpl > /redis-data/${port}/redis.conf
		
        sed -i "s/${OLDIP}/${IP}/g" /redis-data/7000/nodes.conf
        #sed -i 's/[ ][ ]*\:/\:/g' /redis-data/7000/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/7001/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/7002/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/7003/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/7004/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/7005/nodes.conf
	    
   sleep 30
   echo '重写pod的ip到start.conf中'
   echo ${IP} > /redis-data/${port}/start.conf
/usr/local/bin/redis-server /redis-data/${port}/redis.conf
fi
if [ ! -f /redis-data/start.conf ]; then
if [ "$1" = 'redis-cluster' ]; then
  mkdir -p /redis-data/${port}
  IP=$(hostname -I)
  ls /redis-data/${port}/
  echo "查看起使start.conf文件是否有内容"
  cat /redis-data/${port}/start.conf
  echo "初始创建pod 的ip："${IP}
  echo ${IP} > /redis-data/${port}/start.conf
  PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-data/${port}/redis.conf
  sleep 30
  /usr/local/bin/redis-server /redis-data/${port}/redis.conf
else
  exec "$@"
fi
fi
