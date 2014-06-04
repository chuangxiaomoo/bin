#!/bin/bash - 
#-----------------------------------------------------------------------------
#          FILE: tcopy.sh
#         USAGE: ./tcopy.sh 
#   DESCRIPTION: 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: moo (God helps those who help themselves) 
#  ORGANIZATION: 
#       CREATED: 2012-07-06 08:37:50 CST
#      REVISION: 1.0 
#-----------------------------------------------------------------------------


function fn_tcopy() {

    tftp="    tftp -r ${1##*/} -g 192.168.2.41; chmod +x ${1##*/};"

    if [ ! -f "$1" ] ; then
        echo -------- $1 not exist -----------
        return
    fi

    cp $1 /tftpboot/

    if [ "${1##*/}" != "jco_server" ] ; then
        echo "$tftp"
        return
    fi

    gopath="cd /app/vs;" 
    rmfile="rm -f jco_server*; killall auto_run.sh; killall jco_server;"
    run="./jco_server &"
    echo $gopath $rmfile $tftp $run

    echo -e "\n-- tmp tftp --\n"

    kills="mv jco_server /app/vs;killall auto_run.sh jco_server;"
    echo "cd /tmp; $tftp $kills ${gopath} $run"

    echo -e "\n-- nxp --\n"
    kills="mv jco_server /opt/app;killall auto_run.sh jco_server;"
    gopath="cd /opt/app;" 
    echo "cd /tmp; $tftp $kills ${gopath} $run"
}

function fn_main()
{
    if [ "$#" -eq 0 ] ; then
        echo
        echo "    Usage $0 files..."
        echo "          $0 -arm"
        return 1
    fi

    echo -e "\nexec on dev:\n"

    if [ "$*" == "-arm" ] ; then
        fn_tcopy $p_monta/usr/bin/less
        fn_tcopy $p_monta/usr/bin/gdb
        echo
        return
    fi

    for f in $@; do
        fn_tcopy $f
        echo
    done

    chmod 777 /tftpboot
    chmod 777 /tftpboot/*
}

fn_main $@
