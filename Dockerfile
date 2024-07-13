FROM node:19

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
&& apt-get update -y \
&& apt-get -y install rsync \
&& npm config set registry https://registry.npmmirror.com/ \
&& npm install -g hexo

COPY setup /setup

# Start the server
CMD ["/bin/bash", "/setup/run.sh"]
