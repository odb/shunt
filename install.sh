#!/usr/bin/env bash

set -eET

# Options
##
__usage()
{
  cat << EOF
Usage: $0 [BRANCH] [INSTALL METHOD]

 INSTALL METHOD:
    global   Install globally.
    user     Install to user. (default)
    local    Install to current directory.

 OPTIONS:
    --help     Show this message.

EOF
exit 0
}

_sudo=""
if test "$*"; then
  options="$*"
  if echo "$options" | grep "\-\-help" > /dev/null; then
    __usage
  fi
  if echo "$options" | grep "global" > /dev/null; then
    install_method=global
    options="$(echo "$options" | sed 's/global//')"
    install_path="/usr/local/bin"
    if (( UID != 0 )); then
      _sudo="sudo "
    fi
  elif echo "$options" | grep "local" > /dev/null; then
    install_method=local
    install_path="."
    options="$(echo "$options" | sed 's/local//')"
  elif echo "$options" | grep "user" > /dev/null; then
    install_method=user
    install_path="$HOME/.bin"
    options="$(echo "$options" | sed 's/user//')"
  fi
fi

# setup
##
options=$( echo $options )
test "$options" && version=$options
test "$version" || version="latest"
source="https://raw.github.com/jmervine/shunt/$version/shunt.sh"
target="shunt.sh"
execln="shunt"

# display banner
##
echo "Installing shunt"
echo "------------------"
echo " "

# check superuser if method not specified
##
if ! test "$install_method"; then
  install_method="user"
  install_path="$HOME/.bin"
  if (( UID == 0 )); then
    install_method="global"
    install_path="/usr/local/bin"
  fi
fi

# ensure install directory
##
test -d $install_path || $_sudo mkdir -p $install_path

# fetch latest
##
cd $install_path
if test -f $target; then
  echo "> Backing up previous version:"
  $_sudo mv -v $target $target.bak
  echo " "
fi
echo "> Downloading $source:"
$_sudo curl -O $source
$_sudo chmod 755 $install_path/$target

# create executable symlink
##
if [ "$install_method" != "local" ]; then
  test -L $execln || $_sudo ln -s $target $execln
  echo "> Install path: $install_path/$execln"
else
  echo "> Install path: $install_path/$target"
fi

# update path
##

export_string="\nexport PATH=$install_path:\$PATH # Add shunt to PATH"
report=false
if [ "$install_method" = "user" ]; then
  if test -f $HOME/.zshrc; then
    if ! grep "$install_path" $HOME/.zshrc 2>&1 > /dev/null; then
      echo -e "$export_string" >> $HOME/.zshrc
    fi
  elif test -f $HOME/.profile; then
    if ! grep "$install_path" $HOME/.profile 2>&1 > /dev/null; then
      echo -e "$export_string" >> $HOME/.profile
      report=true
    fi
  elif test -f $HOME/.bashrc; then
    if ! grep "$install_path" $HOME/.bashrc 2>&1 > /dev/null; then
      echo -e "$export_string" >> $HOME/.bashrc
      report=true
    fi
  else
    echo " "
    echo "WARNING: Please add $install_path to your PATH."
  fi
else
  report=false
fi

if $report; then
  echo " "
  echo "NOTE: Please log out and log back in to ensure that 'shunt' is available to your shell."
fi

echo " "
echo "DONE"
# vim: ft=sh:
