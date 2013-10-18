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

if echo "$*" | grep "\-\-version" > /dev/null; then
  echo "$0 version $CLIUNIT_VERSION"
  exit 0
fi

__usage() {
cat << EOF
Usage: $0 <test files>

Options:
--no-color  Disable colors.
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

if echo "$options" | grep "\-\-no\-color" > /dev/null; then
  NO_COLORS=true
  options="$(echo "$options" | sed 's/--no-color//')"
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

# Colors
##
#__red=''
#__yellow=''
#__green=''
#__blue=''
#__NC=''
if ! test "$NO_COLORS"; then
  __red='\e[0;31m'
  __yellow='\e[1;33m'
  __green='\e[1;32m'
  __blue='\e[1;34m'
  __NC='\e[0m'
fi

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
function __do_pass {
  echo -ne "${__green}.${__NC}"
  __passed=`expr $__passed + 1`
}

function __do_fail {
  echo -ne "${__red}x${__NC}"
  __failed=`expr $__failed + 1`
  __failures+="$__failed] $1\n"
}

function finish {
  echo " "
  echo " "

  echo -e "${__yellow}Total: `expr $__passed + $__failed`${__NC} ${__green}Passed: $__passed${__NC} ${__red}Failed: $__failed${__NC} ${__blue}Duration: ${SECONDS} Seconds${__NC}"

  if [ "$__failed" -ne "0" ]; then
    echo " "
    echo "__failures: "
    echo " "
    echo -e "${__red}$__failures${__NC}"
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
