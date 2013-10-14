#!/usr/bin/env bash

# Setup
##
touch /tmp/cliunit.file
mkdir -p /tmp/cliunit.dir

# Test Examples
##

tmp_file=/tmp/cliunit.file
tmp_dir=/tmp/cliunit.dir
function before {
  touch $tmp_file
  mkdir -p $tmp_dir
}

function after {
  echo -e "\n\nIf you see this, after worked."
  rm -rf $tmp_file $tmp_dir
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

  # test before
  assert_file "$tmp_file" "before or assert_file didn't work"
}

# vim: ft=sh:
