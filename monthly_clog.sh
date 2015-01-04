#!/bin/bash

PAST=$(echo "`date +%s` - (60*60*24*30)" | bc)
LM=$(date -d@${PAST} +%m)
LY=$(date -d@${PAST} +%Y)
declare -a a_LDOLM=('31' '28' '31' '30' '31' '30' '31' '31' '30' '31' '30' '31')
i_LDOLM=$(echo "$LM -1" | bc)
LDOLM=${a_LDOLM[$i_LDOLM]}

sed -i -r '/^xvec.start\s/s/(20[0-9][0-9])-[0-9][0-9]-/'$LY'-'$LM'-/' ./clog-plot.R
sed -i -r '/^xvec.stop\s/s/(20[0-9][0-9])-([0-9][0-9])-([0-9][0-9])/'$LY'-'$LM'-'$LDOLM'/' ./clog-plot.R

./clog-plot.R ./gordon-clog.incl > /dev/null
./clog-plot.R ./trestles-clog.incl > /dev/null

mv gordon-clog.incl-all.png gordon-queue-health-`date '+%Y-%m'`.png
mv trestles-clog.incl-all.png trestles-queue-health-`date '+%Y-%m'`.png

exit 0
