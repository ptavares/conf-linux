#!/bin/bash -e
DATE='date +%Y/%m/%d:%H:%M:%S'
RETURN=0
CURRENT_DIR=`pwd`
TERRAFORM_VERSION=0.11.1
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
    sudo apt install -y wget curl vim git unzip zip bzip2 fontconfig curl language-pack-en dos2unix
    sudo apt install -y network-manager network-manager-openvpn jq python-sphinx python-pip jmtpfs
    # remove light-locker
    sudo apt-get remove -y light-locker --purge
    # install Java 8
    sudo apt-get install -y default-jdk
    # redshift - flux fork 
    #sudo add-apt-repository ppa:jonls/redshift-ppa
    #sudo apt install -y redshift redshift-gtk
}

function customizeInstall {
    log "Custom several tools..."
    ln -s -f ${HOME}/conf-linux/.vimrc ~/.vimrc
    vim +PlugInstall +qall
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
        /bin/mkdir ${HOME}/.ssh
    fi
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
            log "cp -Rf ${KEYBASE_PRIVATE_DIR}/.ssh ${HOME}/.ssh"
            return
        fi

    fi

    echo ""
    log "Nothing todo"
    return

}

#############################################
# Install TMUX
#############################################
function installTMUX {
    log "Install tmux..."
    sudo apt install -y tmux
    cd ~
    log "Install tmux plugin..."
    if [ -d "~/.tmux" ]; then
        mkdir ~/.tmux
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    ln -s -f ${CURRENT_DIR}/.tmux.conf
    ln -s -f ${CURRENT_DIR}/.tmux.conf.local
    cd ${CURRENT_DIR}
}


#############################################
# Install Docker stack
#############################################
function installDocker {
    log "Install latest docker..."
    curl -sL https://get.docker.io/ | sh
    log "Install latest docker-compose..."
    curl -L "$(curl -s https://api.github.com/repos/docker/compose/releases | grep browser_download_url | head -n 4 | grep Linux | cut -d '"' -f 4)" > docker-compose
    sudo /bin/mv docker-compose /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    log "Configure docker group (docker commands can be launched without sudo)"
    sudo usermod -aG docker ${USER}
}


#############################################
# Install hashicorp tools
#############################################
function installHashicorpTools {
    log "Install hashicorp tools..."
    # install python-pip for last ansible version
    sudo apt install python-pip
    log "Install last ansible..."
    sudo pip install ansible
    log "Install terraform verion ${TERRAFORM_VERSION}..."
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    sudo mv terraform /usr/bin/
}


#############################################
# Install Atom
#############################################
function installAtom {
    log "Download and install last atom release..."
    wget https://atom.io/download/deb
    sudo dpkg -i deb
    rm deb
    log "Install plugins..."
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
    log "Install fish shell..."
    sudo apt install fish
    log "Install oh-my-fish..."
    git clone https://github.com/oh-my-fish/oh-my-fish
    cd oh-my-fish
    ./bin/install --noninteractive
    cd ${CURRENT_DIR}
    rm -Rf oh-my-fish
    read -n 1 -p "Set fish as default shell ? (y/n) " choice
    if [ ${choice} == 'y' ]; then
        echo ""
        log "Set as default shell for ${USER}"
        sudo -u ${USER} chsh -s /usr/bin/fish
    fi
}

#############################################
# Customize fishshell
#############################################
function customizeFish {
    log "Install cargo and fzf (better control+R )..."
    sudo apt install cargo
    if [ -d '~/.fzf' ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi
    log "Custom fish shell.."
    log "Copy this command line in your fish prompt"
    echo ""
    echo "omf install cmorrell"
    echo "ln -s -f  ${CURRENT_DIR}/fish_prompt.fish ~/.local/share/omf/themes/cmorrell/fish_prompt.fish"
    echo "ln -s -f  ${CURRENT_DIR}/config.fish ~/.config/fish/config.fish"
    echo "ln -s -f  ${CURRENT_DIR}/tmux.fish ~/.config/fish/tmux.fish"
    echo "/.fzf/install"
    echo "complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'"
    echo ""
}

#############################################
# Customize fishshell
#############################################
function installTools {
    log "Install tools..."
    if [ -d '~/tools' ]; then
        mkdir ~/tools
    fi
    log "Install purge kernel tools..."
    if [ -d '~/tools/purge_old_kernel' ]; then
        git clone https://github.com/ptavares/purge_old_kernel.git ~/tools/purge_old_kernel
    fi
    log "Install foreman utils..."
    if [ -d '~/tools/foreman_utils' ]; then
        git clone https://github.com/ptavares/foreman_utils.git ~/tools/foreman_utils
    fi
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
    installTools)
        installTools
        ;;
    end)
        endInstall
        ;;
    all)
        updateSystem
        installSystemTools
        customizeInstall
        installTMUX
        installDocker
        installHashicorpTools
        installAtom
        installFish
        installTools
        customizeFish
        installKeyBase
        endInstall
        log "Please configure keybase and launch command :"
        echo "${0} installSSHConfig"
        ;;
    *)
        echo "usage ${0} [update|systemTools|customInstall|keyBase|sshConfig|tmux|docker|hashicorpTools|atom|installTools|fishShell|customFishShell|end|all]"
        exit 1
        ;;
esac

log "End. Exiting with ${RETURN}"
exit ${RETURN}
