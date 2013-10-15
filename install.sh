#!/usr/bin/env bash

set -eET

# setup
##
test "$1" && version=$1
test "$version" || version="latest"
source="https://raw.github.com/jmervine/CLIunit/$version/CLIunit.sh"
target="CLIunit.sh"
execln="cliunit"

# display banner
##
echo -e "Installing CLIunit\n\n"

# check superuser
##
install_path="$HOME/.bin"
if (( UID == 0 )); then
  install_path=/usr/local/bin
fi

# ensure install directory
##
test -d $install_path || mkdir -p $install_path

# ensure download method
##
if which wget 2>&1 > /dev/null; then
  dldr="wget"
elif which curl 2>&1 > /dev/null; then
  dldr="curl -O"
else
  echo "I need wget or curl to complete installation."
  exit 1
fi

# fetch latest
##
cd $install_path
if test -f $target; then
  echo "Backing up previous version:"
  mv -v $target $target.bak
  echo " "
fi
echo "Downloading $version:"
$dldr $source
chmod 755 $install_path/$target

# create executable symlink
##
test -L $execln || ln -s $target $execln

# update path
##

export_string="\nexport PATH=$install_path:\$PATH # Add CLIunit to PATH"
report=true
if (( UID == 0 )); then
  if test -d /etc/profile.d/; then
    echo -e "$export_string" > /etc/profile.d/cliunit
  elif test -f /etc/profile; then
    if ! grep "$install_path" /etc/profile 2>&1 > /dev/null; then
      echo -e "$export_string" >> /etc/profile
    fi
  elif test -f /etc/bashrc; then
    if ! grep "$install_path" /etc/bashrc 2>&1 > /dev/null; then
      echo -e "$export_string" >> /etc/bashrc
    fi
  else
    report=false
    echo "Please add $install_path to your PATH."
  fi
else
  if test -f $HOME/.zshrc; then
    if ! grep "$install_path" $HOME/.zshrc 2>&1 > /dev/null; then
      echo -e "$export_string" >> $HOME/.zshrc
    fi
  elif test -f $HOME/.profile; then
    if ! grep "$install_path" $HOME/.profile 2>&1 > /dev/null; then
      echo -e "$export_string" >> $HOME/.profile
    fi
  elif test -f $HOME/.bashrc; then
    if ! grep "$install_path" $HOME/.bashrc 2>&1 > /dev/null; then
      echo -e "$export_string" >> $HOME/.bashrc
    fi
  else
    report=false
    echo "Please add $install_path to your PATH."
  fi
fi

if $report; then
  echo "Please log out and log back in to ensure that 'cliunit' is available to your shell."
fi
# vim: ft=sh:
