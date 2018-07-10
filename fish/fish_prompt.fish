set -g pad " "

## Function to show a segment
function prompt_segment -d "Function to show a segment"
  # Get colors
  set -l bg $argv[1]
  set -l fg $argv[2]

  # Set 'em
  set_color -b $bg
  set_color $fg

  # Print text
  if [ -n "$argv[3]" ]
    echo -n -s $argv[3]
  end
end

## Function to show current status
function show_status -d "Function to show the current status"
  if [ $RETVAL -ne 0 ]
    prompt_segment red white " ▲ "
    set pad ""
    end
  if [ -n "$SSH_CLIENT" ]
      prompt_segment blue white " SSH: "
      set pad ""
    end
end

function show_virtualenv -d "Show active python virtual environments"
  if set -q VIRTUAL_ENV
    set -l venvname (basename "$VIRTUAL_ENV")
    prompt_segment normal white " ($venvname) "
  end
end

## Show user if not in default users
function show_user -d "Show user"
  set -l date (date "+$c2%H$c0:$c2%M$c0:$c2%S,")
  prompt_segment normal blue $date
  set -l du (df . | sed -En 's/.*[[:space:]]([0-9]{1,3})%.*/\1/p')
  prompt_segment normal 6dc7ff "du:"
  prompt_segment normal yellow "$du%"
  if not contains $USER $default_user; or test -n "$SSH_CLIENT"
    set -l host (hostname -s)
    set -l who (whoami)
    prompt_segment normal 6dc7ff " $who"

    # Skip @ bit if hostname == username
    if [ "$USER" != "$HOST" ]
      prompt_segment normal white "@"
      prompt_segment normal 009eff "$host "
      set pad ""
    end
  end
end

# Show directory
function show_pwd -d "Show the current directory"
  #set -l pwd (prompt_pwd)
  set -l pwd (pwd)
  prompt_segment normal 81A2FC "$pad$pwd "
end

# Show prompt w/ privilege cue
function show_prompt -d "Shows prompt with cue for current priv"
  printf "\n"
  set -l uid (id -u $USER)
    if [ $uid -eq 0 ]
    prompt_segment red white " ! "
    set_color normal
    echo -n -s " "
  else
    prompt_segment normal white "\$ "
    end

  set_color normal
end

## SHOW PROMPT
function fish_prompt
  set -g RETVAL $status
  show_status
  show_virtualenv
  show_user
  show_pwd
  show_prompt
end