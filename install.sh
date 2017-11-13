#!/bin/bash -e
DATE='date +%Y/%m/%d:%H:%M:%S'
RETURN=0
CURRENT_DIR=`pwd`
TERRAFORM_VERSION=0.10.8
KEYBASE_PRIVATE_DIR=/keybase/private/${USER}

function log {
    echo `$DATE`" === $1"
}

function setReturn {
    RETURN=$1
}

#############################################
# Update system
#############################################
function updateSystem {
    log "Updating system...."
    sudo apt-get update && sudo apt-get -y upgrade
}

#############################################
# Install system tools
#############################################
function installSystemTools {
    log "Installing system tools..."
    # install utilities
    sudo apt install -y curl vim git unzip zip bzip2 fontconfig curl language-pack-en
    sudo apt install -y network-manager network-manager-openvpn jq python-sphinx python-pip
    # remove light-locker
    sudo apt-get remove -y light-locker --purge
    # install Java 8
    sudo apt-get install -y default-jdk
}

function customizeInstall {
    ln -s -f ${HOME}/conf-linux/.vimrc ~/.vimrc
}


#############################################
# Install keybase
#############################################
function installKeyBase {
    log "Installing keybase...."
    curl -O https://prerelease.keybase.io/keybase_amd64.deb
    sudo dpkg -i keybase_amd64.deb
    sudo apt-get install -f
    run_keybase
}

#############################################
# Install ssh config (keys + config) from keybase
#############################################
function installSSHConfig {
    log "Install ssh key..."
    if [ ! -d "${HOME}/.ssh" ]; then
        /bin/mkdir .ssh
    else
        read -n 1 -p "${HOME}/.ssh exist, overwrite existing files ? (y/n) " choice
        if [ ${choice} == 'y' ]; then
            echo ""
            log "Overwrite existing files..."
            if [ ! -d "${KEYBASE_PRIVATE_DIR}/.ssh" ]; then
                log "Check keybase install or KEYBASE_PRIVATE_DIR variable"
                log "==> ${KEYBASE_PRIVATE_DIR} not exist"
                setReturn 1
                return
            else
                log "cp -Rf /keybase/private/ptavares/.ssh ${HOME}/.ssh"
                return
            fi

        fi

        echo ""
        log "Nothing todo"
        return
    fi

}

#############################################
# Install TMUX
#############################################
function installTMUX {
    sudo apt install tmux
    cd ~
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    ln -s -f ${CURRENT_DIR}/.tmux.conf.local
    cd ${CURRENT_DIR}
}


#############################################
# Install Docker stack
#############################################
function installDocker {
    # install latest Docker
    curl -sL https://get.docker.io/ | sh
    # install latest docker-compose
    curl -L "$(curl -s https://api.github.com/repos/docker/compose/releases | grep browser_download_url | head -n 4 | grep Linux | cut -d '"' -f 4)" > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    # configure docker group (docker commands can be launched without sudo)
    usermod -aG docker ${USER}
}


#############################################
# Install hashicorp tools
#############################################
function installHashicorpTools {
    # install python-pip for last ansible version
    sudo install python-pip
    sudo pip install ansible
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    sudo mv terraform /usr/bin/
}


#############################################
# Install Atom
#############################################
function installAtom {
    # Download last Atom release
    wget https://atom.io/download/deb
    sudo dpkg -i deb
    rm deb
    # install plugins
    apm install language-terraform
    apm install minimap
    apm install file-icons
    apm install language-docker
    apm install language-markdown
    apm install git-plus
    apm install compare-files
}


#############################################
# Install fishshell
#############################################
function installFish {
    # install fish shell
    sudo apt install fish
    git clone https://github.com/oh-my-fish/oh-my-fish
    cd oh-my-fish
    ./bin/install --noninteractive
    cd ${CURRENT_DIR}
    rm -Rf oh-my-fish
      # set as default shell
    chsh -s /usr/bin/fish
}

#############################################
# Customize fishshell
#############################################
function customizeFish {
    omf install cmorrell
    ln -s -f  ${CURRENT_DIR}/fish_prompt.fish ~/.local/share/omf/themes/cmorrell/fish_prompt.fish
    ln -s -f  ${CURRENT_DIR}/config.fish ~/.config/fish/config.fish
    # install cargo + fzf (better control+R )
    sudo apt install cargo
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    /.fzf/install
}

#############################################
# Clean install
#############################################
function endInstall {
    log "Cleaning installation..."
    sudo apt autoremove
}

case $1 in
    update)
        updateSystem
        ;;
    systemTools)
        installSystemTools
        ;;
    customInstall)
        customizeInstall
        ;;
    keyBase)
        installKeyBase
        ;;
    sshConfig)
        installSSHConfig
        ;;
    tmux)
        installTMUX
        ;;
    docker)
        installDocker
        ;;
    hashicorpTools)
        installHashicorpTools
        ;;
    atom)
        installAtom
        ;;
    fishShell)
        installFish
        ;;
    customFishShell)
        customizeFish
        ;;
    end)
        endInstall
        ;;
    *)
        echo "usage ${0} [update|systemTools|customInstall|keyBase|sshConfig|tmux|docker|hashicorpTools|atom|fishShell|customFishShell|end]"
        exit 1
        ;;
esac

log "End. Exiting with ${RETURN}"
exit ${RETURN}
