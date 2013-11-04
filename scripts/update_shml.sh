#!/usr/bin/env bash
# Grabs the latest version of shml.sh (github.com/odb/shml) and imports it
# in to shunt.sh

set -xue
curl -L https://raw.github.com/odb/shml/master/shml.sh > shml.sh
awk '/SHML:START/,/SHML:END/' shml.sh | grep -v "SHML:\(START\|END\)" > tmp
mv tmp shml.sh
awk 'FNR==NR{ _[++d]=$0;next}; /SHML:START/{ print; for(i=1;i<=d;i++){ print _[i] }; f=1;next; }; /SHML:END/{f=0}!f' shml.sh shunt.sh > tmp
mv tmp shunt.sh
chmod 755 shunt.sh
rm shml.sh

# vim: ft=sh:
