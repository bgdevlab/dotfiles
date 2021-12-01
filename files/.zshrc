BREW_PREFIX=$(brew --prefix)

# "cd" by typing only the directory
setopt autocd

# brew shared bin
export PATH="/usr/local/sbin:$PATH"

# Use the terminal to enter GPG passphrase
export GPG_TTY=$(tty)

# brew autocompletions
# https://docs.brew.sh/Shell-Completion
export FPATH="$BREW_PREFIX/share/zsh/site-functions:$FPATH"

# Zsh autocompletions
# https://github.com/zsh-users/zsh-autosuggestions
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
bindkey '^e' autosuggest-execute
bindkey '^y' autosuggest-accept

# Zsh syntax highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Command substring search (up / down arrows)
# https://github.com/zsh-users/zsh-history-substring-search
source "$BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down

# z: jump around
# https://github.com/rupa/z/
source "$BREW_PREFIX/etc/profile.d/z.sh"

# sqlite
# https://formulae.brew.sh/formula/sqlite#default
export PATH="$BREW_PREFIX/opt/sqlite/bin:$PATH"
alias sqlite="sqlite3"

# GNU findutils
# https://formulae.brew.sh/formula/findutils#default
export PATH="$BREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"

# GNU coreutils
# https://formulae.brew.sh/formula/coreutils#default
export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

# GNU sed
# https://formulae.brew.sh/formula/gnu-sed#default
export PATH="$BREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"

# GNU which
# https://formulae.brew.sh/formula/gnu-which#default
export PATH="$BREW_PREFIX/opt/gnu-which/libexec/gnubin:$PATH"

# Java
export PATH="$BREW_PREFIX/opt/openjdk/bin:$PATH"

# composer
# https://formulae.brew.sh/formula/composer#default
export PATH="/Users/tim/.composer/vendor/bin:$PATH"

# locally installed composer install binaries
# https://twitter.com/paulredmond/status/1189952205182226432
export PATH="./vendor/bin:$PATH"

# artisan commands
alias c="composer"

# artisan commands
alias a="php artisan"

# fzf
# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# use 'fd' instead of 'find' for fzf file lookup
export FZF_DEFAULT_COMMAND="fd --type file --follow --no-ignore --hidden --exclude .git"

# phpactor
# https://github.com/phpactor/phpactor
export PATH="/Users/tim/.vim/plugged/phpactor/bin:$PATH"

# bat, not cat 🦇
# https://github.com/sharkdp/bat
alias cat="bat"
export BAT_THEME="Dracula"

# VIM, not nano
export VISUAL=vim
export EDITOR="$VISUAL"
alias ":q"="exit"

# Docker compose
alias dcu="docker-compose up -d"

# Big Picture Medical deployment helper
bpm-deploy() {
    docker run -v "/Users/tim/Code:/bpm" -v "/Users/tim/.aws:/root/.aws" -it bpmdeploy/bpm-deploy:latest
}

# Open in web browser
browse() {
    domain=$(echo $PWD | sed "s=$HOME/Code==I" | sed "s=/.*==")
    if [ ${#domain} -gt 0 ];
    then
        open http://$domain.test
    else
        open -a Firefox\ Developer\ Edition
    fi
}

# A tinker env to play in
play() {
    cd $HOME/Code/playground

    php artisan tinker
}

update() {
    bash $HOME/Code/dotfiles/install
}

# Setup completions
autoload -Uz compinit
compinit

# Set pure prompt
autoload -U promptinit; promptinit
prompt pure

# always start in the code directory
cd $HOME/Code
