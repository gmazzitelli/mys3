### docker access to s3
- creare il file .env 
```
ACCESS_KEY_ID=...
SECRET_ACCESS_KEY=...
GID=...
GIG=...
```
```docker run -it -d --privileged --name mys3 --env-file --env UID=$(id -u) --env GID=$(id -g) mys3```
```docker exec -it mys3 bash```
```docker run -it -d --privileged --device /dev/fuse --cap-add SYS_ADMIN --name mys3 --env-file .env --env UID=$(id -u) --env GID=$(id -g) -v /mnt/s3:/home/root/s3:shared gmazzitelli/s3```
- comando raw:
```s3fs cygno-data /home/root/s3/ -o passwd_file=/etc/passwd-s3fs -o url=https://swift.recas.ba.infn.it/ -o use_path_request_style```
- s3fs "$i" "$DIR" -o passwd_file=/etc/passwd-s3fs -o url=https://swift.recas.ba.infn.it/ -o use_path_request_style -o umask=0007,uid=$UID,gid=$GID,allow_other # -o use_cache=/tmp/ -o ensure
_diskfree=2G
