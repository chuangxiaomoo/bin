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
        ps | awk '/[e]xpect/{print $1}' | while read PID; do kill -9 $PID; done;
        ps | awk '/[t]elnet/{print $1}' | while read PID; do kill -9 $PID; done;
        ;;
    l|list)
        ps -ef  | grep --color [e]xpect
        ;;
    [0-9][0-9]*)
        pids=`ps -ef  | grep "[e]xpect.*$1" | awk '{print $2}'`
        [ -n "$pids" ] && kill -9 $pids
        ;;
    *)
        echo "
        Usage: $0 {all|<ip>}

        Lists:\
        " | sed 's/^  *//g'
        fn_main list
        ;;
    esac
}

fn_main $@

