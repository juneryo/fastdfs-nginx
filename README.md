Fastdfs nginx server
=============
With some nginx modules in docker

Install
-------------
* [libfastcommon-1.0.35](https://github.com/happyfish100/libfastcommon)
* [fastdfs-master (20170712)](https://github.com/happyfish100/fastdfs)
* [nginx-1.13.3](http://nginx.org/)
* [fastdfs-nginx-module-master (20170710)](https://github.com/happyfish100/fastdfs-nginx-module)
* [echo-nginx-module-master (20170710)](https://github.com/openresty/echo-nginx-module)
* [nginx-eval-module-master (20170712)](https://github.com/vkholodkov/nginx-eval-module)
* [ngx_http_redis-0.3.8](https://www.nginx.com/resources/wiki/modules/redis)

Conf
-------------
* storage.conf
``````
## can not use 127.0.0.1
tracker_server=host-ip:22122
``````
* mod_fastdfs.conf
``````
tracker_server=127.0.0.1:22122
``````
* nginx.conf
``````
## if need check token from redis
upstream redisbackend {
  server    redis-server-ip:port;
  keepalive 1024;
}
``````
* other conf files if you needed

Build
-------------
``````
## you can use your image name to replace name 'fastdfs-nginx-server'
docker build -t fastdfs-nginx-server .
``````

Network
-------------
``````
## you can create your network for this server, like:
docker network create --driver bridge --subnet 192.168.1.0/20 network0
``````

Run
-------------
``````
## should use host network
docker run -itd \
  --name fastdfs-nginx-server \
  --network=host \
  -v /etc/localtime:/etc/localtime:ro \
  -v /var/log/fdfs/:/data/fdfs/logs/ \
  -v /data/fdfs/data/:/data/fdfs/data/ \
  -v /var/log/nginx/:/var/log/nginx/ \
  fastdfs-nginx-server \
  sh -c "/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart && /usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart && /usr/sbin/nginx -g 'daemon off;'"

## if you want to use your network and use ip 192.168.16.6
## in this case, you should update some conf to make fdfs work
docker run -itd \
  --name fastdfs-nginx-server \
  --network=network0 --ip=192.168.16.6 \
  -p 22122:22122 \
  -p 23000:23000 \
  -p 24001:24001 \
  -p 24002:24002 \
  -p 11411:11411 \
  -v /etc/localtime:/etc/localtime:ro \
  -v /var/log/fdfs/:/data/fdfs/logs/ \
  -v /data/fdfs/data/:/data/fdfs/data/ \
  -v /var/log/nginx/:/var/log/nginx/ \
  fastdfs-nginx-server \
  sh -c "/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart && /usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart && /usr/sbin/nginx -g 'daemon off;'"
``````

API
-------------
``````
## fetch file from server, if you need check token
http://ip:24001/group1/M00/00/00/xxxxxx?tk=zzz&&typ=yyy

## fetch file from server directly
http://ip:24002/group1/M00/00/00/xxxxxx.yyy
``````
