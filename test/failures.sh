#!/usr/bin/env bash

function run_tests {
  assert "grep foo asdf" "assertion to fail"
  refute "grep foo ./foo.sh" "assertion to fail"

  assert_equal "true" "false" "assertion to fail"
  refute_equal "true" "true" "assertion to fail"

  assert_numeq "1" "2" "assertion to fail"
  refute_numeq "1" "1" "assertion to fail"

  assert_grep "echo foobarbah" "asdf" "assertion to fail"
  refute_grep "echo foobarbah" "bar" "assertion to fail"

  assert_file "asdf" "assertion to fail"
  refute_file "./CLIunit.sh" "assertion to fail"

  assert_dir "asdf" "assertion to fail"
  refute_dir "./test" "assertion to fail"
}
