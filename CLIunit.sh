#!/usr/bin/env bash
################################################################################
#
# Simple CLI Testing Psudo-Framework
# ----------------------------------
#
# Source: https://github.com/jmervine/CLIunit
# Author: Joshua Mervine (@mervinej)
#
# ----------------------------------
# Contributors:
# ----------------------------------
# - Justin Dorfman (@jdorfman)
#
################################################################################

CLIUNIT_VERSION="0.1.1"

# Update version with `make clistyle`
#CLISTYLE:START
#************************************************#
#    CLIstyle - Style Framework for The Terminal
#                    Beta
#        by Justin Dorfman - @jdorfman
#        && Joshua Mervine - @mervinej
#
#               Inspired by:
#
#       Kiyor Cia, Jeff Foard FLOZz' MISC,
#           Mark Otto & Dave Gandy
#
#
#     https://github.com/jdorfman/clistyle
#************************************************#

# Foreground (Text)
##
function color {
  local __end='\033[39m'
  local __color=$__end # end by default
  case "$1" in
    end|off|reset)       __color=$__end;;
    black|000000)        __color='\033[30m';;
    red|F00BAF)          __color='\033[31m';;
    green|00CD00)        __color='\033[32m';;
    yellow|CDCD00)       __color='\033[33m';;
    blue|0286fe)         __color='\033[34m';;
    magenta|e100cc)      __color='\033[35m';;
    cyan|00d3cf)         __color='\033[36m';;
    gray|e4e4e4)         __color='\033[90m';;
    darkgray|4c4c4c)     __color='\033[91m';;
    lightgreen|00fe00)   __color='\033[92m';;
    lightyellow|f8fe00)  __color='\033[93m';;
    lightblue|3a80b5)    __color='\033[94m';;
    lightmagenta|fe00fe) __color='\033[95m';;
    lightcyan|00fefe)    __color='\033[96m';;
    white|ffffff)        __color='\033[97m';;
  esac
  if test "$2"; then
    echo -en "$__color$2$__end"
  else
    echo -en "$__color"
  fi
}
function c {
  color "$@"
}

# Background
##
function background {
  local __end='\033[49m'
  local __color=$__end # end by default
  case "$1" in
    end|off|reset)       __color=$__end;;
    black|000000)        __color='\033[40m';;
    red|F00BAF)          __color='\033[41m';;
    green|00CD00)        __color='\033[42m';;
    yellow|CDCD00)       __color='\033[43m';;
    blue|0286fe)         __color='\033[44m';;
    magenta|e100cc)      __color='\033[45m';;
    cyan|00d3cf)         __color='\033[46m';;
    gray|e4e4e4)         __color='\033[47m';;
    darkgray|4c4c4c)     __color='\033[100m';;
    lightred)            __color='\033[101m';;
    lightgreen|00fe00)   __color='\033[102m';;
    lightyellow|f8fe00)  __color='\033[103m';;
    lightblue|3a80b5)    __color='\033[104m';;
    lightmagenta|fe00fe) __color='\033[105m';;
    lightcyan|00fefe)    __color='\033[106m';;
    white|fffff)         __color='\033[107m';;
  esac

  if test "$2"; then
    echo -en "$__color$2$__end"
  else
    echo -en "$__color"
  fi
}
function bg {
  background "$@"
}

## Color Bar
function color-bar {
  if test "$2"; then
    for i in "$@"; do
      echo -en "`background "$i" " "`"
    done; echo
  else
    for i in {16..21}{21..16}; do
      echo -en "\033[48;5;${i}m \033[0m"
    done; echo
  fi
}
function bar {
  color-bar "$@"
}

## Attributes
##
function attribute {
  local __end='\033[0m'
  local __attr=$__end # end by default
  case "$1" in
    end|off|reset) __attr=$__end;;
    bold)          __attr='\033[1m';;
    dim)           __attr='\033[2m';;
    italic)        __attr='\033[4m';;
    blink)         __attr='\033[5m';;
    invert)        __attr='\033[7m';;
    hidden)        __attr='\033[8m';;
  esac
  if test "$2"; then
    echo -en "$__attr$2$__end"
  else
    echo -en "$__attr"
  fi
}
function a {
  attribute "$@"
}

## Elements
function br {
  echo '\n'
}

function tab {
  echo '\t'
}

function indent {
  local __len=4
  if test "$1"; then
    if [[ $1 =~ $re ]] ; then
      __len=$1
    fi
  fi
  while [ $__len -gt 0 ]; do
    echo -n " "
     __len=$(( $__len - 1 ))
  done
}
function i {
  indent "$@"
}

function hr {
  local __len=60
  local __char='-'
  if ! test "$2"; then
    re='^[0-9]+$'
    if [[ $1 =~ $re ]] ; then
      __len=$1
    elif test "$1"; then
      __char=$1
    fi
  else
    __len=$2
    __char=$1
  fi
  while [ $__len -gt 0 ]; do
    echo -n "$__char"
     __len=$(( $__len - 1 ))
  done
}

# Icons
#
# TODO: Replace with codes.
##
function icon {
  case "$1" in
    check|checkmark)       echo -n '✓';;
    X|x|xmark)             echo -n '✘';;
    '<3'|heart)            echo -n '❤';;
    sun)                   echo -n '☀';;
    '*'|star)              echo -n '★';;
    darkstar)              echo -n '☆';;
    umbrella)              echo -n '☂';;
    flag)                  echo -n '⚑';;
    snow|snowflake)        echo -n '❄';;
    music)                 echo -n '♫';;
    scissors)              echo -n '✂';;
    tm|trademark)          echo -n '™';;
    copyright)             echo -n '©';;
    apple)                 echo -n '';;
    ':-)'|':)'|smile|face) echo -n '☺';;
  esac
}

#CLISTYLE:END

if echo "$*" | grep "\-\-version" > /dev/null; then
  echo "$0 version $CLIUNIT_VERSION"
  exit 0
fi

__usage() {
cat << EOF
Usage: $0 <test files>

Options:
--no-style  Disable colors and icons.
--version   Display version information.
--help      Display this message.

EOF
exit 0
}

options="$*"
if echo "$options" | grep "\-\-help" > /dev/null; then
  __usage
fi

if echo "$options" | grep "\-h" > /dev/null; then
  __usage
fi

NO_STYLE=false
if echo "$options" | grep "\-\-no\-style" > /dev/null; then
  NO_STYLE=true
  options="$(echo "$options" | sed 's/--no-style//')"
fi

# Before/After function handling
##
function __ensure_handlers {
  type before 2>&1 > /dev/null
  if [ "$?" -ne "0" ]; then
    function before {
      true
    }
  fi

  type after 2>&1 > /dev/null
  if [ "$?" -ne "0" ]; then
    function after {
      true
    }
  fi
}

# Progress Variables
__passed=0
__failed=0
__failures=""

################################################################################
# Assertions
################################################################################
function assert {
  cmd=$1 # what to run
  msg=$2 # what to say on fail

  $cmd 2>&1 > /dev/null
  process "$?" "$msg"
}

function refute {
  cmd=$1 # what to run
  msg=$2 # what to say on fail

  $cmd 2>&1 > /dev/null
  [ "$?" -ne "0" ]
  process "$?" "$msg"
}

function assert_equal {
  one=$1 # what to run
  two=$2 # what to run
  msg=$3 # what to say on fail

  [ "$one" = "$two" ]
  process "$?" "$msg"
}

function refute_equal {
  one=$1 # what to run
  two=$2 # what to run
  msg=$3 # what to say on fail

  [ "$one" != "$two" ]
  process "$?" "$msg"
}

function assert_numeq {
  one=$1 # what to run
  two=$2 # what to run
  msg=$3 # what to say on fail

  [ "$one" -eq "$two" ]
  process "$?" "$msg"
}

function refute_numeq {
  one=$1 # what to run
  two=$2 # what to run
  msg=$3 # what to say on fail

  [ "$one" -ne "$two" ]
  process "$?" "$msg"
}

function assert_grep {
  cmd=$1 # what to run
  inc=$2 # what to grep for
  msg=$3 # what to say on fail

  $cmd | grep $inc 2>&1 > /dev/null
  process "$?" "$msg"
}

function refute_grep {
  cmd=$1 # what to run
  inc=$2 # what to grep for
  msg=$3 # what to say on fail

  $cmd | grep -v $inc 2>&1 > /dev/null
  process "$?" "$msg"
}

function assert_file {
  file=$1 # file to check
  msg=$2  # what to say on fail

  test -f $file 2>&1 > /dev/null
  process "$?" "$msg"
}

function refute_file {
  file=$1 # file to check
  msg=$2  # what to say on fail

  test -f $file 2>&1 > /dev/null
  [ "$?" -ne "0" ]
  process "$?" "$msg"
}

function assert_dir {
  dir=$1 # dir to check
  msg=$2  # what to say on fail

  test -d $dir 2>&1 > /dev/null
  process "$?" "$msg"
}

function refute_dir {
  dir=$1 # dir to check
  msg=$2  # what to say on fail

  test -d $dir 2>&1 > /dev/null
  [ "$?" -ne "0" ]
  process "$?" "$msg"
}


################################################################################
# Utils
################################################################################
function process {
  status=$1
  msg=$2
  if [ "$status" -eq "0" ]; then
    __do_pass
  else
    __do_fail "$msg"
  fi
}

function __do_check {
  if $NO_STYLE; then
    echo -ne "."
  else
    echo -ne "$(color green "$(icon check)")"
  fi
}

function __do_x {
  if $NO_STYLE; then
    echo -ne "x"
  else
    echo -ne "$(color red "$(icon x)")"
  fi
}

function __do_pass {
  __do_check
  __passed=`expr $__passed + 1`
}

function __do_fail {
  __do_x
  __failed=`expr $__failed + 1`
  __failures+="$__failed] $1\n"
}

function __do_color {
  if $NO_STYLE; then
    echo "$2"
  else
    echo "$(color $1 "$2")"
  fi
}

function finish {
  echo " "
  echo " "

  echo -e "$(__do_color yellow "Total: `expr $__passed + $__failed`") $(__do_color green "Passed: $__passed") $(__do_color red "Failed: $__failed") $(__do_color blue "Duration: ${SECONDS} Seconds")"

  if [ "$__failed" -ne "0" ]; then
    echo " "
    echo "Failures: "
    echo " "
    echo -e "$(__do_color red "$__failures")"
  fi
  echo " "
}

function __reset {
  unset before
  unset after
  unset __passed
  unset __failed
  unset __failures
}

function __CLIunit {
  __ensure_handlers
  before
  run_tests
  after
  finish
  __reset
}

################################################################################
# Make is so.
################################################################################
if test "$options"; then
  for f in $options; do
    echo "(Running $f from: $PWD)"
    source $f
    __CLIunit
  done
else
  echo "(Running from: $PWD)"
  __CLIunit
fi

exit $__failed

# vim: ft=sh:
