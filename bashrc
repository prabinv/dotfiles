# Python commands
alias cwd='pwd'

# git commands
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gf='git fetch'
alias gm='git merge'
alias gr='git rebase'
alias gs='git status'
alias gt='git tag'
alias dt='git difftool'
alias mt='git mergetool'
alias co='git checkout'
alias pull='git pull'
alias push='git push'

# compass commands
alias cw='compass watch'
alias cc='compass compile --force'

# Function aliases
alias sq=squash
alias cb=current_branch

# Functions
function squash() {
    git rebase -i HEAD~$1
}

function current_branch() {
    gb 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function blam() {
    push origin $(cb) $@
}

function sync() {
    gf --multiple origin upstream
    this_branch=$(cb)
    co master && pull && blam && gs
    co $this_branch
}

function rebase() {
    sync && gr master
}

function track_upstream_master() {
    git fetch upstream
    git config branch.master.remote upstream
    git config branch.master.merge refs/heads/master
    pull
}

function docker_ip() {
  boot2docker ip 2> /dev/null
}

#alias gc=codepaint_git_commit
#codepaint_git_commit() {
#    # 1. Gets a list of .js files in git staging and sends the list to CodePainter.
#    # 2. CodePainter with the -e flag applies rules defined in your EditorConfig file(s).
#    # 3. After CodePainter is done, your args are passed to the `git commit` command.
#    codepaint xform -e $(git diff --name-only --cached | egrep '\.js$') && git commit -m "$@"
#}

alias patch=npm_version_patch
function npm_version_patch() {
    npm version patch -m "Patch version: %s"
    blam && blam --tags
    npm publish
}

alias minor=npm_version_minor
function npm_version_minor() {
    npm version minor -m "Minor version: %s"
    blam && blam --tags
    npm publish
}

function npm_blam() {
    blam && blam --tags
    npm publish
}

function npm_uninstall_all() {
    for package in `ls node_modules`; do npm uninstall $package; done;
}

function terminate() {
  lsof -P | grep ':9000' | awk '{print $2}' | xargs kill -9
}

function shortwd() {
    num_dirs=3
    pwd_symbol="..."
    newPWD="${PWD/#$HOME/~}"
    if [ $(echo -n $newPWD | awk -F '/' '{print NF}') -gt $num_dirs ]; then
        newPWD=$(echo -n $newPWD | awk -F '/' '{print $1 "/.../" $(NF-1) "/" $(NF)}')
    fi
    echo -n $newPWD
}

PS1='\n\n\e[0;36m$(shortwd)\e[0;32m$(__git_ps1)\n\e[1;30m$(date +%H:%M) \e[0m$'
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM='verbose git'
export PS1 GIT_PS1_SHOWDIRTYSTATE GIT_PS1_SHOWUPSTREAM
# added by travis gem
[ -f /Users/prabin_varma/.travis/travis.sh ] && source /Users/prabin_varma/.travis/travis.sh

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export NVM_DIR="/Users/prabin_varma/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
