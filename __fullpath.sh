#! /bin/bash -
#---------------------------------------------------------------------------
#          FILE: __fullpath.sh
#         USAGE: ./__fullpath.sh 
#   DESCRIPTION: 
#       OPTIONS: -
#  REQUIREMENTS: -
#          BUGS: -
#         NOTES: -
#        AUTHOR: chuangxiaomoo (God helps those who help themselves) 
#  ORGANIZATION: 
#       CREATED: 2013-11-28 10:06:47 CST
#      REVISION: 1.0 
#---------------------------------------------------------------------------

function fn_main()
{
    [ -z "$1" ] && echo "Usage __fullpath.sh filename" && exit
    find $PWD -name `basename $1`
    echo
    echo ${PWD}/${1#./} | grep --color `basename $1` > /dev/stderr
}

fn_main $@

