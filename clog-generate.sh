#!/bin/bash
#
#  Use this script to generate Kenneth's queue clog metrics for a month
#

mfdir='/oasis/projects/nsf/use300/glock/machinestate/gordon'
nodeview=/home/glock/src/sdsc/nodeview.4kenneth

cd $mfdir
for mf in 201312*.db
do
  # 2013 12 01 12 00.db
  timestamp=$( sed -e 's#\(....\)\(..\)\(..\)\(..\)\(..\).db#\2/\3/\1 \4:\5#' <<< $mf )
  echo -n -e "$timestamp\t"
  $nodeview --readdb=$mf --summary --quiet | tail -n2 | awk '{ printf( "%8d", $4/1000 ) } END { printf( "\n" ); }'
done
