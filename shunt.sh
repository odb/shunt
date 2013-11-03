#!/usr/bin/env bash
################################################################################
#
# Simple Shell Testing Psudo-Framework
# ----------------------------------
#
# Source: https://github.com/jmervine/shunt
# Author: Joshua Mervine (@mervinej)
#
# ----------------------------------
# Contributors:
# ----------------------------------
# - Justin Dorfman (@jdorfman)
#
################################################################################

SHUNT_VERSION="0.1.2"

# Including an
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
#     NOTE: clistyle is a working title and may
#     change at any time.
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

options="$*"

# Usage - TODO: iterate of arguments
##
if ! test "$options"; then
  __usage
fi

if echo "$options" | grep "\-\-help" > /dev/null; then
  __usage
fi

if echo "$options" | grep "\-h" > /dev/null; then
  __usage
fi

# Style
##
__no_style=false
if echo "$options" | grep "\-\-plain" > /dev/null; then
  __no_style=true
  options="$(echo "$options" | sed 's/--plain//')"
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

# Before/After function handling
##
function __ensure_handlers {
  _="$( { type before; } 2>&1 )"
  if [ "$?" -ne "0" ]; then
    function before {
      true
    }
  fi

  _="$( { type after; } 2>&1 )"
  if [ "$?" -ne "0" ]; then
    function after {
      true
    }
  fi
}

# Progress Variables
__total=0; __passed=0; __failed=0; __failures=""; __successes=""

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
  process "$?" "$msg" "$cmd" "non-zero exit status"
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
  _="$( { $cmd | grep $inc; } 2>&1 )"
  process "$?" "$msg" "" "'$cmd' does not include '$inc'"
}

function refute_grep {
  local cmd=$1
  local inc=$2
  local msg="[refute_grep] $3"
  _="$( { $cmd | grep -v $inc; } 2>&1 )"
  process "$?" "$msg" "" "'$cmd' includes '$inc'"
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
  __total=`expr $__total + 1`
  __passed=`expr $__passed + 1`
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
  __total=`expr $__total + 1`
  __failed=`expr $__failed + 1`

  if $__verbose; then
    echo "$__total. $(__do_color red "$msg failed")"
  else
    __do_x
  fi

  __failures+="$(__do_color red "$__failed. $msg")$(br)"
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

function finish {
  echo -e "$(br)$(br)$(__do_color yellow "Total: `expr $__passed + $__failed`") $(__do_color green "Passed: $__passed") $(__do_color red "Failed: $__failed") $(__do_color blue "Duration: ${SECONDS} Seconds")$(br)"
  if [ "$__failed" -ne "0" ] && ! $__quiet; then
    echo -e "Failures:$(br)$__failures"
  fi
}

function __reset {
  unset before
  unset after
  unset __passed
  unset __failed
  unset __failures
}

function __shunt {
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
    __shunt
  done
else
  echo "(Running from: $PWD)"
  __shunt
fi

exit $__failed

# vim: ft=sh:
