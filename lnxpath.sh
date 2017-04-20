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
    [ "${1}" = '-h' ] && echo "Usage: $0 path_in_linux" && exit

    cmdline="${*}"
    lnxpath=`echo ${cmdline:-${PWD}} | sed -e 's#/#\\\\#g'`
    
    if echo ${lnxpath} | grep -q "winc" ; then
        echo E:${lnxpath}
    else
        echo '\\192.168.2.248'${lnxpath}
    fi
}

fn_main $@

