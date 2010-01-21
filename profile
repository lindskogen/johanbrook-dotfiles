source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
 
if [ -f ~/.localrc ]; then
  . ~/.localrc
fi

if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi