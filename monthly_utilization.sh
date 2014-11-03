#!/bin/bash

LM=$(echo "`date +%m` - 1" | bc)
declare -a a_LDOLM=('31' '28' '31' '30' '31' '30' '31' '31' '30' '31' '30' '31')
i_LDOLM=$(echo "$LM -1" | bc)
LDOLM=${a_LDOLM[$i_LDOLM]}

sed -i -r '/^xvec.start\s/s/-[0-9][0-9]-/-'$LM'-/' ./utilization.R
sed -i -r '/^xvec.stop\s/s/-([0-9][0-9])-([0-9][0-9])/-'$LM'-'$LDOLM'/' ./utilization.R

./utilization.R ./gordon-ongoing.incl > /dev/null
./utilization.R ./trestles-ongoing.incl > /dev/null

mv gordon-ongoing.incl-all.png gordon-util-`date '+%Y-%m'`.png
mv trestles-ongoing.incl-all.png trestles-util-`date '+%Y-%m'`.png

exit 0
