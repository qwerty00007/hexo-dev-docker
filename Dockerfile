FROM node:19

ENV PUID=1000 \
    PGID=1000

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
&& apt-get update -y \
&& apt-get -y install rsync \
&& npm config set registry https://registry.npmmirror.com/ \
&& npm install -g hexo \
&& groupadd -r hexo -g ${PGID} \
&& useradd -r hexo -g hexo -u ${PUID}

COPY setup /setup

RUN chown -R hexo:hexo /setup
USER hexo
# Start the server
CMD ["/bin/bash", "/setup/run.sh"]
