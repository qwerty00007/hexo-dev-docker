FROM ghcr.io/qwerty00007/node:main

ENV HOME="/hexo" \
    PUID=1000 \
    PGID=100 

ENV GIT_USER="hexo"
ENV GIT_EMAIL="hexo@gmail.com"

RUN apt-get update -y \
&& apt-get -y install rsync \
&& npm config set registry https://registry.npmmirror.com/ \
&& npm install -g hexo

RUN groupadd -r hexo -g ${PGID} \
&& useradd -r hexo -g hexo -d ${HOME} -s /bin/bash -u ${PUID}



COPY setup /setup
USER hexo
# Start the server
CMD ["/bin/bash", "/setup/run.sh"]
