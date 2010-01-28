source $HOME/.bash/aliases
source $HOME/.bash/paths
source $HOME/.bash/config
source $HOME/.bash/completions

if [ -f $HOME/.bashrc ]; then
  . $HOME/.bashrc
fi
 
if [ -f $HOME/.localrc ]; then
  . $HOME/.localrc
fi

if [ -f $HOME/.bash_profile ]; then
  . $HOME/.bash_profile
fi