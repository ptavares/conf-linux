local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
local disk_usage="${$(\df -P . | sed -n '2p' | awk '{ print $5 }')%%\%}"


disk_usage_prompt() {

  local disk_usage="${$(\df -P . | sed -n '2p' | awk '{ print $5 }')%%\%}"
  local message="${disk_usage}%%"
  echo "$message"
}


PROMPT='${ret_status} %{$fg[blue]%}%*,%{$fg[155]%}du:%{$fg[yellow]%}$(disk_usage_prompt)%  %{$fg[cyan]%}%d%{$reset_color%} $(git_prompt_info)
$ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
