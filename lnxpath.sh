#!/bin/bash - 
#-----------------------------------------------------------------------------
#   DESCRIPTION: 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: moo (God helps those who help themselves) 
#  ORGANIZATION: 
#       CREATED: 2012-05-24 02:49:37 HKT
#      REVISION: 1.0 
#-----------------------------------------------------------------------------

function fn_main() 
{
    [ -z "${*}" ] && echo "Usage: $0 path_in_linux" && exit

    lnxpath=`echo $@ | sed -e 's#/#\\\\#g'`
    
    if echo ${lnxpath} | grep -q "root.bin" ; then
        echo '\\192.168.2.41'${lnxpath}
    else
        echo E:${lnxpath}
    fi
}

fn_main $@

