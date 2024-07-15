#!/bin/sh
echo "***** add user hexo and group hexo *****";
groupadd -r hexo -g ${PGID} 
useradd -r hexo -g hexo -d ${HOME} -s /bin/bash -u ${PUID}
mkdir /hexo/.ssh
# 更改文件权限

echo "***** change permissions *****"
chown -R hexo:hexo \
    "${HOME}" \
    /config
