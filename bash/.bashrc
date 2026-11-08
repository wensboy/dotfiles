# ~/.bashrc: sourced by interactive bash shells.

# domain: guard
case $- in
*i*) ;;
*) return ;;
esac
# end domain: guard

# domain: history
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
# end domain: history

# domain: shell
shopt -s checkwinsize
# end domain: shell

# domain: completion
for file in /usr/share/bash-completion/bash_completion /etc/bash_completion; do
  [[ -r $file ]] && {
    . "$file"
    break
  }
done
# end domain: completion

# domain: alias
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases
# end domain: alias

# domain: prompt
# branch name of the current directory, empty outside a repository
parse_git_branch() {
  command -v git >/dev/null 2>&1 || return
  git rev-parse --is-inside-work-tree &>/dev/null || return
  git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null
}

# marker shown while inside a nix shell
check_nix_shell() {
  [[ -v IN_NIX_SHELL || -v name ]] && echo "#"
}

# rebuild PS1 on every prompt, carrying the exit status of the last command
update_ps() {
  local last=$?
  local symbol='⇒'

  local _c='\[\e['
  local _end='m\]'
  local cyan="${_c}36${_end}"
  local reset="${_c}0${_end}"
  local yellow="${_c}33${_end}"
  local green="${_c}32${_end}"
  local magenta="${_c}35${_end}"
  local red="${_c}31${_end}"

  local git_branch git_display=''
  git_branch="$(parse_git_branch 2>/dev/null)"
  [[ -n $git_branch ]] && git_display="${green}:${reset}${magenta}${git_branch}${reset}"

  local nix_part='$(check_nix_shell)'
  local user_host="${cyan}[\u@\h]${reset}"
  local work_dir="${yellow}\w${reset}"

  if ((last != 0)); then
    symbol="${red}${symbol}${reset}"
  else
    symbol="${green}${symbol}${reset}"
  fi

  PS1="\[\e]0;\u@\h: \w\a\]${nix_part}${user_host}(${work_dir}${git_display})${symbol} "
}

PROMPT_COMMAND=update_ps
# end domain: prompt

# domain: path
# prepend a directory to PATH once, expanding a leading ~ to $HOME
add_to_path() {
  local new_path="$1"
  [[ -n $new_path ]] || return 1
  new_path="${new_path/#\~/$HOME}"
  new_path="$(cd "$new_path" 2>/dev/null && pwd || echo "$new_path")"
  [[ ":$PATH:" == *":$new_path:"* ]] && return 0
  export PATH="$new_path:$PATH"
}

add_to_path "$HOME/.local/bin"
# end domain: path

# domain: proxy
# export http(s) proxy for the current shell
proxy_on() {
  local host="$1"
  local port="$2"
  [[ -n $host && -n $port ]] || return 1
  export http_proxy="http://${host}:${port}"
  export https_proxy="http://${host}:${port}"
  export no_proxy="localhost,127.0.0.0/8"
}

proxy_off() {
  unset http_proxy https_proxy no_proxy
}

proxy_show() {
  env | grep -i "_proxy"
}
# end domain: proxy

# domain: fzf
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"

# start a tmux session for a directory picked with fzf
_fzf_tmux_session() {
  local selected_dir base_name session_name counter=1
  selected_dir=$(find . -type d 2>/dev/null | fzf --height 40% --prompt="Select directory: ")
  [[ -n $selected_dir ]] || return 1
  selected_dir=$(realpath "$selected_dir")
  [[ -f $selected_dir ]] && selected_dir=$(dirname "$selected_dir")
  base_name=$(basename "$selected_dir")
  session_name="$base_name"
  while tmux has-session -t "$session_name" 2>/dev/null; do
    session_name="${base_name}$counter"
    ((counter++))
  done
  tmux new-session -d -s "$session_name" -c "$selected_dir"
  if [[ -n $TMUX ]]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}

# attach to a tmux session picked with fzf
_fzf_tmux_attach() {
  local sessions selected session_name
  sessions=$(tmux list-sessions -F "#{session_name} : #{session_windows}" 2>/dev/null)
  [[ -n $sessions ]] || return 1
  selected=$(echo "$sessions" | fzf --height 40% --prompt="Session: " --delimiter=" : " --with-nth=1,2)
  [[ -n $selected ]] || return 1
  session_name="${selected%% : *}"
  if [[ -n $TMUX ]]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}

bind -x '"\C-p": _fzf_tmux_session'
bind -x '"\C-o": _fzf_tmux_attach'
# end domain: fzf

# domain: ext
# Local-first extension, host-level configuration.
[[ -r ~/.bash_ext ]] && . ~/.bash_ext
# end domain: ext