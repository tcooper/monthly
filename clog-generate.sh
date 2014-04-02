#!/bin/bash
#
#  Use this script to generate Kenneth's queue clog metrics for a month
#

year=2014
month=03

mfdir="/oasis/projects/nsf/use300/glock/machinestate/$(uname -n | cut -d - -f 1)/$year-$month"
nodeview=$(which nodeview)

cd $mfdir
for mf in ${year}${month}*.db
do
  # 2013 12 01 12 00.db
  timestamp=$( sed -e 's#\(....\)\(..\)\(..\)\(..\)\(..\).db#\2/\3/\1 \4:\5#' <<< $mf )
  echo -n -e "$timestamp\t"
  $nodeview --readdb=$mf --summary --quiet | grep 'Total SUs' | cut -d: -f 2 | awk '{ printf( "%8d", $1 ) } END { printf( "\n" ); }'
done
