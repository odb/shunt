#!/usr/bin/env bash
# Grabs the latest version of clistyle.sh (working title) and imports it
# in to shunt.sh
set -xue
curl -L https://raw.github.com/jmervine/clistrap/master/clistyle.sh > clistyle.sh
awk '/CLISTYLE:START/,/CLISTYLE:END/' clistyle.sh | grep -v "CLISTYLE:\(START\|END\)" > tmp
mv tmp clistyle.sh
awk 'FNR==NR{ _[++d]=$0;next}; /CLISTYLE:START/{ print; for(i=1;i<=d;i++){ print _[i] }; f=1;next; }; /CLISTYLE:END/{f=0}!f' clistyle.sh shunt.sh > tmp
mv tmp shunt.sh
chmod 755 shunt.sh
rm clistyle.sh

# vim: ft=sh:
