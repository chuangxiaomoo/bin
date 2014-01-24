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

function fn_main() {
    echo -n E:
    echo $@ | sed -e 's#/#\\#g' 
    #echo "$@" | sed 's#\\#\//#g' 
}

fn_main $@

