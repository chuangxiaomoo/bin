#!/bin/bash - 
#-----------------------------------------------------------------------------
#          FILE: __ntp.sh
#         USAGE: ./__ntp.sh 
#   DESCRIPTION: 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: moo (God helps those who help themselves) 
#  ORGANIZATION: 
#       CREATED: 2012-05-31 03:34:31 HKT
#      REVISION: 1.0 
#-----------------------------------------------------------------------------

function fn_main()
{
    # ntpdate 192.168.2.43 && return 0;

    /etc/init.d/ntp stop
    server=`grep -m1 "^server\>" /etc/ntp.conf | awk '{print $2}'`
    echo ntpdate $server
    ntpdate ${server:-time.windows.com}
    /etc/init.d/ntp start
}

fn_main $@

