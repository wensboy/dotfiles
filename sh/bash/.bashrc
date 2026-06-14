# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
    #xterm-color|*-256color) color_prompt=yes;;
#esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=no

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

parse_git_branch(){
    git rev-parse --is-inside-work-tree &>/dev/null || return
    git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null
}

check_nix_shell() {
    [[ -v IN_NIX_SHELL || -v name ]] && echo "#"
}

update_ps() {
    local last=$?
    local symbol='⇒'
    
    # 颜色映射
    local _c='\[\e['
    local _end='m\]'
    local cyan="${_c}36${_end}"
    local reset="${_c}0${_end}"
    local yellow="${_c}33${_end}"
    local green="${_c}32${_end}"
    local magenta="${_c}35${_end}"
    local red="${_c}31${_end}"
    
    # Git 分支（如果存在）
    local git_branch="$(parse_git_branch 2>/dev/null)"
    local git_display=""
    if [[ -n "$git_branch" ]]; then
        git_display="${green}:${reset}${magenta}${git_branch}${reset}"
    fi
    
    # 构建 PS1
    local nix_part='$(check_nix_shell)'
    local user_host="${cyan}[\u@\h]${reset}"
    local work_dir="${yellow}\w${reset}"
    
    if [[ "$last" -ne 0 ]]; then
        symbol="${red}${symbol}${reset}"
    else
        symbol="${green}${symbol}${reset}"
    fi
    
    PS1="${nix_part}${user_host}(${work_dir}${git_display})${symbol} "
}

export PROMPT_COMMAND=update_ps

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias so='source'
alias ll='ls -al'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#=============================================================================#
#=============================================================================#
#=============================================================================#

# proxy
proxy_on() { 
    local host=$1
    local port=$2
    export http_proxy="http://${host}:${port}"
    export https_proxy="http://${host}:${port}"
    export no_proxy="localhost,127.0.0.0/8"
}

proxy_off() {
    unset http_proxy
    unset https_proxy
    unset no_proxy
}

proxy_show() {
    env | grep -i "_proxy"
}
# proxy end

# functions
add_to_path() {
    local new_path="$1"
    [[ -z "$new_path" ]] && { echo "path error: invalid path" >&2; return 1; }
    new_path="${new_path/#\~/$HOME}"
    new_path="$(cd "$new_path" 2>/dev/null && pwd || echo "$new_path")"
    if [[ ":$PATH:" == *":$new_path:"* ]]; then
        echo "path exist: $new_path" > /dev/null 2>&1
        return 0
    fi
    export PATH="$new_path:$PATH"
    echo "path set: $new_path" > /dev/null 2>&1
}
# functions end

# go
GO_ROOT="/usr/local/bin/go/1.25.8"
add_to_path "${GO_ROOT}/bin"
add_to_path "$(go env GOPATH)/bin"
# go end

# protobuf
add_to_path "$HOME/.local/bin"
# end protobuf

# fzf
source /usr/share/doc/fzf/examples/key-bindings.bash
_fzf_tmux_session() {
    # Use fzf to select directory starting from current directory
    local selected_dir
    selected_dir=$(find . -type d 2>/dev/null | fzf --height 40% --prompt="Select directory: ")
    
    # If no directory selected, exit
    if [[ -z "$selected_dir" ]]; then
        echo "No directory selected"
        return 1
    fi
    
    # Convert relative path to absolute path
    selected_dir=$(realpath "$selected_dir")
    
    # Get base name (last component of the path)
    local base_name
    base_name=$(basename "$selected_dir")
    
    # Check if base_name is actually a file (if selected_dir is a file, use its parent directory)
    if [[ -f "$selected_dir" ]]; then
        selected_dir=$(dirname "$selected_dir")
        base_name=$(basename "$selected_dir")
    fi
    
    # Generate unique session name
    local session_name="$base_name"
    local counter=1
    
    # Check if session with exact name exists
    while tmux has-session -t "$session_name" 2>/dev/null; do
        session_name="${base_name}$counter"
        ((counter++))
    done
    
    # Create new tmux session
    tmux new-session -d -s "$session_name" -c "$selected_dir"
    
    # Attach to the session
    # If already inside tmux, switch to it; otherwise attach
    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
    
    echo "Created and attached to tmux session: $session_name"
}
_fzf_tmux_attach() {
    # Get sessions formatted as "session_name : window_count"
    local sessions
    sessions=$(tmux list-sessions -F "#{session_name} : #{session_windows}" 2>/dev/null)
    
    if [[ -z "$sessions" ]]; then
        echo "No tmux sessions found"
        return 1
    fi
    
    # Select session with fzf
    local selected
    selected=$(echo "$sessions" | fzf --height 40% --prompt="Session: " --delimiter=" : " --with-nth=1,2)
    
    [[ -z "$selected" ]] && return 1
    
    # Get session name
    local session_name="${selected%% : *}"
    
    # Attach
    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}

# Export the function
export -f _fzf_tmux_session
export -f _fzf_tmux_attach
# set hot key for _fzf_* functions
bind -x '"\C-p": _fzf_tmux_session'
bind -x '"\C-o": _fzf_tmux_attach'
# fzf end

# pnpm
export PNPM_HOME="/home/hacker/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# fnm
FNM_ROOT="~/.local/share/fnm/1.39.0"
add_to_path "${FNM_ROOT}"
eval "$(fnm env --use-on-cd --shell bash)"
# fnm end

# fusion
FUSION_ROOT="~/.local/share/fusion/1.1.1/fusion"
FUSION_PASSWORD='feedrss_oss111'
FUSION_PORT="55310"
FUSION_DB_PATH='~/.local/share/fusion/1.1.1/fusion.db'
alias fusion="FUSION_DB_PATH=${FUSION_DB_PATH} FUSION_PORT=${FUSION_PORT} FUSION_PASSWORD=${FUSION_PASSWORD} ${FUSION_ROOT}"
# fusion end

# cargo
. "$HOME/.cargo/env"
# cargo end
