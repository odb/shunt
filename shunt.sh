#!/usr/bin/env bash
################################################################################
#
# Simple Shell Testing Psudo-Framework
# ----------------------------------
#
# Source: https://github.com/odb/shunt
# Author: Joshua Mervine (@mervinej)
#
# ----------------------------------
# Contributors:
# ----------------------------------
# - Justin Dorfman (@jdorfman)
#
################################################################################

SHUNT_VERSION="0.2.5"

# Including an
# Update version with `make shml`
#SHML:START
#************************************************#
#    SHML - Shell Markup Language Framework
#                   v1.0.3
#                    (MIT)
#        by Justin Dorfman - @jdorfman
#        && Joshua Mervine - @mervinej
#
#        https://maxcdn.github.io/shml/
#************************************************#

# Foreground (Text)
##
fgcolor() {
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

# Backwards Compatibility
color() {
  fgcolor "$@"
}

# Aliases
fgc() {
  fgcolor "$@"
}

c() {
  fgcolor "$@"
}

# Background
##
bgcolor() {
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

#Backwards Compatibility
background() {
  bgcolor "$@"
}

#Aliases
bgc() {
  bgcolor "$@"
}

bg() {
  bgcolor "$@"
}

## Color Bar
color-bar() {
  if test "$2"; then
    for i in "$@"; do
      echo -en "$(background "$i" " ")"
    done; echo
  else
    for i in {16..21}{21..16}; do
      echo -en "\033[48;5;${i}m \033[0m"
    done; echo
  fi
}

#Alises
cb() {
  color-bar "$@"
}

bar() {
  color-bar "$@"
}

## Attributes
##
attribute() {
  local __end='\033[0m'
  local __attr=$__end # end by default
  case "$1" in
    end|off|reset) __attr=$__end;;
    bold)          __attr='\033[1m';;
    dim)           __attr='\033[2m';;
    underline)     __attr='\033[4m';;
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
a() {
  attribute "$@"
}

## Elements
br() {
  echo -e "\n\r"
}

tab() {
  echo -e "\t"
}

indent() {
  local __len=4
  local __int='^[0-9]+$'
  if test "$1"; then
    if [[ $1 =~ $__int ]] ; then
      __len=$1
    fi
  fi
  while [ $__len -gt 0 ]; do
    echo -n " "
     __len=$(( $__len - 1 ))
  done
}
i() {
  indent "$@"
}

hr() {
  local __len=60
  local __char='-'
  local __int='^[0-9]+$'
  if ! test "$2"; then
    if [[ $1 =~ $__int ]] ; then
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
##

icon() {
  local i='';
  case "$1" in
    check|checkmark)       i='\xE2\x9C\x93';;
    X|x|xmark)             i='\xE2\x9C\x98';;
    '<3'|heart)            i='\xE2\x9D\xA4';;
    sun)                   i='\xE2\x98\x80';;
    '*'|star)              i='\xE2\x98\x85';;
    darkstar)              i='\xE2\x98\x86';;
    umbrella)              i='\xE2\x98\x82';;
    flag)                  i='\xE2\x9A\x91';;
    snow|snowflake)        i='\xE2\x9D\x84';;
    music)                 i='\xE2\x99\xAB';;
    scissors)              i='\xE2\x9C\x82';;
    tm|trademark)          i='\xE2\x84\xA2';;
    copyright)             i='\xC2\xA9';;
    apple)                 i='\xEF\xA3\xBF';;
    skull|bones)           i='\xE2\x98\xA0';;
    ':-)'|':)'|smile|face) i='\xE2\x98\xBA';;
    *)
      entity $1; return 0;;
  esac
  echo -ne "$i";
}
emoji() {
  local i=""
  case "$1" in

    1F603|smiley|'=)'|':-)'|':)')    i='😃';;
    1F607|innocent|halo)             i='😇';;
    1F602|joy|lol|laughing)          i='😂';;
    1F61B|tongue|'=p'|'=P')          i='😛';;
    1F60A|blush|'^^'|blushing)       i='😊';;
    1F61F|worried|sadface|sad)       i='😟';;
    1F622|cry|crying|tear)           i='😢';;
    1F621|rage|redface)              i='😡';;
    1F44B|wave|hello|goodbye)        i='👋';;
    1F44C|ok_hand|perfect|okay|nice) i='👌';;
    1F44D|thumbsup|+1|like)          i='👍';;
    1F44E|thumbsdown|-1|no|dislike)  i='👎';;
    1F63A|smiley_cat|happycat)       i='😺';;
    1F431|cat|kitten|:3|kitty)       i='🐱';;
    1F436|dog|puppy)                 i='🐶';;
    1F41D|bee|honeybee|bumblebee)    i='🐝';;
    1F437|pig|pighead)               i='🐷';;
    1F435|monkey_face|monkey)        i='🐵';;
    1F42E|cow|happycow)              i='🐮';;
    1F43C|panda_face|panda|shpanda)  i='🐼';;
    1F363|sushi|raw|sashimi)         i='🍣';;
    1F3E0|home|house)                i='🏠';;
    1F453|eyeglasses|bifocals)       i='👓';;
    1F6AC|smoking|smoke|cigarette)   i='🚬';;
    1F525|fire|flame|hot|snapstreak) i='🔥';;
    1F4A9|hankey|poop|shit)          i='💩';;
    1F37A|beer|homebrew|brew)        i='🍺';;
    1F36A|cookie|biscuit|chocolate)  i='🍪';;
    1F512|lock|padlock|secure)       i='🔒';;
    1F513|unlock|openpadlock)        i='🔓';;
    2B50|star|yellowstar)            i='⭐';;
    1F0CF|black_joker|joker|wild)    i='🃏';;
    2705|white_check_mark|check)     i='✅';;
    274C|x|cross|xmark)              i='❌';;
    1F6BD|toilet|restroom|loo)       i='🚽';;
    1F514|bell|ringer|ring)          i='🔔';;
    1F50E|mag_right|search|magnify)  i='🔎';;
    1F3AF|dart|bullseye|darts)       i='🎯';;
    1F4B5|dollar|cash|cream)         i='💵';;
    1F4AD|thought_balloon|thinking)  i='💭';;
    1F340|four_leaf_clover|luck)     i='🍀';;

    *)
      #entity $1; return 0;;
  esac
  echo -ne "$i"
}

function e {
  emoji "$@"
}

#SHML:END

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

options="$@"

# Usage - TODO: iterate of arguments
##
if echo "$options" | grep "\-h" > /dev/null; then # also matches '--help'
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

# Files
##
if ! test "$options"; then __usage; fi

# Before/After function handling
##
function __ensure_handlers {
  _="$( { type before; } 2>&1 )"
  if [ "$?" -ne "0" ]; then function before { true; }; fi
  _="$( { type after; } 2>&1 )"
  if [ "$?" -ne "0" ]; then function after { true; }; fi
}

# Progress Variables
__total=0; __passed=0; __failed=0; __failures=""; __successes=""; __current=""; __last=""
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
  process "$?" "$msg" "$cmd" "exit status is zero"
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
  out="$( { $cmd; } 2>&1 )"
  _="$( { echo "$out" | grep "$inc"; } 2>&1 )"
  process "$?" "$msg" "$cmd" "'$out' does not include '$inc'"
  unset out
}

function refute_grep {
  local cmd=$1
  local inc=$2
  local msg="[refute_grep] $3"
  out="$( { $cmd; } 2>&1 )"
  _="$( { echo "$out" | grep -v "$inc"; } 2>&1 )"
  process "$?" "$msg" "$cmd" "'$out' includes '$inc'"
  unset out
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
  __total=$(expr $__total + 1)
  __passed=$(expr $__passed + 1)
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
  __total=$(expr $__total + 1)
  __failed=$(expr $__failed + 1)

  if $__verbose; then
    echo "$__total. $(__do_color red "$msg failed")"
  else
    __do_x
  fi

  if [ "$__last" != "$__current" ]; then
    __failures+="$(br)$__current$(br)"
    __last=$__current
  fi

  __failures+="$(__do_color red "$__total. $msg")$(br)"
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

function __failures {
  if [ "$__failed" -ne 0 ] && ! $__quiet; then
    echo "$(br)$(br)Failures:$(br)$(hr)$(br)$__failures"
  else
    echo " "
  fi
}

function __finish {
  __failures
  if $__verbose; then echo -n "$(hr)"; fi
  if $__quiet; then echo " "; fi
  echo "$(__do_color yellow "$(br)Total: $(expr $__passed + $__failed)")  $(__do_color green "Passed: $__passed")  $(__do_color red "Failed: $__failed")  $(__do_color blue "Duration: ${SECONDS} Seconds")$(br)"
}

function __reset {
  unset before
  unset after
}

function __shunt {
  __ensure_handlers
  before
  run_tests
  after
}

################################################################################
# Make is so.
################################################################################

echo "$(basename -- $0) $@"
if $__verbose; then echo "$(hr '=')"; fi
echo " "

# In an edge case, a test changes directory. It needs to be changed
# back after the test.
#######
here="$(pwd)"

for __current in $options; do
  __reset
  source $__current
  if $__verbose; then echo "$(br)$__current$(br)$(hr)$(br)"; fi
  __shunt
  cd $here
done

__finish
exit $__failed

# vim: ft=sh:
