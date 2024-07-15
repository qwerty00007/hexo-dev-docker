FROM node:19

ENV HOME="/hexo" \
    PUID=3000 \
    PGID=3000 

ENV GIT_USER="hexo"
ENV GIT_EMAIL="hexo@gmail.com"

RUN usermod -u 911 node \
&& groupmod -g 911 node \
&& chown node:node /home/node

RUN  apt-get update -y \
&& apt-get -y install rsync \
&& npm config set registry https://registry.npmmirror.com/ \
&& npm install -g hexo

COPY setup /setup
CMD ["/bin/sh", "/setup/pre-run.sh"]
USER hexo
# Start the server
CMD ["/bin/sh", "/setup/run.sh"]
