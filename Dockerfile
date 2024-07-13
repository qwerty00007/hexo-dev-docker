FROM node:19

ENV HOME="/hexo" \
    PUID=3000 \
    PGID=3000 

ENV GIT_USER="hexo"
ENV GIT_EMAIL="hexo@gmail.com"

RUN  apt-get update -y \
&& apt-get -y install rsync \
&& npm config set registry https://registry.npmmirror.com/ \
&& npm install -g hexo

RUN groupadd -r hexo -g ${PGID} \
&& useradd -r hexo -g hexo -d ${HOME} -s /bin/bash -u ${PUID}



COPY setup /setup
USER hexo
# Start the server
CMD ["/bin/sh", "/setup/run.sh"]
