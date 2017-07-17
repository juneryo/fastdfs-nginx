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
## or use your image name to replace name 'fastdfs-nginx-server'
docker build -t fastdfs-nginx-server .
``````

Run
-------------
* docker on windows
``````
docker run --net=host -d \
  -p 22122:22122 \
  -p 23000:23000 \
  -p 8080:8080 \
  -p 8081:8081 \
  -v /var/log/fdfs/:/data/fdfs/logs/ \
  -v /data/fdfs/data/:/data/fdfs/data/ \
  -v /var/log/nginx/:/var/log/nginx/ \
  fastdfs-nginx-server \
  sh -c "/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart && /usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart && /usr/sbin/nginx -g 'daemon off;'"
``````
* docker on linux
``````
docker run --net=host -d \
  -p 22122:22122 \
  -p 23000:23000 \
  -p 8080:8080 \
  -p 8081:8081 \
  -v /var/log/fdfs/:/data/fdfs/logs/ \
  -v /data/fdfs/data/:/data/fdfs/data/ \
  -v /var/log/nginx/:/var/log/nginx/ \
  fastdfs-nginx-server
``````

API
-------------
``````
## fetch file from server, if you need check token
http://ip:8080/group1/M00/00/00/xxxxxx?tk=zzz&&typ=yyy

## fetch file from server directly
http://ip:8081/group1/M00/00/00/xxxxxx.yyy
``````
