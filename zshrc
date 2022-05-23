# Key
setopt nonomatch  # support *
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

bindkey '^[o' backward-delete-char  # Alt+o
bindkey '^[i' backward-delete-word  # Alt+i

# bindkey '^i' backward-delete-word   # Ctrl+i   conflict with fzf

bindkey \^U backward-kill-line      # ctrl + U
bindkey \^K kill-line               # ctrl + K

bindkey '^[h' beginning-of-line     # Alt+h
bindkey '^[l' end-of-line           # Alt+l 

bindkey '^[j' backward-char         # Alt+j
bindkey '^[k' forward-char          # Alt+k 

bindkey '^[b' backward-word         # Alt+b
bindkey '^[f' forward-word          # Alt+f

bindkey '^[p' up-line-or-history    # Alt+p
bindkey '^[n' down-line-or-history  # Alt+n

bindkey '^[u' undo                  # alt+u
bindkey '^[U' redo                  # alt+shift+u

bindkey '^[;' accept-line           # alt+;
