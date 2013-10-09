# CLIunit

##### Simple CLI Testing Pseudo-Framework

![Simple CLI Testing Pseudo-Framework](http://img59.imageshack.us/img59/1921/p319.png)

### What!? Why?

For a recent project ([Autobench](http://mervine.net/gems/autobench)), I wanted a very simple way to run some simple tests against my CLI output.
I know there are a number of these kinds of things out there, but most of the ones I looked at were more complex then I wanted.
To start, I created a basic shell script to test my CLI, but as I began to add to it, and want more from it, I decided to take
a few minutes and build a pseudo-framework out of it.

I call it a "pseudo-framework" because it's really more of a helper, which gives you a handfull of assertions to run against
bash commands. Well, that and it doesn't really have a name.

### How?

##### Install

    cd /path/to/project/tests
    wget https://raw.github.com/jmervine/CLIunit/latest/CLIunit.sh
    chmod 755 CLIunit.sh

    # or for edge updates, use:
    # https://raw.github.com/jmervine/CLIunit/master/CLIunit.sh

##### Basic Usage

A basic test file looks like this:

    #!/usr/bin/env bash
    function run_tests {
    ####################################################
    # Tests go here.
    ####################################################
      COMMAND="/path/to/your/command"
      assert_grep "$COMMAND" "Usage" \
        "deplay usage without params"
      assert_grep "$COMMAND --help" "Usage" \
        "deplay usage with help"
      assert_grep "$COMMAND --arg2 foobar" "Usage" \
        "deplay usage without required arg"
      refute_grep "$COMMAND --arg1 foobar" "Usage" \
        "work with required arg"
    ####################################################
    }
    source ./tests/CLIunit.sh

Then simply run this script: `bash ./tests/command_test.sh`

> See example.sh for more examples.

##### Assertions

Here's a full list of assertions at the time of this writing:

* `assert "CMD" "FAIL MESSAGE"`
* `refute "CMD" "FAIL MESSAGE"`
* `assert_equal "FIRST" "SECOND" "FAIL MESSAGE"`
* `refute_equal "FIRST" "SECOND" "FAIL MESSAGE"`
* `assert_numeq "FIRST" "SECOND" "FAIL MESSAGE"`
* `refute_numeq "FIRST" "SECOND" "FAIL MESSAGE"`
* `assert_grep "CMD" "GREP" "FAIL MESSAGE"`
* `refute_grep "CMD" "GREP" "FAIL MESSAGE"`
* `assert_file "FILE" "FAIL MESSAGE"`
* `refute_file "FILE" "FAIL MESSAGE"`
* `assert_dir "DIR" "FAIL MESSAGE"`
* `refute_dir "DIR" "FAIL MESSAGE"`

##### Known Issues

Currently, `assert_grep` and `refute_grep` only support a single word, no spaces. I'm sure there's a simple solution to this, but I haven't had
a change to troubleshoot it yet and it wasn't an issue for my use case.
