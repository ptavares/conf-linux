# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# functions
function sync_history --on-event fish_preexec
    history --save
    history --merge
end

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish


# Cargo
set PATH ~/cargo/bin $PATH

# GoPath
set PATH /usr/local/go/bin $PATH
export GOPATH=$HOME/projects/go

source $HOME/.config/fish/aliases.fish

# Set the tmux window title, depending on whether we are running something, or just prompting

function fish_title
	if [ "fish" != $_ ]
		tmux rename-window "$argv"
	else
        tmux_directory_title
	end
end

function tmux_directory_title
	if [ "$PWD" != "$LPWD" ]
		set LPWD "$PWD"
		set INPUT $PWD
		set SUBSTRING (eval echo $INPUT| awk '{ print substr( $0, length($0) - 19, length($0) ) }')
		tmux rename-window "..$SUBSTRING"
	end
end


