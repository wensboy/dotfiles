# ~/.bash_aliases: sourced from ~/.bashrc.

# domain: ls
# --color=auto is a gnu extension, keep the alias only where it is supported
if ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias so='source'
# end domain: ls

# domain: grep
if printf 'x\n' | grep --color=auto x >/dev/null 2>&1; then
  alias grep='grep --color=auto'
fi
# end domain: grep

# domain: tools
alias vi='nvim'
alias nosd='notify-send'
alias top='btop'
alias cat='bat --paging=never -p'
# end domain: tools
