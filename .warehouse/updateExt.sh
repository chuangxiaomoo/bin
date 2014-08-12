#! /bin/bash
#---------------------------------------------------------------------------
#          FILE: updateExt.sh
#         USAGE: ./updateExt.sh 
#   DESCRIPTION: 
#       OPTIONS: -
#  REQUIREMENTS: -
#          BUGS: -
#         NOTES: -
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
    total_secs=73               # seconds spent by C + BASH => takes_secs
    let start=start-xtar_secs
    sync
    echo 3 > /proc/sys/vm/drop_caches
    echo 100 >/proc/sys/vm/dirty_writeback_centisecs
    echo 1500 >/proc/sys/vm/dirty_expire_centisecs
    echo 120 > /dev/watchdog    # 120s to avoid sync() blocking
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
    sync&
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

function fn_up_ubifs() 
{
    map=(
      # ubiconfig.img 7     /opt/conf
      # ubilog.img    8     /opt/log
      # ubiweb.img    9     /opt/web
        ubiapp.img    10    /opt/app
      # ubimisc.img   11    /opt
    )

    # umount except /opt 
    # /usr/sbin/ubimount -u

    local i
    for (( i=0; i<${#map[@]}; i+=3 )); do
        let j=i+1
        let k=j+1
        idx=${map[$j]}
        mtd=mtd${idx}
        img=${map[$i]}
        mpoint=${map[$k]}

        if [ -f "${img}" ] ; then
            mountpoint -q ${mpoint} && umount -f ${mpoint}
            xt_ret $? "mount list: ------- `mount`" || { return $?; }

            echo ubidetach /dev/ubi_ctrl -m ${idx}                       && \
                 ubidetach /dev/ubi_ctrl -m ${idx}                       && \
            echo flash_eraseall /dev/${mtd}                              && \
                 flash_eraseall /dev/${mtd}                              && \
            echo ubiformat /dev/${mtd} -s 2048 -f ${img}                 && \
                 ubiformat /dev/${mtd} -s 2048 -f ${img}   >& /dev/null  && \
            echo ubiattach /dev/ubi_ctrl -m ${idx} -O 2048               && \
                 ubiattach /dev/ubi_ctrl -m ${idx} -O 2048 >& /dev/null

            xt_ret $? "Fail: idx[${idx}] mtd[${mtd}] img[${img}]" || return $?

            rm -f ${img}
            echo "Succ: idx[${idx}] mtd[${mtd}] img[${img}]"
            fn_prog_bar_set
        fi
    done

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
            sync
            return 0
        fi
    done
}

function fn_up_single_files() 
{
    #
    # Attention: sub-directory etc/ppp conf/isp
    # for overwrite, they must before their papa
    #

    # exclude: web log
    pathes='app  bin  conf  drv  etc  font  lib media'

    # find -maxdepth 2 -type d  | grep -v web | grep '/.*/'
    pathes="etc/ppp conf/isp ${pathes}"
    
    local i=
    for i in ${pathes}; do
        mkdir -p ${i}
        if  [ -n "`ls $i/`" ] ; then
            echo updating ${i}
            mv ${i}/* /opt/${i}/
            xt_ret $? "mv ${i}" || return $?
        fi
        rm -rf ${i}
        fn_prog_bar_set
    done

    return 0
}

function fn_upgrade0()
{
    # fn_prog_bar_set
    # prepare package
    # fn_do_md5               ## do in C
    # xt_ret $? "md5sum fail" || return $?

    fn_prog_bar_set
    xtar_start=${curr}

    mkdir -p $xtardir
    rm -rf $xtardir/*

    tar -zxf $package -C $xtardir &
    pid_tar=$!

    set +x
    while :; do
        kill -0 ${pid_tar} 2>/dev/null || break
        fn_prog_bar_set
        sleep 3
        [ "${j:-0}" -eq 0 ] && { sync& }
        let j=i++%2
    done; sync&
    set -x

    wait $pid_tar
    xt_ret $? "tar fail" || return $?
    rm -f $package

    fn_prog_bar_set

    xtar_end=${curr}
    let xtar_spend=xtar_end-xtar_start
    echo "---- it takes ${xtar_spend}s on tar ----"    # 38s => 3.4s/M

    # update: do one, remove one 
    cd $xtardir

   #fn_up_ubifs
   #xt_ret $? "Fail: ubifs" || return $?
   #fn_prog_bar_set

    fn_up_sqfs
    xt_ret $? "Fail: sqfs" || return $?

    fn_prog_bar_set

    fn_up_single_files
    xt_ret $? "Fail: single files" || return $?

    fn_prog_bar_set

    return 0
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
    ps
    logger "sync and Delay 20s to reboot."
    sync
    sleep 10; 
    sleep 10; 
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
    xtardir=/opt/upgrade
    PATH=$xtardir/upTools:$PATH

    # 
    fn_prog_bar_start

    # upgrade
    echo "UPGRADE updateExt.sh exec begin@`date`"

    fn_upgrade0
    if [ 0 -ne "$?" ] ; then
        fn_banner_fail; fn_prog_bar_fail;
    else
        fn_banner_succ; fn_prog_bar_succ;
    fi

    echo "UPGRADE updateExt.sh exec _end_@`date`"
    echo "sleep 4s to keep the 100% status for webpage"; 
    sleep 4

    # webpage
    killall -9 jco_httpd
    sleep 1
    rm -rf /opt/web/; sync
    mv web /opt
    xt_ret $? "-------- mv web ----------" || return $?

    # clean up
    rm -rf $xtardir/upTools

    return 0
}

function fn_main() 
{
    up_log=/opt/log/upgrade.log

    mkdir -p ${up_log%/*}
    cp ${up_log} ${up_log}.1
    grep UPGRADE ${up_log}.1 | grep -v echo | tail -5000 > ${up_log}

    jcli update -act set -type 1

    fn_upgrade $@ 2>&1 | tee -a ${up_log} 

    fn_reboot&
}
set -x
fn_main $@ 

