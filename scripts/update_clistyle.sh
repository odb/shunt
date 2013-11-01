#!/usr/bin/env bash
set -xue
curl -L https://raw.github.com/jmervine/clistrap/master/clistyle.sh > clistyle.sh
awk '/CLISTYLE:START/,/CLISTYLE:END/' clistyle.sh | grep -v "CLISTYLE:\(START\|END\)" > tmp
mv tmp clistyle.sh
awk 'FNR==NR{ _[++d]=$0;next}; /CLISTYLE:START/{ print; for(i=1;i<=d;i++){ print _[i] }; f=1;next; }; /CLISTYLE:END/{f=0}!f' clistyle.sh CLIunit.sh > tmp
mv tmp CLIunit.sh
chmod 755 CLIunit.sh
rm clistyle.sh

# vim: ft=sh:
