#!/bin/bash - 
#-----------------------------------------------------------------------------
#          FILE: kelogin.sh
#         USAGE: ./kelogin.sh 
#   DESCRIPTION: 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: moo (God helps those who help themselves) 
#  ORGANIZATION: 
#       CREATED: 2012-09-24 07:07:48 CST
#      REVISION: 1.0 
#-----------------------------------------------------------------------------

function fn_main()
{

    case $1 in
    a|all)
        pids=`ps -ef  | grep [e]xpect | awk '{print $2}'`
        [ -n "$pids" ] && kill -9 $pids
        ;;
    l|list)
        ps -ef  | grep --color [e]xpect
        ;;
    [0-9][0-9]*)
        pids=`ps -ef  | grep "[e]xpect.*$1" | awk '{print $2}'`
        [ -n "$pids" ] && kill -9 $pids
        ;;
    *)
        echo "Usage: $1 {all|list|<ip>}"
        ;;
    esac
}

fn_main $@

