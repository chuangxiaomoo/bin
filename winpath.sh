#!/bin/bash - 
#-----------------------------------------------------------------------------
#          FILE: winpath.sh
#         USAGE: ./winpath.sh 
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
    swd="/root/.swd"

    echo $@ | sed -e 's/[A-Z]://g' -e 's#\\#/#g' | tee $swd
    grep -q winc $swd || { cat $swd | sed 's#^/#/media/sf_#' | tee $swd; }

}

fn_main $@
