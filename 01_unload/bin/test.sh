#! /bin/bash

for i in `sed -n '27,35p' ../cfg/02_expdp.cfg`
do
    echo "----split line----"
    t=2
    ((t++))
    echo ${t}
    ((t--))
    echo ${t}
done
#test push empty folders