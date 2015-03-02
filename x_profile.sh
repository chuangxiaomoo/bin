#!/bin/bash - 
#-----------------------------------------------------------------------------
#          FILE: x_profile.sh
#         USAGE: ./x_profile.sh 
#   DESCRIPTION: 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: moo (God helps those who help themselves) 
#  ORGANIZATION: 
#       CREATED: 2012-11-21 10:14:22 CST
#      REVISION: 1.0 
#
#                            active-line-level-IDR  
# root@Ubt:~/bin# x_profile.sh x 63-2730-74898-63
# reso    | 1080p      ugv        720p       d1         cif        qcif      
# active  | yes        yes        yes        yes        yes        yes       
# profile | base       base       base       base       base       base      
# level   | 30         30         30         30         30         30
#-----------------------------------------------------------------------------

. /etc/common.rc

function fn_xtract()
{
    PROFILE=${@}
    
    [ -n "$PROFILE" ]
    xt_ret "PROFILE is <$@>" || return $?
    # PROFILE="63-4075-112275-62"
    prof=(`echo $PROFILE | sed 's/-/ /g'`)

    reso_total=${#reso_arr[@]}

    # head
    printf "%-8s| %-10s %-10s %-10s %-10s %-10s %-10s\n" reso ${reso_arr[@]}
   # reso have_set profile level

    # body
    let occ=reso_total*1
    bit=`echo "obase=2; ${prof[0]}" | bc -l`
    printf "%-8s| %-10s %-10s %-10s %-10s %-10s %-10s\n" active \
    `printf "%0${occ}d\n" $bit | sed 's/[0-1]/& /g' | \
        sed -e 's/\<1\>/yes/g' -e 's/\<0\>/no/g'`

    let occ=reso_total*2
    bit=`echo "obase=2; ${prof[1]}" | bc -l`
    printf "%-8s| %-10s %-10s %-10s %-10s %-10s %-10s\n" profile \
    `printf "%0${occ}d\n" $bit | sed 's/[0-1][0-1]/& /g' | \
        sed -e 's/\<00\>/high/g' -e 's/\<01\>/main/g' -e 's/\<10\>/base/g' \
            -e 's/\<11\>/deft/g'`

    let occ=reso_total*3
    bit=`echo "obase=2; ${prof[2]}" | bc -l`
    printf "%-8s| %-10s %-10s %-10s %-10s %-10s %-10s %-10s\n" level \
    `printf "%0${occ}d\n" $bit | sed 's/[0-1][0-1][0-1]/& /g' | \
        sed -e 's/\<000\>/10/g' -e 's/\<001\>/20/g' -e 's/\<010\>/30/g' \
            -e 's/\<011\>/40/g' -e 's/\<100\>/50/g' -e 's/\<101\>/undef/g'`

    return
}

function fn_main() {
    reso_arr=(
        1080p
        ugv
        720p
        d1
        cif
        qcif
    )

    case $1 in
    x)
        fn_xtract   ${@:2}
        ;;
    *)
        echo "x_profile.sh x 63-2730-74898-63"
        ;;
    esac
}

#
# encode 通过消息 case SYS_MSG_CMD_GET_VEPARAM 获取参数
# 解析 JCOParseAddConfig()
#

fn_main $@
