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
echo "***** switch user to hexo *****"
su hexo

if [ "$(ls -A ~/.ssh 2>/dev/null)" ]; then 
    echo "***** HOME .ssh directory exists and has content, continuing *****"; 
else 
    echo "***** HOME .ssh directory is empty, initialising ssh key and configuring known_hosts for common git repositories (github/gitlab) *****" 
    ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P "" 
    ssh-keyscan github.com > ~/.ssh/known_hosts 2>/dev/null 
    ssh-keyscan gitlab.com >> ~/.ssh/known_hosts 2>/dev/null 
fi; 

echo "***** Running git config, user = ${GIT_USER}, email = ${GIT_EMAIL} *****" 
git config --global user.email ${GIT_EMAIL} 
git config --global user.name ${GIT_USER} 



# Check to ensure the /config volume is mounted
if [ ! -d "/config" ]; then
  echo "Please mount a /config directory so you blog persists upon container restarts!"
  echo "If this is your first time setting up the container make sure the /config directory is empty!"
  exit 1
fi

if [ -z "$(ls -A /config)" ]; then
  echo "Blog not yet initialized, setting up the default files..."
  # Initilize the blog
  hexo init /config
else
  echo "Blog already initialized, skipping..."
fi

# Install any required hexo plugins
if [[ -z "${HEXO_PLUGINS}" ]]; then
  echo "No additional plugins to install!"
else
  echo "Installing additional plugins \"${HEXO_PLUGINS}\""
  npm install -C /config ${HEXO_PLUGINS}
fi

# Start the server
echo "Starting hexo server on port 8080"

echo "************************************************************"
echo "************************************************************"
echo "************************************************************"
echo ""
echo "WARNING: If you just see a generic output stating hexo [command] usage"
echo "that's because this container was updated to be more generic and requires"
echo "that you set up the blog as 'new'. To do so, point the /config volume to a"
echo "new EMPTY directory and let it init the blog. Once it's done, you can stop the"
echo "container and copy over your old blog configs."
echo ""
echo "I'm sorry for the trouble. I tried to find a better solution but I don't really"
echo "actively maintain this container anymore. If you have a better solution please"
echo "feel free to submit a PR!"
echo ""
echo "************************************************************"
echo "************************************************************"
echo "************************************************************"
chmod 600 ~/.ssh/id_rsa 
chmod 600 ~/.ssh/id_rsa.pub 
chmod 700 ~/.ssh
echo "***** Contents of public ssh key (for deploy) - *****" 
cat ~/.ssh/id_rsa.pub 
# Start fresh
hexo clean --cwd /config
hexo server --cwd /config -p 8080 --debug --draft
