#!/bin/sh
echo "***** change id *****";
groupmod -o -g "${PGID}" hexo
usermod -o -u "${PUID}" hexo
mkdir /hexo/.ssh
# 更改文件权限

echo "***** change permissions *****"
chown -R hexo:hexo \
    "${HOME}" \
    /config
