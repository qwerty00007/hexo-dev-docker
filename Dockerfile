FROM node:19

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
&& apt-get update -y \
&& apt-get -y install rsync \
&& npm config set registry https://registry.npmmirror.com/ \
&& npm install -g hexo \
&& groupmod -o -g "${PGID}" hexo \
&& usermod -o -u "${PUID}" hexo 

COPY setup /setup

RUN chown -R hexo:hexo /setup
USER hexo
# Start the server
CMD ["/bin/bash", "/setup/run.sh"]
