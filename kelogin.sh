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
    pids=`ps -ef  | grep expect | grep -v grep | awk '{print $2}'`
    [ -n "$pids" ] && kill -9 $pids
}

fn_main $@

