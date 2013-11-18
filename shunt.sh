#!/usr/bin/env bash
################################################################################
#
# Simple Shell Testing Psudo-Framework
# ----------------------------------
#
# Source: https://github.com/odb/shunt
# Author: Joshua Mervine (@mervinej)
#
# ----------------------------------
# Contributors:
# ----------------------------------
# - Justin Dorfman (@jdorfman)
#
################################################################################

SHUNT_VERSION="0.2.4"
if echo "$*" | grep "\-\-version" > /dev/null; then
  echo "$0 version $SHUNT_VERSION"
  exit 0
fi

__usage() {
cat << EOF
Usage: $0 <test files>

Options:
--plain    Disable colors and icons.
--quiet    Do not print error messages.
--verbose  Display success messages.
--version  Display version information.
--help     Display this message.

EOF
exit 0
}

options="$@"

# Usage - TODO: iterate of arguments
##
if echo "$options" | grep "\-h" > /dev/null; then # also matches '--help'
  __usage
fi

# Style
##
__no_style=false
if echo "$options" | grep "\-\-plain" > /dev/null; then
  __no_style=true
  options="$(echo "$options" | sed 's/--plain//')"
fi

if ! source shml.sh 2&>1 > /dev/null; then
  if ! $__no_style; then
    echo "Warning: Forcing '--plain', as shml.sh was not found."
    __no_style=true
    # implement few required from shml.sh
    #function br { echo -e "\n\r"; }
    #function i  { echo '  '; }
    #function hr { echo -e "----------------------------------"; }
  fi
fi

# quiet
##
__quiet=false
if echo "$options" | grep "\-\-quiet" > /dev/null; then
  __quiet=true
  options="$(echo "$options" | sed 's/--quiet//')"
fi

# Verbose
##
__verbose=false
if echo "$options" | grep "\-\-verbose" > /dev/null; then
  __verbose=true
  options="$(echo "$options" | sed 's/--verbose//')"
fi

# Files
##
if ! test "$options"; then __usage; fi

# Before/After function handling
##
function __ensure_handlers {
  _="$( { type before; } 2>&1 )"
  if [ "$?" -ne "0" ]; then function before { true; }; fi
  _="$( { type after; } 2>&1 )"
  if [ "$?" -ne "0" ]; then function after { true; }; fi
}

# Progress Variables
__total=0; __passed=0; __failed=0; __failures=""; __successes=""; __current=""; __last=""
################################################################################
# Assertions
################################################################################
function assert {
  local cmd=$1
  local msg="[assert] $2"
  err="$( { $cmd; } 2>&1 )"
  process "$?" "$msg" "$cmd" "$err"
  unset err # status is unavailable when err is set to local
}

function refute {
  local cmd=$1
  local msg="[refute] $2"
  _="$( { $cmd; } 2>&1)"
  [ "$?" -ne "0" ]
  process "$?" "$msg" "$cmd" "exit status is zero"
}

function assert_equal {
  local one=$1
  local two=$2
  local msg="[assert_equal] $3"
  [ "$one" = "$two" ]
  process "$?" "$msg" "" "'$one' does not equal '$two'"
}

function refute_equal {
  local one=$1
  local two=$2
  local msg="[refute_equal] $3"
  [ "$one" != "$two" ]
  process "$?" "$msg" "" "'$one' equals '$two'"
}

function assert_numeq {
  local one=$1
  local two=$2
  local msg="[assert_numeq] $3"
  [ "$one" -eq "$two" ]
  process "$?" "$msg" "" "'$one' does not equal '$two'"
}

function refute_numeq {
  local one=$1
  local two=$2
  local msg="[refute_numeq] $3"
  [ "$one" -ne "$two" ]
  process "$?" "$msg" "" "'$one' equals '$two'"
}

function assert_grep {
  local cmd=$1
  local inc=$2
  local msg="[assert_grep] $3"
  out="$( { $cmd; } 2>&1 )"
  _="$( { echo $out | grep $inc; } 2>&1 )"
  process "$?" "$msg" "$cmd" "'$out' does not include '$inc'"
  unset out
}

function refute_grep {
  local cmd=$1
  local inc=$2
  local msg="[refute_grep] $3"
  out="$( { $cmd; } 2>&1 )"
  _="$( { echo $out | grep -v $inc; } 2>&1 )"
  process "$?" "$msg" "$cmd" "'$out' includes '$inc'"
  unset out
}

function assert_file {
  local file=$1
  local msg="[assert_file] $2"
  _="$( { test -f $file; } 2>&1 )"
  process "$?" "$msg" "" "file '$file' does not exist"
}

function refute_file {
  local file=$1
  local msg="[refute_file] $2"
  _="$( { test -f $file; } 2>&1 )"
  [ "$?" -ne "0" ]
  process "$?" "$msg" "" "file '$file' exists"
}

function assert_dir {
  local dir=$1
  local msg="[assert_dir] $2"
  _="$( { test -d $dir; } 2>&1 )"
  process "$?" "$msg" "" "directory '$dir' does not exist"
}

function refute_dir {
  local dir=$1
  local msg="[refute_dir] $2"
  _="$( { test -d $dir; } 2>&1 )"
  [ "$?" -ne "0" ]
  process "$?" "$msg" "" "directory '$dir' exists"
}

################################################################################
# Utils
################################################################################
function process {
  local status=$1
  local msg=$2
  local cmd=$3
  local err=$4
  if [ "$status" -eq "0" ]; then
    __do_pass "$msg"
  else
    __do_fail "$msg" "$cmd" "$err"
  fi
}

function __do_check {
  if $__no_style; then
    echo -ne "."
  else
    echo -ne "$(color green "$(icon check)")"
  fi
}

function __do_x {
  if $__no_style; then
    echo -ne "x"
  else
    echo -ne "$(color red "$(icon x)")"
  fi
}

function __do_pass {
  local msg=$1
  __total=$(expr $__total + 1)
  __passed=$(expr $__passed + 1)
  if $__verbose; then
    echo "$__total. $(__do_color green "$msg passed")"
  else
    __do_check
  fi
}

function __do_fail {
  local msg=$1
  local cmd=$2
  local err=$3
  __total=$(expr $__total + 1)
  __failed=$(expr $__failed + 1)

  if $__verbose; then
    echo "$__total. $(__do_color red "$msg failed")"
  else
    __do_x
  fi

  if [ "$__last" != "$__current" ]; then
    __failures+="$(br)$__current$(br)"
    __last=$__current
  fi

  __failures+="$(__do_color red "$__total. $msg")$(br)"
  if test "$err" && ! $__quiet; then
    if test "$cmd"; then
      __failures+="$(__do_color yellow "$(i 2)'$cmd' failed with:$(br)$(i 2)")"
    fi
    __failures+="$(__do_color yellow "$(i 2) $err$(br)$(br)")"
  fi
}

function __do_color {
  if $__no_style; then
    echo "$2"
  else
    echo "$(color $1 "$2")"
  fi
}

function __failures {
  if [ "$__failed" -ne 0 ] && ! $__quiet; then
    echo "$(br)$(br)Failures:$(br)$(hr)$(br)$__failures"
  else
    echo " "
  fi
}

function __finish {
  __failures
  if $__verbose; then echo -n "$(hr)"; fi
  if $__quiet; then echo " "; fi
  echo "$(__do_color yellow "$(br)Total: $(expr $__passed + $__failed)")  $(__do_color green "Passed: $__passed")  $(__do_color red "Failed: $__failed")  $(__do_color blue "Duration: ${SECONDS} Seconds")$(br)"
}

function __reset {
  unset before
  unset after
}

function __shunt {
  __ensure_handlers
  before
  run_tests
  after
}

################################################################################
# Make is so.
################################################################################

echo "$(basename -- $0) $@"
if $__verbose; then echo "$(hr '=')"; fi
echo " "

# In an edge case, a test changes directory. It needs to be changed
# back after the test.
#######
here="$(pwd)"

for __current in $options; do
  __reset
  source $__current
  if $__verbose; then echo "$(br)$__current$(br)$(hr)$(br)"; fi
  __shunt
  cd $here
done

__finish
exit $__failed

# vim: ft=sh:
