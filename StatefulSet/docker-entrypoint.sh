#!/bin/sh
echo $port
echo $MY_POD_NAME
mkdir -p /redis-data/${MY_POD_NAME}
mkdir -p /redis-conf/${port}
if [  -f /redis-data/${MY_POD_NAME}/start.conf ]; then
   echo "start.conf文件存在"
   sleep 30
   OLDIP=`cat /redis-data/${MY_POD_NAME}/start.conf`
   echo "重启前的ip"$OLDIP
   IP=$(hostname -I)
   echo "重启后节点的ip："${IP}
   echo ${IP} > /redis-data/${MY_POD_NAME}/start.conf
   echo '重写pod的ip到start.conf中'
        #PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-data/${MY_POD_NAME}/redis.conf
        #PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-conf/${port}/redis.conf

		echo "开始替换..."	
        sed -i "s/${OLDIP}/${IP}/g" /redis-data/redis-app-0/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/redis-app-1/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/redis-app-2/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/redis-app-3/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/redis-app-4/nodes.conf
		sed -i "s/${OLDIP}/${IP}/g" /redis-data/redis-app-5/nodes.conf  
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/redis-app-0/nodes.conf
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/redis-app-1/nodes.conf
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/redis-app-2/nodes.conf
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/redis-app-3/nodes.conf
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/redis-app-4/nodes.conf
		sed -i 's/[ ][ ]*\:/\:/g' /redis-data/redis-app-5/nodes.conf
		echo "替换node.conf完成"
   sleep 30
   
   echo "启动进程..."
#/usr/local/bin/redis-server /redis-data/${port}/redis.conf
#redis-cli  -p ${port} shutdown
/redis/src/redis-server /redis-data/${MY_POD_NAME}/redis.conf
fi
if [ ! -f /redis-data/${MY_POD_NAME}/start.conf ]; then
    echo $port
    echo $MY_POD_NAME
    echo "start.conf文件不存在"
if [ "$1" = 'redis-cluster' ]; then
  IP=$(hostname -I)
  echo "初始创建pod 的ip："${IP}
  echo ${IP} > /redis-data/${MY_POD_NAME}/start.conf
  echo "查看起使start.conf文件是否有内容"
  cat /redis-data/${MY_POD_NAME}/start.conf
    PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-data/${MY_POD_NAME}/redis.conf
    PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-conf/${port}/redis.conf
  sleep 30
  #/usr/local/bin/redis-server /redis-data/${port}/redis.conf
  #redis-cli  -p ${port} shutdown
  /redis/src/redis-server /redis-data/${MY_POD_NAME}/redis.conf
else
  exec "$@"
fi
fi
