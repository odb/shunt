################################################################################
# Simple CLI Testing Psudo-Framework
# > http://mervine.net/simple-cli-testing-framework
#
# Assertions:
# - assert       "CMD" "FAIL MESSAGE"
# - refute       "CMD" "FAIL MESSAGE"
# - assert_equal "FIRST" "SECOND" "FAIL MESSAGE"
# - refute_equal "FIRST" "SECOND" "FAIL MESSAGE"
# - assert_numeq "FIRST" "SECOND" "FAIL MESSAGE"
# - refute_numeq "FIRST" "SECOND" "FAIL MESSAGE"
# - assert_grep  "CMD" "GREP" "FAIL MESSAGE"
# - refute_grep  "CMD" "GREP" "FAIL MESSAGE"
# - assert_file  "FILE" "FAIL MESSAGE"
# - refute_file  "FILE" "FAIL MESSAGE"
# - assert_dir   "DIR" "FAIL MESSAGE"
# - refute_dir   "DIR" "FAIL MESSAGE"
#
# Usage:
#
# 1.) Save this to a file -- e.g. `test_helper.sh`
# 2.) Create test file    -- e.g. `foo_test.sh`
# 3.) Create tests in test file, like so:
#
#  # tests must be with a `run_tests` function
#  function run_tests {
#
#    assert "pwd" "pwd not found"
#
#    assert_equal "$(pwd)" "/usr/bin"
#      "not in /usr/bin"
#
#    refute "foobar" "foobar found"
#
#    assert_grep "echo foobar" "foobar" \
#      "expected to see foobar but didn't"
#
#  }
#
# 4.) Source your `test_helper.sh` (this file) at the bottom of your test
#     file (`foo_tesh.sh`), like so:
#
#  source test_helper.sh
#
# 5.) Run your tests: `bash ./foo_tesh.sh`
#
################################################################################

# Colors

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
run_tests
finish

exit $failed

# vim: ft=sh:
