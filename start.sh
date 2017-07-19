#!/bin/sh

/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart
/usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart
/usr/sbin/nginx -g 'daemon off;'
