#!/usr/bin/env bash

# Load RVM, if you are using it
#source ~/.profile

# source /Users/prabin_varma/.dnx/dnvm/dnvm.sh

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

#export $PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH

# Enable ctrl-s for incremental search
stty -ixon

# Add rvm gems and nginx to the path
export PATH=$PATH:/opt/nginx/sbin

# Add Postgres SQL bin to the path
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin


# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='sexy'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Set the path nginx
export NGINX_PATH='/opt/nginx'

# Set the path FIREFOX_BIN
export FIREFOX_BIN='/Applications/FirefoxDeveloperEdition.app/Contents/MacOS/firefox-bin'

# Add elixir bin to the path
export PATH="$PATH:/path/to/elixir/bin"

# Erase duplicate entries in history
export HISTCONTROL=ignoreboth:erasedup

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.

export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli

export TODO="t"

# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

# Android SDK tools path
PATH="~/Library/Android/sdk/tools:~/Library/Android/sdk/platform-tools:${PATH}"
export PATH

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# GO workspace path
export GOPATH=$HOME/Documents/Github/go-projects

# Load Bash It
source $BASH_IT/bash_it.sh

# Add the ssh private key
ssh-add ~/.ssh/id_rsa

# nvm bash completion
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

# Use hub for enhanced git functionality
eval "$(hub alias -s)"

# Python commands
alias cwd='pwd'

alias sourcetree='open -a SourceTree'
# git commands
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gf='git fetch'
alias gm='git merge'
alias gr='git rebase'
alias grh='git reset --hard HEAD'
alias gs='git status'
alias gt='git tag'
alias dt='git difftool'
alias mt='git mergetool'
alias co='git checkout'
alias pull='git pull'
alias push='git push'
alias cm commit -m
alias unstage reset HEAD --
alias alias config --get-regexp alias
alias discard reset HEAD --hard
alias cam commit -am
alias camp !camp() { git add . && git commit -m “$@” && git push; }; camp

#hubflow commands
alias fstart='git hf feature start'
alias ffin='git hf feature finish'
alias fco='git hf feature checkout'
alias pr='git pull-request -b develop'

# compass commands
alias cw='compass watch'
alias cc='compass compile --force'

# Function aliases
alias sq=squash
alias cb=current_branch

alias gi='echo -e "node_modules/\nbower_components/" > .gitignore'

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

function gradled() {
  old_gradle_opts="$GRADLE_OPTS"
  export GRADLE_OPTS="$GRADLE_OPTS -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=9999,server=y,suspend=y"
  gradle $@
  export GRADLE_OPTS="$old_gradle_opts"
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

alias app-reset=reset_npm_installed

function reset_npm_installed() {
   if [ -d "node_modules" ]; then
    rm -rf node_modules
   fi
   rm -rf node_modules
   if [ -d "bower_components" ]; then
    rm -rf bower_components
   fi
   if [ -d "app/bower_components" ]; then
    rm -rf app/bower_components
   fi
   npm install
}

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

function shortwd() {
num_dirs=3
pwd_symbol="..."
newPWD="${PWD/#$HOME/~}"
if [ $(echo -n $newPWD | awk -F '/' '{print NF}') -gt $num_dirs ]; then
newPWD=$(echo -n $newPWD | awk -F '/' '{print $1 "/.../" $(NF-1) "/" $(NF)}')
fi
echo -n $newPWD
}

function up () {
    cd `expr "$PWD" : "^\(.*$1[^/]*\)"`
}

function code {
    if [[ $# = 0 ]]
    then
        open -a "Visual Studio Code"
    else
        local argPath="$1"
        [[ $1 = /* ]] && argPath="$1" || argPath="$PWD/${1#./}"
        open -a "Visual Studio Code" "$argPath"
    fi
}

function terminate() {
  if [[ $# = 0 ]]
  then
      ECHO 'Please specify a port e.g. `terminate 8080`'
  else
    ECHO 'Terminating process on port '$1
    lsof -P | grep ':'$1 | awk '{print $2}' | xargs kill -9
  fi
}

function mkcd () {
  case "$1" in
    */..|*/../) cd -- "$1";; # that doesn't make any sense unless the directory already exists
    /*/../*) (cd "${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd -- "$1";;
    /*) mkdir -p "$1" && cd "$1";;
    */../*) (cd "./${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd "./$1";;
    ../*) (cd .. && mkdir -p "${1#.}") && cd "$1";;
    *) mkdir -p "./$1" && cd "./$1";;
  esac
}
PS1='\n\n\e[0;36m$(shortwd)\e[0;32m$(__git_ps1)\n\e[1;30m$(date +%H:%M) \e[0m$'
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM='verbose git'
export PS1 GIT_PS1_SHOWDIRTYSTATE GIT_PS1_SHOWUPSTREAMexport PATH=/usr/local/bin:$PATH

test -r /sw5/bin/init.sh && . /sw5/bin/init.sh

##
# Your previous /Users/prabin_varma/.bash_profile file was backed up as /Users/prabin_varma/.bash_profile.macports-saved_2014-12-03_at_09:55:40
##

# MacPorts Installer addition on 2014-12-03_at_09:55:40: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

source /usr/local/lib/dnx/bin/dnvm.sh

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
export PATH="/usr/local/sbin:$PATH"