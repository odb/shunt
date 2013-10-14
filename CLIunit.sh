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

# Before/After function handling
##
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

# Colors
##
if ! test "$NO_COLORS"; then
  red='\e[0;31m'
  yellow='\e[1;33m'
  green='\e[1;32m'
  blue='\e[1;34m'
  NC='\e[0m'
fi

# Progress Variables
passed=0
failed=0
failures=""

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
    do_pass
  else
    do_fail "$msg"
  fi
}
function do_pass {
  echo -ne "${green}.${NC}"
  passed=`expr $passed + 1`
}

function do_fail {
  echo -ne "${red}x${NC}"
  failed=`expr $failed + 1`
  failures+="$failed] $1\n"
}

function finish {
  echo " "
  echo " "

  echo -e "${yellow}Total: `expr $passed + $failed`${NC} ${green}Passed: $passed${NC} ${red}Failed: $failed${NC} ${blue}Duration: ${SECONDS} Seconds${NC}"

  if [ "$failed" -ne "0" ]; then
    echo " "
    echo "Failures: "
    echo " "
    echo -e "${red}$failures${NC}"
  fi
  echo " "
}

################################################################################
# Make is so.
################################################################################
echo "(Running from: $PWD)"
before
run_tests
finish
after

exit $failed

# vim: ft=sh:
