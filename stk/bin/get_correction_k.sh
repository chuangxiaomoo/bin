#! /bin/bash

#
# 由于 sina 分笔的网络性及移植性，因此此修正法暂不使用
#

. `dirname ${0}`/'dbank' || { echo "dbank err" && exit; }
. /etc/common.rc

function fn_main()
{
    mkdir -p ${mi5_day%/*}
    ./min5 > ${mi5_day}
    while read index code date v1 v2 a1 a2; do
        echo "
        SELECT ${index}, (volume-${v1})/${v2}, (amount-${a1})/${a2} FROM day 
        WHERE code=${code} and date='${date}';
        " | mysql kts -N
    done < ${mi5_day}
    
}

fn_main $@

