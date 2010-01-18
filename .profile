alias tMovies="scp ~/Downloads/*.torrent debby.zapto.org:~/Downloads/Movies/ && rm -rf ~/Downloads/*.torrent"
alias tProgram="scp ~/Downloads/*.torrent debby.zapto.org:~/Downloads/Program/ && rm -rf ~/Downloads/*.torrent"
alias tRandom="scp ~/Downloads/*.torrent debby.zapto.org:~/Downloads/Random/ && rm -rf ~/Downloads/*.torrent"
alias pym="python manage.py"
alias sc="ssh debby.zapto.org"
#. /Library/Python/2.6/site-packages/bash_completion/django_bash_completion
PATH=${PATH}:/usr/local/mysql/bin
export PATH=${PATH}:/Developer/android-sdk-mac_x86-1.5_r3/tools
export PYTHONPATH=/Library/Frameworks/Python.framework/Versions/2.6/lib/python2.6/site-packages/

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       WHITE="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       GREEN="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac

PS1="${TITLEBAR}\
$BLUE[$RED\$(date +%H:%M)$BLUE]\
$BLUE[$RED\u@\h:\w$GREEN\$(parse_git_branch)$BLUE]\
$GREEN\$ "
PS2='> '
PS4='+ '
}
proml
# ENV['AUTOFEATURE'] = "true"
# ENV['RSPEC'] = "true"