#!/usr/bin/env bash

# Setup
##
touch /tmp/cliunit.file
mkdir -p /tmp/cliunit.dir

# Test Examples
##

before_check=false
function before {
  before_check=true
}

function after {
  echo "If you see this, after worked."
}

function run_tests {

  assert "true"  "should assert truth"
  refute "false" "should refute truth"

  assert_equal "true" "true" "should assert equality"
  refute_equal "true" "false" "should refute equality"

  assert_numeq "1111" "1111" "should assert numerical equality"
  refute_numeq "1111" "1112" "should refute numerical equality"

  assert_grep "echo foobar" "foobar" "should assert via grep"
  refute_grep "echo foobar" "notfoobar" "should refute via grep"

  assert_file "/tmp/cliunit.file" "should assert file existence"
  refute_file "/tmp/cliunit.bad"  "should refute file existence"

  assert_dir "/tmp/cliunit.dir" "should assert directory existence"
  refute_dir "/tmp/cliunit.bad" "should refute directory existence"

  sleep 0.5 # showing Duration > 0

  assert "false" "should fail, to show failure output"

  assert "$before_check" "before failed"
}
source ./CLIunit.sh

