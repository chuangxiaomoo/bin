#!/bin/bash - 
#-----------------------------------------------------------------------------
#          FILE: install.sh
#         USAGE: ./install.sh 
#   DESCRIPTION: 
#        AUTHOR: moo (God helps those who help themselves) 
#  ORGANIZATION: 
#       CREATED: 2012-05-24 07:28:22 HKT
#      REVISION: 1.0 
#-----------------------------------------------------------------------------

function fn_main()
{
    if [ "$1" == 'f' ] ; then
        echo "cp jco_server $p_1_bin_apps"
            
        return 0
    fi


    case $1 in
    t)
        chown root:root jco_server
        tcopy.sh jco_server 
        # arm_v5t_le-strip jco_server
        # md5sum jco_server 
        ;;
    s)
        cp jco_server $p_1_bin_apps
        ;;
    q)
        rm -f         /home/q/filesys/app/vs/jco_server*
        cp jco_server /home/q/filesys/app/vs/
        cp jco_server /winc/relay/
        ;;

    *)
        echo "
        t tftp
        s svn $p_1_bin_apps 
        q /home/q/filesys /winc/relay/
        "
        exit
        ;;
    esac


    echo "exec $1 succ!"
}

fn_main $@

