autoload -U compinit; compinit

eval "$(zoxide init zsh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/sonicboom_light.omp.json)"
eval "$(fzf --zsh)"
path=($HOME/.config/emacs/bin $path)
path=($HOME/.local/bin $path)

export TERMINAL=/usr/bin/kitty
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
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

source /usr/share/zsh-antidote/antidote.zsh
source <(antidote init)
ZVM_INIT_MODE=sourcing

antidote bundle ohmyzsh/ohmyzsh path:plugins/command-not-found
antidote bundle ohmyzsh/ohmyzsh path:plugins/sudo
antidote bundle ohmyzsh/ohmyzsh path:plugins/history
antidote bundle ohmyzsh/ohmyzsh path:plugins/colored-man-pages
antidote bundle ohmyzsh/ohmyzsh path:plugins/fancy-ctrl-z
antidote bundle ohmyzsh/ohmyzsh path:plugins/archlinux
antidote bundle ohmyzsh/ohmyzsh path:plugins/git
antidote bundle jeffreytse/zsh-vi-mode
antidote bundle Aloxaf/fzf-tab
antidote bundle Freed-Wu/fzf-tab-source
antidote bundle zsh-users/zsh-syntax-highlighting
antidote bundle zsh-users/zsh-autosuggestions
antidote bundle zsh-users/zsh-completions

# Always starting with insert mode for each command line
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

alias cat='bat'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq);paru -Scd' #Cleanup orphaned packages
alias cpu="ps axch -o cmd:15,%cpu --sort=-%cpu | head"
alias df='df -h'
alias e='exit'
alias grep='grep --color=auto'
alias jctl="journalctl -p 3 -xb" #get the error messages from journalctl
alias killp='killprocess'find / -xtype l -print
alias kp='killprocess'
alias lsa='eza -lahF --color=always --icons --sort=size --group-directories-first'
alias ls='eza -lhF --color=always --icons --sort=size --group-directories-first'
alias lst='eza -lahfT --color=always --icons --sort=size --group-directories-first'
alias less='bat'
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
alias clera="clear"
alias config='/usr/bin/git --git-dir=/home/jmboles/dotfiles.git/ --work-tree=/home/jmboles'
alias mpvhdr='ENABLE_HDR_WSI=1 mpv --vo=gpu-next --target-colorspace-hint --gpu-api=vulkan --gpu-context=waylandvk'

bindkey '^Z' fancy-ctrl-z
bindkey '^R' fzf-history-widget
bindkey '^Xh' _complete_help
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'

# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# ignore case
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# lessfilter
zstyle ':fzf-tab:complete:*:*' fzf-preview 'fzf-preview.sh ${(Q)realpath}'

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '$group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# tldr
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color $word'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(out=$(tldr --color "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'

#git
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

zstyle ':fzf-tab:*' fzf-min-height '512'
zstyle ':fzf-tab:*' fzf-pad '2'
  
# Added by ProtonUp-Qt on 17-09-2023 00:14:03
if [ -d "/home/jmboles/stl/prefix" ]; then export PATH="$PATH:/home/jmboles/stl/prefix"; fi

_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)
