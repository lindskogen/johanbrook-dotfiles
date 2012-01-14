source $HOME/.bash/env
source $HOME/.bash/aliases
source $HOME/.bash/paths
source $HOME/.bash/prompt
source $HOME/.bash/completions

if [ -f $HOME/.bashrc ]; then
  . $HOME/.bashrc
fi
 
if [ -f $HOME/.localrc ]; then
  . $HOME/.localrc
fi

if [ -f $HOME/.profile ]; then
  . $HOME/.profile
fi