#!/usr/bin/env bash

# Setup
##
touch /tmp/shunt.file
mkdir -p /tmp/shunt.dir

# Test Examples
##

tmp_file=/tmp/shunt.file
tmp_dir=/tmp/shunt.dir
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

  assert_file "/tmp/shunt.file" "should assert file existence"
  refute_file "/tmp/shunt.bad"  "should refute file existence"

  assert_dir "/tmp/shunt.dir" "should assert directory existence"
  refute_dir "/tmp/shunt.bad" "should refute directory existence"

  # test before
  sleep 0.5 # showing Duration > 0
  assert_file "$tmp_file" "before or assert_file didn't work"
  assert "cat missing.file" "should fail, to show failure output"
}

# vim: ft=sh:
