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

set PATH ~/cargo/bin $PATH


