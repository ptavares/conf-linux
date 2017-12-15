alias ..="cd .."
alias ...="cd ../.."

# List only directories
alias lsd='ls -l | grep "^d"'

################################
###  File ShortCut
################################
alias D="cd ~/Téléchargements"
alias p="cd ~/projects"
alias pims="cd ~/projects/ims"
alias pmc="cd ~/projects/datamc"
alias vi="vim -O"
alias l="ll"
alias tmux='tmux -2'

################################
###  Program ShortCut
################################

# git related shortcut
alias undopush="git push -f origin HEAD^:master"
alias gd="git diff"
alias gdc="git diff --cached"
alias ga="git add"
alias gca="git commit -a -m"
alias gcm="git commit -m"
alias gbd="git branch -D"
alias gst="git status -sb --ignore-submodules"
alias gm="git merge --no-ff"
alias gpt="git push --tags"
alias gp="git push"
alias grs="git reset --soft"
alias grh="git reset --hard"
alias gb="git branch"
alias gcob="git checkout -b"
alias gco="git checkout"
alias gba="git branch -a"
alias gcp="git cherry-pick"
alias gl="git lg"
alias gpom="git pull origin master"
alias gcl="git clone"

# Touchscreen
alias touchscreen="~/conf-linux/utils/touchscreen.sh"
# Mount/umount android phone
alias androidPhone="~/conf-linux/utils/androidPhone.sh"
# Make backup
alias backupPC="~/conf-linux/utils/backupPC.sh"
# foreman api
alias foremanUtils="~/tools/foreman_utils/foreman.sh"
# purge kernel
alias purgeKernel="sudo ~/tools/purge_old_kernel/clean_kernel.sh"
# OTP
alias getOTP="~/tools/scripts_utils/getOTP.py"
