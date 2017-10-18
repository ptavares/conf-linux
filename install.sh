#!/bin/sh
CURRENT_DIR=`pwd`
TERRAFORM_VERSION=0.10.7

#############################################
# Update system
#############################################
sudo apt-get update && sudo apt-get -y upgrade

#############################################
# Install tools
#############################################

# install keybase
curl -O https://prerelease.keybase.io/keybase_amd64.deb
sudo dpkg -i keybase_amd64.deb
sudo apt-get install -f
run_keybase


# install ssh key
if [ ! -d "${HOME}/.ssh" ]; then
  /bin/mkdir .ssh
fi
cp /keybase/private/ptavares/id_* ${HOME}/.ssh

# config ssh
cp /keybase/private/ptavares/config ${HOME}/.ssh

# install tmux 
sudo apt install tmux
cd 
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
ln -s -f ${CURRENT_DIR}/.tmux.conf.local
cd ${CURRENT_DIR}


# install cargo + fzf (better control+R )
sudo apt install cargo
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
/.fzf/install


# install fish shell
sudo apt install fish
curl -L https://get.oh-my.fish | fish
omf install cmorrell
ln -s -f  ${CURRENT_DIR}/fish_prompt.fish ~/.local/share/omf/themes/cmorrell/fish_prompt.fish 
ln -s -f  ${CURRENT_DIR}/config.fish ~/.config/fish/config.fish 
# set as default shell
chsh -s `wich fish`


# remove light-locker 
sudo apt-get remove -y light-locker --purge

# install utilities
sudo apt install -y vim git unzip zip bzip2 fontconfig curl language-pack-en
sudo apt install -y network-manager network-manager-openvpn jq python-sphinx python-pip

# install Java 8
sudo apt-get install -y default-jdk

# increase Inotify limit (see https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit)
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-inotify.conf
sysctl -p --system

# install latest Docker
curl -sL https://get.docker.io/ | sh

# install latest docker-compose
curl -L "$(curl -s https://api.github.com/repos/docker/compose/releases | grep browser_download_url | head -n 4 | grep Linux | cut -d '"' -f 4)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# installation tools
sudo install python-pip
sudo pip install ansible
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/bin/
wget https://atom.io/download/deb
sudo dpkg -i deb
rm deb
apm install language-terraform
apm install minimap
apm install file-icons
apm install language-docker 
apm install language-markdown
apm install git-plus
apm install compare-files


# configure docker group (docker commands can be launched without sudo)
usermod -aG docker ${USER}


# Suppression des paquets inutiles
sudo apt autoremove
