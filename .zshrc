autoload -Uz compinit
compinit -i

eval "$(zoxide init zsh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/sonicboom_light.omp.json)"
path=($HOME/.config/emacs/bin $path)
path=($HOME/.local/bin $path)

export BAT_THEME="Nord"
export TERMINAL=/usr/bin/konsole
export TERM=xterm-256color
export PATH
export GIT_DISCOVERY_ACROSS_FILESYSTEM=true
export EDITOR=nvim
export CLICOLOR=1
export OPENCV_LOG_LEVEL=ERROR

HISTSIZE=50000
SAVEHIST=50000
HISTFILE=$HOME/.zsh_history
HIST_STAMPS="%d/%m/%y %T"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

source /usr/share/zsh-antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

alias cat='bat'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq);paru -c' #Cleanup orphaned packages
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
#alias g++="g++ -std=c++23 -g -o"
alias ear="clear"
alias cl="clear"
alias config='/usr/bin/git --git-dir=/home/jmboles/dotfiles.git/ --work-tree=/home/jmboles'
alias mpvhdr='ENABLE_HDR_WSI=1 mpv --vo=gpu-next --target-colorspace-hint --gpu-api=vulkan --gpu-context=waylandvk'

bindkey '^Z' fancy-ctrl-z
bindkey '^H' fzf-history-widget 
bindkey '^F' autosuggest-accept

# Added by ProtonUp-Qt on 17-09-2023 00:14:03
if [ -d "/home/jmboles/stl/prefix" ]; then export PATH="$PATH:/home/jmboles/stl/prefix"; fi

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

