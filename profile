source ~/.bash/aliases
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/completions

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
 
if [ -f ~/.localrc ]; then
  . ~/.localrc
fi

if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi