#! /bin/bash
#---------------------------------------------------------------------------
#          FILE: dl.sh
#         USAGE: ./dl.sh 
#   DESCRIPTION: 
#       OPTIONS: -
#  REQUIREMENTS: -
#          BUGS: -
#         NOTES: -
#        AUTHOR: zhangjian () 
#  ORGANIZATION: 
#       CREATED: 2014-11-22 11:34:43 PM
#      REVISION: 1.0 
#---------------------------------------------------------------------------

function fn_dl()
{
    num=1
    while read url; do
        echo $url
        code=`printf "%03d" ${num}`
        w3m -dump ${url} > ${code}
        let num++
    done < ./urls
}

function fn_main()
{
    files=`ls [01]*`

    local i=
    for i in ${files}; do
        cat ${i} | grep -A1000 教你炒股票 | grep -B1000 赠金笔  > ${i}.txt
    done
    return $?
}
fn_main $@

