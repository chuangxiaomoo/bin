#! /bin/bash
#---------------------------------------------------------------------------
#          FILE: updateExt.sh
#         USAGE: ./updateExt.sh 
#   DESCRIPTION: 升级分两步进行
#                1  解压升级包，并nandwrite squshfs
#                2  正电重启后，替换 web conf 等文件
#                   a) 进程对文件的引用会导致文件替换失败
#                   b) 直接rm -rf 会概率性(1/700)导致文件夹及文件的直接丢失
#        AUTHOR: zhangjian () 
#  ORGANIZATION: 
#       CREATED: 2014-04-08 10:18:40 AM
#      REVISION: 1.0 
#---------------------------------------------------------------------------

function xt_ret() 
{
    [ "${1}" = "0" ] && return 0
    printf "${BASH_SOURCE[1]##*/}%-6s %s\n" "|${BASH_LINENO[0]}|" "${@:2}"
    return 1
}

function fn_prog_bar_start() 
{
    start=`date +%s`
    xtar_secs=${1:-18}          # seconds spent by C
    total_secs=54               # seconds spent by C + BASH => takes_secs
    let start=start-xtar_secs
    sync
    echo 3 > /proc/sys/vm/drop_caches
    echo 100 >/proc/sys/vm/dirty_writeback_centisecs
    echo 1500 >/proc/sys/vm/dirty_expire_centisecs
    echo 120 > /dev/watchdog    # 120s to avoid this suite blocking
}

function fn_prog_bar_set() 
{
    # total_secs = xtar_secs + updateExt.sh 
    curr=`date +%s`
    let 'prog_bar=100*(curr-start)/total_secs'

    [ "$prog_bar" -ge 100 ] && prog_bar=99

    echo "----- ${prog_bar}% @${BASH_LINENO[0]} ----"
    jcli update -act set -progressbar ${prog_bar}
}

function fn_prog_bar_succ() 
{
    curr=`date +%s`
    prog_bar=100
    echo "----- ${prog_bar} @${BASH_LINENO[0]} ----"
    jcli update -act set -progressbar ${prog_bar}

    let takes_secs=curr-start
    echo "---- it takes $takes_secs on upgrade ----"
}

function fn_prog_bar_fail() 
{
    prog_bar=111
    echo "----- ${prog_bar} @${BASH_LINENO[0]} ----"
}

function fn_do_md5() 
{
    [ -f "$package" ] 
    xt_ret $? "upgrade file[${package}] in needed" || return $?

    md5_pack=`tail -c32 $package`
    [ -n "${md5_pack}" ]
    xt_ret $? "md5_pack" || return $?

    sed -i '$s/[0-9a-z]\{32\}$//' $package
    xt_ret $? "chop $package" || return $?

    md5_here=`md5sum $package | awk '{print $1}'`

    [ "${md5_here}" = "${md5_pack}" ]
    xt_ret $? "(here vs pack) ${md5_here} != ${md5_pack}" || return $?
    return 0
}

function fn_up_sqfs() 
{
    rootsqfs=rootfs.sqfs
    len_sqfs=`stat -c %s ${rootsqfs}`
    mtd_sqfs='/dev/mtd5'
    md5_sqfs=`md5sum ${rootsqfs} | awk '{print $1}'`

    ls /tmp; free 
    [ -f "${rootsqfs}" ] || return 0

    while :; do
        echo flash_eraseall ${mtd_sqfs}                           && \
        flash_eraseall ${mtd_sqfs}                                && \
        nandwrite -q -p ${mtd_sqfs} ${rootsqfs}
        md5_dbg=`mtd_md5sum read ${mtd_sqfs} 0 ${len_sqfs} occupy | awk '{print $1}'`

        if [ "${md5_dbg}" = ${md5_sqfs} ]; then
            rm -f ${rootsqfs} ${dbg_sqfs}
            return 0
        fi
    done
}

function fn_up_single_files() 
{
    #
    # Attention: sub-directory etc/ppp conf/isp,
    # for mv overwrite, they must before their papa,
    # EVEV try rm -rf etc/ppp conf/isp, but __FAIL__ sometimes, so mv is more safe
    #

    # exclude: web log meida
    pathes='app  bin  conf  drv  etc  font  lib'
    # find -maxdepth 2 -type d  | grep -v web | grep '/.*/'
    pathes="etc/ppp conf/isp ${pathes}"

    local i=
    for i in ${pathes}; do
        mkdir -p ${i}
        if [ -n "`ls $i/`" ] ; then
            echo -----updating----- ${i}/* | xargs -n1
            mv ${i}/* /opt/${i}/
            xt_ret $? "mv ${i}" || return $?
        fi
        rm -rf ${i}; sync
    done 

    # webpage process
    cd /opt/upgrade/web/
    echo -----updating----- * | xargs -n1

    pathes=(`find -name '*' -type d`)
    dest='/opt/web'

    for (( i=${#pathes[@]}-1; i>0; i-- )); do
        # echo mkdir -p ${dest}/${pathes[$i]}
        mkdir -p ${dest}/${pathes[$i]}
        mv ${pathes[$i]}/* ${dest}/${pathes[$i]}/
        rm -rf ${pathes[$i]}
        sync
    done
    # rm: cannot remove directory: `.'
    mv ${pathes[$i]}/* ${dest}/${pathes[$i]}/
    sync

    fn_banner_succ
    return 0
}

function fn_upgrade0()
{
    fn_prog_bar_set
    xtar_start=${curr}

    rm -rf $xtardir/*
    tar -zxf $package -C ${xtardir}&
    pid_tar=$!

    set +x
    while :; do
        kill -0 ${pid_tar} 2>/dev/null || break
        fn_prog_bar_set
        sleep 3
    done; 
    time sync
    set -x

    wait $pid_tar
    xt_ret $? "tar fail" || return $?
    rm -f $package

    fn_prog_bar_set

    xtar_end=${curr}
    let xtar_spend=xtar_end-xtar_start
    echo "---- it takes ${xtar_spend}s on tar ----"    # 38s => 3.4s/M

    cd $xtardir
    fn_up_sqfs
    xt_ret $? "Fail: sqfs" || return $?

    # mv the entry file of system
    mv etc/{auto_run.sh,profile} /opt/etc/
    xt_ret $? "Fail: sqfs" || return $?

    sync
}

function fn_banner_succ()
{
    echo "
    +-----------------------------------------------------------+
    |                                                           |
    |              UPGRADE SUCCESSFUL, ENJOY IT!                |
    |                                                           |
    +-----------------------------------------------------------+
    "
}

function fn_banner_fail()
{
    echo "
    +-----------------------------------------------------------+
    |                                                           |
    |              UPGRADE __FAILURE__, CHECK IT.               |
    |                                                           |
    +-----------------------------------------------------------+
    "
}

function fn_reboot() 
{
    # jcli sysctrl -act set -cmd 0
    logger "sync and Delay 18s to reboot."
    sync
    sleep 10; 
    sleep 5; 
    sleep 3; 
    logger "Rebooting from updateExt.sh..."
    echo 1 > /dev/watchdog;
    reboot 
}

# $1 is the fullpath of upgrade package
function fn_upgrade()
{
    shopt -s gnu_errfmt 
    shopt -s extglob

    package=$1
    PATH=$xtardir/upTools:$PATH

    fn_prog_bar_start
    echo "UPGRADE updateExt.sh exec begin@`date`"

    fn_upgrade0 || { 
        fn_prog_bar_fail; fn_banner_fail; 
        rm -rf ${xtardir}; return 1; 
    }

    echo "UPGRADE updateExt.sh exec _end_@`date`"
    echo "sleep 4s to keep the 100% status for webpage"; 
    fn_prog_bar_succ; sleep 4; ps

    return 0
}

function fn_main() 
{
    up_log=/opt/log/upgrade.log
    xtardir=/opt/upgrade

    mkdir -p ${up_log%/*}
    mkdir -p $xtardir
    cd ${xtardir}

    if [ -n "${1}" ] ; then
        set -x
        cp ${up_log} ${up_log}.1
        grep UPGRADE ${up_log}.1 | grep -v echo | tail -5000 > ${up_log}
        jcli update -act set -type 1
        fn_upgrade $@ 2>&1 | tee -a ${up_log} 
        fn_reboot&
    else
        fn_up_single_files 2>&1 | tee -a ${up_log} 
        xt_ret $? "Fail: single files" || return $?
    fi
}

fn_main $@
