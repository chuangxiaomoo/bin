#!/bin/bash - 
#---------------------------------------------------------------------------
#          FILE: qpack.sh
#         USAGE: ./qpack.sh 
#        AUTHOR: moo 
#  ORGANIZATION: 
#       CREATED: 2013-04-16 08:24:48 CST
#      REVISION: 1.0 
#---------------------------------------------------------------------------

PS8="eval echo \${BASH_SOURCE##*/}\|\$LINENO\|: "
xert() { [ "${1}" -eq 0 ] || echo ${@:2}; return ${1}; }

function fn_main()
{

    case $1 in
    -h|h)
        echo "Usage: $0 {h|p|*}"
        exit
        ;;
    p)
        echo "sync q to /home/p"
        cp common.rc rules qpack.sh /home/p
        xert $? `$PS8`  || return $?
        echo "sync q and p script success"
        ;;
    *)
        echo "going commit qpack.sh..."
        QUIET='--quiet'
        svn_origin=https://jabscodevsvn/svn/dm36xPro/trunk
        svn_temp='/tmp/qpack'
        rm -rf ${svn_temp}
        svn $QUIET co $svn_origin/package/script ${svn_temp}
        xert $? `$PS8` "svn err" || return $?

        cp *.sh common.rc ${svn_temp} 
        xert $? `$PS8` "svn err" || return $?

        cd ${svn_temp}
        svn diff
        svn ci || (echo "svn up fail!"; exit;)
        echo "svn up success!"
        ;;
    esac
}

fn_main $@
