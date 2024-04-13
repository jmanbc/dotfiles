# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz compinit
compinit -i

eval "$(zoxide init zsh)"

export BAT_THEME="Nord"
export TERMINAL=/usr/bin/kitty
export TERM=xterm-256color
path=('/home/jmboles/.config/emacs/bin' $path)
path=('/home/jmboles/.local/bin' $path)
export PATH
export GIT_DISCOVERY_ACROSS_FILESYSTEM=true
export EDITOR=nvim
export CLICOLOR=1

unsetopt nomatch

HISTSIZE=50000
SAVEHIST=50000
HISTFILE=$HOME/.zsh_history
HIST_STAMPS="%d/%m/%y %T"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

#antigen plugins
source $HOME/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found
antigen bundle thefuck
antigen bundle sudo
antigen bundle vi-mode
antigen bundle history
antigen bundle colored-man-pages
antigen bundle fancy-ctrl-z
antigen bundle Aloxaf/fzf-tab
antigen bundle fzf
antigen bundle vscode

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

# Load the theme.
antigen theme romkatv/Powerlevel10k

# Tell Antigen that you're done.
antigen apply

alias cat='bat'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq);paru -c' #Cleanup orphaned packages
alias clock='tty-clock -sct -C 4'
alias cpu="ps axch -o cmd:15,%cpu --sort=-%cpu | head"
alias df='df -h'
alias e='exit'
alias grep='grep --color=auto'
alias jctl="journalctl -p 3 -xb" #get the error messages from journalctl
alias killp='killprocess'
alias kp='killprocess'
alias l='eza -lahF --color=always --icons --sort=size --group-directories-first'
alias less='bat'
alias ls='eza -lhF --color=always --icons --sort=size --group-directories-first'
alias lst='eza -lahfT --color=always --icons --sort=size --group-directories-first'
alias mem="ps axch -o cmd:15,%mem --sort=-%mem | head"
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist" # update your mirrors
alias mirrora="sudo reflector --latest 30 --number 10 --sort age --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 30 --number 10 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 30 --number 10 --sort score --save /etc/pacman.d/mirrorlist"
alias mv='mv -i'
alias pdw="pwd"
alias q='exit'
alias rg="rg --sort path --no-ignore --hidden" #search content with ripgrep
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -10000 | nl" #Recent Installed Packages
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"
alias rm='rm -i'
alias update='paru; flatpak update'
alias updatefonts='sudo fc-cache -fv'
alias wget="wget -c" # continue the download
alias cd='z'
alias cdi='zi'
alias cd..='z ..'
alias ..='z ..'
alias b='btop'
alias emacs="emacsclient -c -a 'emacs'"
alias g++="g++ -std=c++23 -g -o"
alias ear="clear"
alias cl="clear"
alias config='/usr/bin/git --git-dir=/home/jmboles/dotfiles.git/ --work-tree=/home/jmboles'
alias mpvhdr='ENABLE_HDR_WSI=1 mpv --vo=gpu-next --target-colorspace-hint --gpu-api=vulkan --gpu-context=waylandvk'

ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

rangercd () {
    tmp="$(mktemp)"
    ranger --choosedir="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
	 [[ $1 = 'block' ]]; then
	echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
	   [[ ${KEYMAP} == viins ]] ||
	   [[ ${KEYMAP} = '' ]] ||
	   [[ $1 = 'beam' ]]; then
	echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
	zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
	echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# ci"
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
	bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, di{ etc..
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
	bindkey -M $m $c select-bracketed
  done
done

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
bindkey -s '^x' '\nexit\n'
bindkey -s '^o' 'rangercd\n'
bindkey -s '^g' 'git pull && git status\n'
bindkey -v
bindkey '^Z' fancy-ctrl-z
bindkey '^R' fzf-history-widget 
bindkey '^F' autosuggest-accept

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Added by ProtonUp-Qt on 17-09-2023 00:14:03
if [ -d "/home/jmboles/stl/prefix" ]; then export PATH="$PATH:/home/jmboles/stl/prefix"; fi

