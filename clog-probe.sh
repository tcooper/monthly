#!/bin/bash
#
#  Use this script to see what users had the most jobs and the most SUs waiting
#  in the queue for a given machinestate db
#

MACHINESTATE=/oasis/projects/nsf/use300/glock/machinestate/gordon

nodeview --jobview 
         --readdb=$MACHINESTATE/201312211400.db \
         | sed -e 's/:/ /g' \
         | awk '/Queued/ { 
             chg = $3*$4*($7+$8/60+$9/3600); 
             accts[$5] += chg; 
             jobct[$5]++ 
         } END { 
             for (i in accts) { 
                 if ( i != "" ) { 
                     printf( "%12s %7d %5d\n", i, accts[i], jobct[i] );
                 } 
             } 
         }' \
         | sort -n -k2
