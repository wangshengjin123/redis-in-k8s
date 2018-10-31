from grokzen/redis-cluster:3.2.0
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY redis-cluster-auth.tmpl /redis-conf/redis-cluster-auth.tmpl
RUN chmod 755 /docker-entrypoint.sh
EXPOSE 7000 7001 7002 7003 7004 7005 7006 7007

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["redis-cluster"]
