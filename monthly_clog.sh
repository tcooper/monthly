#!/bin/bash

LM=$(echo "`date +%m` - 1" | bc)
declare -a a_LDOLM=('31' '28' '31' '30' '31' '30' '31' '31' '30' '31' '30' '31')
i_LDOLM=$(echo "$LM -1" | bc)
LDOLM=${a_LDOLM[$i_LDOLM]}

sed -i -r '/^xvec.start\s/s/-[0-9][0-9]-/-'$LM'-/' ./clog-plot.R
sed -i -r '/^xvec.stop\s/s/-([0-9][0-9])-([0-9][0-9])/-'$LM'-'$LDOLM'/' ./clog-plot.R

./clog-plot.R ./gordon-clog.incl > /dev/null
./clog-plot.R ./trestles-clog.incl > /dev/null

mv gordon-clog.incl-all.png gordon-queue-health-`date '+%Y-%m'`.png
mv trestles-clog.incl-all.png trestles-queue-health-`date '+%Y-%m'`.png

exit 0
