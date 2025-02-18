#!/usr/bin/env bash

# ! Important behaviour when entering folders - see function 'enter_directory' in .functions
BREW_PREFIX=$(brew --prefix)
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # $HOME
BASEDIR="$(dirname $(realpath "${BASH_SOURCE[0]}"))" # dotfiles directory
#
# https://scriptingosx.com/2017/04/about-bash_profile-and-bashrc-on-macos/
# https://books.apple.com/book/moving-to-zsh/id1483591353
#
# Standardising on $HOME.bashrc over $HOME/.profile as $HOME/.bash_profile makes $HOME/.profile obsolete and ignores it
#


# Mcfly - https://github.com/cantino/mcfly
type mcfly &>/dev/null && eval "$(mcfly init bash)"

# Starship - easy command prompt
type starship &>/dev/null && eval "$(starship init bash)"
# starship generates a PROMPT_COMMAND, append our enter_directory function to it
if test -z "$PROMPT_COMMAND"; then
    export PROMPT_COMMAND="enter_directory"
fi

USE_SWITCH_PHP_HACKERY='yes use switch_php script (pre OrbStack and Herd adoption 2024-SEPT)'
# unset USE_SWITCH_PHP_HACKERY # Herd and OrbStack only...

[ -r $BASEDIR/.versions ] && source $BASEDIR/.versions || true
[ -r $BASEDIR/.credentials ] && source $BASEDIR/.credentials || true
[ -r $BASEDIR/.profile ] && source $BASEDIR/.profile || true
if ! type starship &>/dev/null; then # ifnot using starsup prompts
    [ -r $BASEDIR/.bash/.ps1 ] && source $BASEDIR/.bash/.ps1 || true # start aware prompt
fi
[ -r $BASEDIR/.bash/.functions ] && source $BASEDIR/.bash/.functions || true
#[ -r $BASEDIR/postgres ] && source $BASEDIR/postgres || echo "No postgres script"
[ -r $BASEDIR/.bash/.exports ] && source $BASEDIR/.bash/.exports || true
[ -r $BASEDIR/.bash/.aliases ] && source $BASEDIR/.bash/.aliases || true
[ -r $BASEDIR/switch_php ] && [ -n "$USE_SWITCH_PHP_HACKERY" ] && source $BASEDIR/switch_php || true
[ -r $HOME/.adhoc ] && source $HOME/.adhoc || true

if echo "$PROMPT_COMMAND" | grep 'enter_directory' 2&>/dev/null; then # add enter_directory once.
    export PROMPT_COMMAND="$PROMPT_COMMAND; enter_directory"
fi

# Add folder to search PATH if it exists
for folder in $COMPOSER_HOME $HOME/.yarn/bin $HOME/bin /usr/local/bin /usr/local/sbin;
do
	if test -e "${folder}"; then
		echo $PATH | grep "$folder" &>/dev/null && true || export PATH="$PATH:$folder" # add path later in seach path if missing
	fi
done


# Node Version Manager
if test -s "/usr/local/opt/nvm/nvm.sh"; then
    mkdir -p "${NVM_HOME:-$HOME/.nvm}" || true
    source "/usr/local/opt/nvm/nvm.sh"  # This loads nvm

    if test -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm"; then
        source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    fi
fi

# Jave Env - http://www.jenv.be/ - install multiple java environments
if test -r "$HOME/.jenv"; then
	eval "$(jenv init -)" || echo "jenv failed to initialise"
fi

# Node Version Manager - Auto Complete
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
if test ! -z "${NVM_DIR}"; then
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# ===========================================================================
#		Auto Complete

# Bash Auto Complete
# bash v3 on mac doesnt support nosort option - lets ignore it https://rakhesh.com/mac/bash-complete-nosort-invalid-option-name/
[ ! -f /usr/local/etc/bash_completion ] && echo -e "missing bash-completion, try\n\tbrew install bash-completion"
# install brew bash (v5) and nosort is supported.
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion 2>&1  | sed '/^$/d'
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && source "/usr/local/etc/profile.d/bash_completion.sh" | sed '/^$/d'
