#! /bin/bash
#---------------------------------------------------------------------------
#          FILE: npack.sh
#         USAGE: ./npack.sh 
#   DESCRIPTION: 
#       OPTIONS: -
#  REQUIREMENTS: -
#          BUGS: -
#         NOTES: -
#        AUTHOR: zhangjian () 
#  ORGANIZATION: 
#       CREATED: 2014-04-04 10:45:08 AM
#      REVISION: 1.0 
#---------------------------------------------------------------------------

. rules
. common.rc

CWD=${PWD}
STRIP=arm-linux-strip

# __platform__ begin

# 1. 在 webpage, xml 中设置平台
# 2. 相应FACEBOOK及升级处理
# 3. appMng

i_platform_name=0
i_platform_conf=1
i_platform_note=2
i_platform_apps=3

platforminfo=(
   "NORMAL    normal    公司内部平台 ''               " # 0  PLATFORM_NORMAL    # 
   "GUOBIAO   guobiao   国标         'jco_guobiao'    " # 1  PLATFORM_GUOBIAO   # 国标
   "TSLIVE    tslive    TS流         'jco_tslive'     " # 2  PLATFORM_TSLIVE    # TS流
   "HXHT      hxht      互信互通     'jco_hxht'       " # 3  PLATFORM_HXHT      # hxht
   "XM        xiongmai  雄迈NVR      'jco_xiongmai'   " # 5  PLATFORM_XIONGMAI  # XIONGMAI
   "HB        hanbang   汉邦         'jco_hanbang'    " # 6  PLATFORM_HANBANG   # 汉邦
   "HNGS      hngs      沪宁高速     'jco_hngs'       " # 7  PLATFORM_HNGS      # TAIWAN HNGS
   "DH        dahua     大华         'jco_dahua'      " # 8  PLATFORM_DAHUA     # 大华
   "P2P       tutk      TUTK         'jco_tutk'       " # 9  PLATFORM_TUTK      # TUTK
)

base_apps=(
    jco_server
    jco_encode
    jco_stream
    jco_alarm 
    jco_record
    jco_httpd 
    jco_ftpd  
)

# __platform__ end

function fn_set_2d_array_item()
{
    # arr[rec][item] = val
    local arr=$1
    local rec=$2
    local item=$3
    local val=$4

    eval local len=\${#$arr[@]}
    # echo $len

    if [ "$len" -lt $rec ] ; then
        fn_echo_warn "rec:$rec is big than len:$len"
        return 1
    fi

    eval local record=(\${${arr}[${rec}]})

    record[${item}]=$val
    eval ${arr}[${rec}]='"${record[@]}"'
    return $?
}

function fn_get_2d_array_item()
{
    local arr=$1
    local rec=$2
    local item=$3

    eval local record="\${${arr}[${rec}]}"
    eval record=($record)
    eval echo ${record[${item}]}
    return $?
}

function fn_get_platform_info()
{
    fn_get_2d_array_item platforminfo $@
    return $?
}

function fn_list_plt4m()
{
    local idx
    for (( idx=0; idx<${#platforminfo[@]}; idx+=1 )); do
        platform_note=`fn_get_platform_info $idx $i_platform_note`
        xert $? `$PS8` "fn_get_platform_info $idx $i_platform_note error" || return $?

        space_sz=20
        hanzi=`echo ${platform_note} | sed 's/[A-Za-z_]//g'`
        #hanzi=${platform_note//[0-9A-Za-z_]/}
        hanzi_sz=${#hanzi}
        let space_sz+=hanzi_sz
        
        let is_even=idx%2
        [ "$is_even" -eq 0 ] && delim="" || delim="\n"
        #[ "$is_even" -eq 0 ] && delim="" || delim="      -- ${hanzi_sz} ${space_sz} ${hanzi}\n"

        printf "    %-4s%-${space_sz}s$delim" $idx $platform_note
    done
    echo
}

function fn_select_platform()
{
    fn_list_plt4m

    read_PS="Input the platform id(0~`expr $platform_len - 1`) you want to pack, ',' to seperate: [0] "


    if [ -n "$platform_input" ] ; then
        platform_ids=$platform_input
    else
        read -p "$read_PS"  platform_ids
    fi

    [[ -z "$platform_ids" ]] && platform_ids=0

    local i=
    for i in ${platform_ids//,/ }; do
        fn_is_digit "$i" && [ "$i" -lt $platform_len ]

        if [ "$?" -ne 0 ] ; then
            fn_echo_fail "$i is not a valid platform id"
            return 1
        fi

        fn_echo_succ "You've choosen `fn_get_platform_info $i $i_platform_note`\n"
    done
}

# ----------------  __platfrom end__ -----

function fn_opt_ip()
{
    test -z "${1}" && { echo "Usage: ip mustnot be NULL"; return 1; }

    VIP=${1:-192.168.2.44}
    MASK=${2:-255.255.255.0}
    GATEWAY=${3:-${VIP%.*}.1}

    ${xparser} -i -c w -k /cfg/eth/ip   -v ${VIP}       $xmlfile && \
    ${xparser} -i -c w -k /cfg/eth/mask -v ${MASK}      $xmlfile && \
    ${xparser} -i -c w -k /cfg/eth/gw   -v ${GATEWAY}   $xmlfile
    xt_ret $? "" || return $?

    (cd $dir_webpage; 
     find -name '*.js' -type f | xargs sed -i "s/192.168.1.217/${VIP}/g";)
     xt_ret $? "" || return $?
}

# 
# 
# // 帧率，码率，I帧间隔以及码率范围      js/audiovideo.js|1400|
# var streamRateArr = [
#     [0 , 0   , 0 , 0   , 0]   ,         // tag_vesize_QCIF = 0
#     [25, 512 , 25, 54  , 2048],         // tag_vesize_CIF  = 1
#     [25, 1000, 25, 128 , 4096],         // tag_vesize_D1   = 2
#     [25, 2000, 25, 512 , 8192],         // tag_vesize_720P = 3
#     [0 , 0   , 0 , 0   , 0]   ,         // tag_vesize_UVGA = 4
#     [25, 4000, 25, 1024, 8192],         // tag_vesize_1080P= 5
#     [25, 512 , 25, 32  , 1024],         // tag_vesize_QVGA = 6
#     [25, 1000, 25, 128 , 4096],         // tag_vesize_VGA  = 7
#     [25, 3000, 25, 512 , 8192],         // tag_vesize_960P = 8
# ];

function fn_web_devvecfg()
{
    [ "${#}" -eq 2 ]
    xt_ret $? "2 argument needed" || return $?
    local vesize=${1}
    local attr=${2}

    grep -q "tag_vesize_${vesize}" ${dir_webpage}/js/audiovideo.js
    xt_ret $? "tag_vesize_${vesize} not found" || return $?

    sed -i "/tag_vesize_${vesize}/s/[^ ].*,/${attr},/g" js/audiovideo.js
    xt_ret $? "" || return $?

    return $?
}

#	1 /cfg/videoEncode/enclist/encode/vencsize    8
#	1 /cfg/videoEncode/enclist/encode/bps         3000
#	1 /cfg/videoEncode/enclist/encode/fps         25
#	1 /cfg/videoEncode/enclist/encode/gop         25
#	2 /cfg/videoEncode/enclist/encode/vencsize    7
#	2 /cfg/videoEncode/enclist/encode/bps         1000
#	2 /cfg/videoEncode/enclist/encode/fps         25
#	2 /cfg/videoEncode/enclist/encode/gop         25

function fn_fac_devvecfg1()
{
    [ "${#}" -ne 4 ]
    xt_ret $? "" || return $?
    cat <<-HERE
	1 /cfg/videoEncode/enclist/encode/vencsize    $1
	1 /cfg/videoEncode/enclist/encode/bps         $2
	1 /cfg/videoEncode/enclist/encode/fps         $3
	1 /cfg/videoEncode/enclist/encode/gop         $4
	HERE
    return $?
}
function fn_fac_devvecfg2()
{
    [ "${#}" -ne 4 ]
    xt_ret $? "" || return $?
    cat <<-HERE
	2 /cfg/videoEncode/enclist/encode/vencsize    $1
	2 /cfg/videoEncode/enclist/encode/bps         $2
	2 /cfg/videoEncode/enclist/encode/fps         $3
	2 /cfg/videoEncode/enclist/encode/gop         $4
	HERE
    return $?
}

function fn_devvecfg()
{
    # step 1, modify webpage.js
    fn_web_devvecfg
    # step 2, sync modification to factory.kep.pair.*
    # every devvecfg CUSTOMIZING need FACTORY-RESET-2-DEFAULT
    fn_fac_devvecfg1    8   3000 25 25
    fn_fac_devvecfg2    7   1000 25 25
    return 0
}


function fn_opt_platform()
{
    local i=
    for i in ${platform_ids//,/ }; do
        platform_names=${platform_names}`fn_get_platform_info ${i} ${i_platform_name}`,
        platform_confs=${platform_confs}`fn_get_platform_info ${i} ${i_platform_conf}`,
        if [ "${i}" -ne 0 ]; then
            extra_apps="${extra_apps} `fn_get_platform_info ${i} ${i_platform_apps}`"
        fi
    done
    platform_names=${platform_names%,}
    platform_confs=${platform_confs%,}

    ${xparser} -i -c w -k /cfg/devinfo/platform -v ${platform_names} ${xmlfile}
    xt_ret $? "" || return $?

    tar_package="${dir_tar}/${platform_names//,/.}${spi_flag}.nxp.tgz"

    # extra app process
    facebook=${dir_filesys}/opt/app/FACEBOOK

    echo ${base_apps[@]} ${extra_apps} | xargs -n1 > ${facebook} 

    cd ${dir_filesys}/opt/app
    ls jco_* | grep -v -f ${facebook} | xargs rm -f
    rm -f helloworld
    arm-linux-strip jco_* && chmod +x jco_* && du -sh *
    xt_ret $? "${FUNCNAME}" || return $?

    return $?
}


function fn_opt_spiflash()
{
    if [ "${spi_flash}" != true ]; then
        # normal
        (cd ${dir_filesys}/opt/font && rm -rf spi)
        xt_ret $? "" || return $?
        do_miscfs="mkfs.ubifs -r opt  -m 2048 -e 126976 -c 1023 -o ${img_ubifs}"
        local_img=${local_image}
        img_files="README.txt nf_bootimage.bin u-boot.bin zImage"
    else
        do_miscfs="mkfs.jffs2 -r opt -o ${img_jffs2} -e 64KiB --pad=0x1C0000 -s 0x100 -n"
        local_img=${local_image_spi}
        img_files="README.spi.txt  sf_bootimage.bin  zImage"
        # osd
        cd ${dir_filesys}/opt/font
        ls | grep -v spi | xargs rm -rf
        xt_ret $? "" || return $?
        mv spi/* . && rm -rf spi
        xt_ret $? "" || return $?
        # gdb etc.
        cd ${dir_filesys}
        rm -f bin/gdb usr/bin/gdbserver

        # strip
        cd ${dir_filesys}/opt/bin
        file * | awk -F: '/ELF 32-bit/ {print $1}' | xargs $STRIP
        cd ${dir_filesys}/drivers
        file * | awk -F: '/ELF 32-bit/ {print $1}' | xargs $STRIP -S
        cd ${dir_filesys}/usr/sbin/
        file * | awk -F: '/ELF 32-bit/ {print $1}' | xargs $STRIP
        cd ${dir_filesys}/usr/sbin/
        file * | awk -F: '/ELF 32-bit/ {print $1}' | xargs $STRIP

        local dir=
        for dir in /opt/bin /usr/bin /usr/sbin; do
            file ${dir_filesys}${dir}/* | awk -F: '/ELF 32-bit/ {print $1}' | xargs $STRIP
        done

        local kodir=/lib/modules/2.6.28.9-Mozart-8G/kernel
        for dir in ${kodir}/lib ${kodir}/drivers/net /drivers /lib /usr/lib; do
            file ${dir_filesys}${dir}/* | awk -F: '/ELF 32-bit/ {print $1}' | xargs $STRIP -S
        done

    fi 
    
    return $?
}

function fn_opt_user_passwd()
{
    test ${#} -eq 2
    xt_ret $? "[$*] must be format like [opt_user_passwd user passwd]" || return $?

    user=$1
    pass=$2

    pass_md5=`${nxp_crypt} md5 ${user}:${pass}`
    xt_ret $? "" || return $?
    pass_base=`${nxp_crypt} base ${pass}`
    xt_ret $? "" || return $?
    pass_onvif=`${nxp_crypt} onvif ${pass}`
    xt_ret $? "" || return $?

    # mode 0:不验证  1:basic  2: digest
    ${xparser} -i -c w -k /cfg/authmode/mode                    -v 1  $xmlfile && \
    ${xparser} -i -c w -k /cfg/sysUser/userlist/user/username    -v ${user} $xmlfile && \
    ${xparser} -i -c w -k /cfg/sysUser/userlist/user/cryptpasswd -v ${pass_base} $xmlfile && \
    ${xparser} -i -c w -k /cfg/sysUser/userlist/user/digestpasswd -v ${pass_md5} $xmlfile && \
    ${xparser} -i -c w -k /cfg/sysUser/userlist/user/onvifpasswd  -v ${pass_onvif} $xmlfile 
    xt_ret $? "opt_user_passwd" || return $?
}

function fn_spi_fs_reconstruct()
{
    [ "${spi_flash}" != true ] && return 0

    cd ${dir_filesys}/opt/
    mv app web font conf/isp ${dir_filesys}/
    xt_ret $? "" || return $?
    ln -sf /app
    ln -sf /web
    ln -sf /font

    cd ${dir_filesys}/opt/conf
    ln -sf /isp
    xt_ret $? "" || return $?
    
    return $?
}

function fn_opt_dt_select()
{
    if [ -n "${dt_select_input}" ]; then
        fn_echo_succ "customize dt_select..."
        ${xparser} -i -c w -k /cfg/devinfo/devtype_select -v ${dt_select_input} $xmlfile
        xt_ret $? "" || return $?
    fi
    return 0
}

function fn_customize() 
{
    fn_opt_platform
    xt_ret $? "" || return $?

    fn_opt_spiflash
    xt_ret $? "" || return $?

    fn_opt_dt_select
    xt_ret $? "" || return $?

    # -o 1:2:3:4
    # do before fn_prepare_config, in case to customize config.xml
    if [ -n "$opt_input" ] ; then
        local opt0=
        for opt0 in ${opt_input//:/ }; do
            echo "process option ${opt0}"
            fn_opt_input $opt0
            xert $? `$PS8`  || return $?
        done
    fi

    fn_prepare_config
    xt_ret $? "" || return $?

    # spi-flash fs re-construct must at the end of customize
    fn_spi_fs_reconstruct
    xt_ret $? "" || return $?

}

function fn_prepare_filesys() 
{
    # svn co --- local cp

    if [ -d "$local_filesys" ] ; then
        cp -a ${local_filesys}/* ${dir_filesys}
        xt_ret $? "cp" || return $?

        # cp -a ${local_webpage}/* ${dir_filesys}/opt/web/
        # xt_ret $? "cp" || return $?
    else
        xt_ret 1 "Error: use $local_filesys : $local_webpage please" || return $?
    fi

    if [ "${opt_newweb}" = true ] ; then
        [ -d "${local_newweb}" ]
        xt_ret $? "[${local_newweb}] is not exist" || return $?

        fn_echo_succ "customize web from DIR ${local_newweb}"

        rm -rf ${dir_filesys}/opt/web/*
        xt_ret $? "" || return $?

        cp -a ${local_newweb}/* ${dir_filesys}/opt/web
        xt_ret $? "cp" || return $?
    fi

    find ${CWD} -name '.nfs*' | xargs rm -f

    # del non-svn and redundent files 
    rm -rf ${dir_filesys}/opt/conf/config.xml
    rm -rf ${dir_webpage}/image/tutk_id.bmp

    ROOT=$dir_filesys
    [ -e $ROOT/dev/console ] || mknod -m 600 $ROOT/dev/console c 5 1
    [ -e $ROOT/dev/null ]    || mknod -m 666 $ROOT/dev/null c 1 3


}

function fn_do_images() 
{
    # /opt
    cd ${dir_filesys}/
    fn_echo_succ "do misc from opt"
    du -sh opt
    ${do_miscfs} 
    xt_ret $? "mkfs" || return $?

    # for dubug
    # rm -rf /home/opt && cp -a opt /home

    if [ "${spi_flash}" != true ] ; then
        cd ${dir_com}
        ubinize -o $niz_ubifs -m 2048 -p 128KiB -s 512 -O 2048 ${dir_cfg}/ubinizemisc.cfg
        xt_ret $? "ubinize" || return $?
        md5sum ${niz_ubifs} | awk '{printf $1}' > ${md5_ubifs}
    fi

    # rootfs
    rm -rf ${dir_filesys}/opt/*
    mksquashfs ${dir_filesys} ${dir_package}/rootfs.sqfs
    xt_ret $? "mksquashfs" || return $?

    # cp
    cp -a ${dir_package}/rootfs.sqfs ${dir_com}
    xt_ret $? "cp rootfs.sqfs" || return $?

    # cp u-boot kernel

    cd ${local_img}
    local i=
    for i in ${img_files}; do
        cp -a ${i} ${dir_com} && cp -a ${i} ${dir_package}
        xt_ret $? "cp kernel" || fn_echo_warn "image ${i} is not exist"
    done

    if ${spi_flash}; then
        cd ${dir_com}
        fn_echo_succ "gen for factory: `ls`" 
        generate_firmware sf_bootimage.bin zImage rootfs.sqfs ${img_jffs2} output_sf_fireware.bin
        xt_ret $? "" || return $?
    fi

    #

    cd ${dir_package}
    if [ "${spi_flash}" != true ] ; then
        fn_echo_succ "-- - - nand maps -- - "
        maps=(
            mtd0 nf_bootimage.bin  # loader
            mtd1 u-boot.bin        # uboot
            mtd4 zImage            # kernel
            mtd5 rootfs.sqfs       # rootfs 
        )
    else
        fn_echo_succ "-- - - spi maps -- - "
        maps=(
            mtd0 sf_bootimage.bin  # loader
            mtd2 zImage            # kernel
            mtd3 rootfs.sqfs       # rootfs
        )
    fi

    local i j
    for (( i=0,j=1; i<${#maps[@]}; j+=2,i+=2 )); do
        n=${maps[${i}]}
        f=${maps[${j}]}
        test -e ${f} || continue
        printf "%s %20s %10d %36s\n" ${n} ${f} `stat -c %s ${f}` `md5sum ${f} | awk '{print $1}'`
    done > images.map

    return 0
}

function fn_makerinfo()
{
    local pack_date=`date +'%F.%T'` 
    local pack_ip=`fn_get_if_ip | grep 192.168.2` 

    [ -n "$pack_ip" ]
    xt_ret $? "machine ip is no in net 192.168.2.255" > /dev/stderr || return $?

    echo "Release   $pack_date@$pack_ip" 
    echo "Platforms $platform_names"
    echo "Revirsion $revision"
    echo "Option    $TAGS" 
}

function fn_do_tar()
{
    cd ${dir_package}

    if [ "${spi_flash}" = 'true' ]; then
        echo 'SPI' > flashtype
    else
        echo 'NAND' > flashtype
    fi

    tar -zcf ${tar_package} *
    xt_ret $? "tar" || return $?

    # cp ${tar_package} ${tar_package%%tgz}nomd5.tgz
    # xt_ret $? "rename" || return $?

    cat ${local_uptools}/updateExt.sh >> ${tar_package} && \
    cat ${local_uptools}/updateExt.sh | wc -c | xargs printf "%06d" >> ${tar_package}
    xt_ret $? "" || return $?

    md5sum ${tar_package} | awk '{printf $1}' >> ${tar_package}
    xt_ret $? "md5sum" || return $?
}


function fn_do_install() 
{
    chmod 777 ${tar_package} ${dir_com}/*
    if [ -d "/tftpboot/" ]; then
        cp -a ${dir_com}/* /tftpboot
        cp -a ${tar_package} /tftpboot
        fn_echo_succ "install to /tftpboot succ!"
    fi

    if [ -d "/winc/20181010_GEN/Packages/" ] ; then
        cp ${tar_package} /winc/20181010_GEN/Packages/
    fi

    return 0
}


function fn_usage()
{
    echo "
Usage: ENVIRONMENT=val $SRC_NAME [OPTION]

OPTION

  -l, --list
    list the platform id and corresponding platform names

  -o,--opt SUBOPTION
    可以用':'分隔同时选用多个SUBOPTION的组合
    1  定制为中性平台
       使用中性图片logo

    2  定制安普达
       设备的默认IP地址修改为192.168.1.19. 
       默认主管理员的账号为system，system。
       标题OSD默认在左上角， 时间OSD默认在右下角。

       200w + 130 w

  -p PLATFORM_ID
    PLATFORM_ID as platform id, skip the interaction of select platform.
    ',' to seperate when multi-platform

  --newweb <DIR>
    use a new web

  -s, --spi
    spi-flash

  --dt_select <num>
    0显示 球时mcu上报，枪时定制 1显示xml定制 2 空不显示

  -q,--quite
    equal to --platform=PLATFORM_NORMAL
        
ENVIRONMENT
        
  VIP
      if \$VIP is set and a valid IP, its value is used as IP in config.org

EXAMPLES    
    VIP=192.168.5.80 $SRC_NAME
    "
}

function fn_getopt()
{
    # : after opt indicate value must be give, e.g. -t is a test, 
    # login_shell is seperated by ','
    # revision is for 1466 of 20121213

    shortopts="ho:lp:s"
    longopts1="help,list,newweb,spi,dt_select:"
    longopts="$longopts1"

    # after below statement, $@ was set end with '--'
    eval set -- "$(getopt -n $0 -o "$shortopts" -l "$longopts" 2> $PSHM/set "--" "$@")" 

    # echo $PSHM/set
    if [ -s "$PSHM/set" ] ; then
        fn_echo_fail `cat $PSHM/set`
        fn_echo_warn "Type '$SRC_NAME -h' for usage. "
        return 1
    fi

    if echo "$*" | grep -- "-- " >& /dev/null; then
        local argv="$*"
        fn_echo_warn "invalid para ${argv##*-- }"
        # sleep 1
        exit 1
    fi
    #
    # a shift is the start of block when opt with a `:`
    #
    while [ "$*" != "" ]; do
        # echo "<$1>"
        case $1 in
        -l|--list)
            fn_list_plt4m
            exit $?
            ;;
        --newweb)
            readonly opt_newweb=true
            ;;
        -o|--opt)
            shift
            readonly opt_input=$1
            ;;
        -s|--spi)
            fn_echo_succ "
            You are enabling spi-flash
            "
            spi_flag='.spi'
            spi_flash=true
            ;;
        -p|--platform)
            shift
            readonly platform_input=$1
            ;;
        --dt_select)
            shift
            readonly dt_select_input=$1
            ;;
        --)
            break ;;
        --help|-h|*)
            # echo curr option $1
            fn_usage $1
            exit 0
            ;;
        esac
        shift
    done
}

function fn_opt_input()
{

    case $1 in
    1)
        fn_echo_succ "customize logo.png..."
        (cd $dir_webpage/image/ && mv logo_neutral.png logo.png)
        xt_ret $? "mv logo.png fail" || return $?
        ;;
    2)
        fn_echo_succ "customize AnPuDa..."
        fn_opt_ip 192.168.1.19
        xt_ret $? "" || return $?
        fn_opt_user_passwd system system
        xt_ret $? "" || return $?

        # no inherit of  'cfg/osdinfo/name' osdinfo.name 需要在工厂进行处理
        # sed -i '/cfg.osdinfo.name/d' ${factkep}

        # devname & devtype & devtype_select
        ${xparser} -i -c w -k /cfg/devinfo/devname  -v ADNXP-V01      $xmlfile && \
        ${xparser} -i -c w -k /cfg/devinfo/devtype  -v ADIPCAM-100    $xmlfile
        xt_ret $? "" || return $?

        # osdinfo
        ${xparser} -i -c w -k /cfg/osdinfo/timeen   -v 1       $xmlfile && \
        ${xparser} -i -c w -k /cfg/osdinfo/timeleft -v 1764    $xmlfile && \
        ${xparser} -i -c w -k /cfg/osdinfo/timetop  -v 1064    $xmlfile && \
        ${xparser} -i -c w -k /cfg/osdinfo/bpsen    -v 0       $xmlfile && \
        ${xparser} -i -c w -k /cfg/osdinfo/bpsleft  -v 20      $xmlfile && \
        ${xparser} -i -c w -k /cfg/osdinfo/bpstop   -v 52      $xmlfile && \
        ${xparser} -i -c w -k /cfg/osdinfo/nameen   -v 1       $xmlfile && \
        ${xparser} -i -c w -k /cfg/osdinfo/nameleft -v 20      $xmlfile && \
        ${xparser} -i -c w -k /cfg/osdinfo/nametop  -v 32      $xmlfile && \
        ${xparser} -i -c w -k /cfg/osdinfo/name     -v Camera-1 $xmlfile 
        xt_ret $? "" || return $?

        # devvecfg
        cat <<-"HERE" >${vec_1080p}
		1 /cfg/videoEncode/enclist/encode/vencsize    5
		1 /cfg/videoEncode/enclist/encode/bps         3072
		1 /cfg/videoEncode/enclist/encode/fps         25
		1 /cfg/videoEncode/enclist/encode/gop         25
		1 /cfg/videoEncode/enclist/encode/fixbps      0
		2 /cfg/videoEncode/enclist/encode/vencsize    2
		2 /cfg/videoEncode/enclist/encode/bps         512
		2 /cfg/videoEncode/enclist/encode/fps         25
		2 /cfg/videoEncode/enclist/encode/gop         25
		2 /cfg/videoEncode/enclist/encode/fixbps      0
		HERE
        cat <<-"HERE" >${vec_960p}
		1 /cfg/videoEncode/enclist/encode/vencsize    8
		1 /cfg/videoEncode/enclist/encode/bps         1536
		1 /cfg/videoEncode/enclist/encode/fps         25
		1 /cfg/videoEncode/enclist/encode/gop         25
		1 /cfg/videoEncode/enclist/encode/fixbps      0
		2 /cfg/videoEncode/enclist/encode/vencsize    2
		2 /cfg/videoEncode/enclist/encode/bps         512
		2 /cfg/videoEncode/enclist/encode/fps         25
		2 /cfg/videoEncode/enclist/encode/gop         25
		2 /cfg/videoEncode/enclist/encode/fixbps      0
		HERE
        ;;

    *)
        ;;
    esac

    return 0
}

function fn_prepare_config()
{
    cd ${dir_filesys}/opt/conf

    sed -i "s/__RELEASE_TIME__/`date +'%F.%T'`/g" config.org
    xt_ret $? "" || return $?

    local i=
    for i in ${platform_confs//,/ }; do
        grep ${i} platform.kep.list  >> factory.kep.list
        grep ${i} platform.full.list >> upgrade.add.list
        xt_ret $? "" || fn_echo_warn "
        ------------------------------------------------------------
                        No config of ${i} 
        ------------------------------------------------------------
        "
    done

    ${xparser} -c r -f upgrade.add.list config.org > upgrade.add.pair
    xt_ret $? "" || return $?

    ${xparser} -c r -f upgrade.mod.list config.org > upgrade.mod.pair
    xt_ret $? "" || return $?
    ls
}

function fn_prepare_package()
{
    # for .tar
    fn_makerinfo >> ${p_RELEASE}
    xt_ret $? "" || return $?

    cd ${dir_filesys}/opt/
    cp -a * ${dir_package}
    xt_ret $? "cp to package" || return $?

    # no fonts
    # rm -rf ${dir_package}/font

    # for upgrade
    cp -a ${local_uptools} ${dir_package}
    xt_ret $? "upTool not exist" || return $?

    return $?
}

function fn_main()
{
    CWD=${PWD}/
    SRC_NAME=$0
    dir_release=${CWD}release
    dir_package=${CWD}package
    dir_filesys=${CWD}filesys
    dir_webpage=${CWD}filesys/opt/web
    dir_com=${dir_release}/com
    dir_tar=${dir_release}/tar
    dir_cfg=${CWD}/rc.d/ubinizecfg
    img_ubifs=${dir_com}/miscubifs.img
    img_jffs2=${dir_com}/filesys.jffs2
    niz_ubifs=${dir_com}/miscubifs.niz
    md5_ubifs=${dir_com}/miscubifs.md5
    xmlfile=${dir_filesys}/opt/conf/config.org
    factkep=${dir_filesys}/opt/conf/factory.kep.list
    vec_720p=${dir_filesys}/opt/conf/factory.kep.pair.720p
    vec_960p=${dir_filesys}/opt/conf/factory.kep.pair.960p
    vec_1080p=${dir_filesys}/opt/conf/factory.kep.pair.1080p

    xparser="${CWD}/rc.d/xml_shuttle"
    nxp_crypt="${CWD}/rc.d/nxp_crypt"
    p_RELEASE="${dir_filesys}/opt/conf/RELEASE"
    spi_flash=false

    ls | grep -E -v "(rc.d|mkfs.ubifs|common.rc|rules|.sh$)" | xargs rm -rf {}

    mkdir -p $dir_package
    mkdir -p $dir_filesys
    mkdir -p $dir_release
    mkdir -p $dir_com
    mkdir -p $dir_tar

    PATH=${CWD}/rc.d/:$PATH
    TAGS="${@}"

    platform_len=${#platforminfo[@]}
    # echo ${platform_len}

    fn_getopt ${TAGS}
    xt_ret $? "options" || return $?

    fn_select_platform
    xt_ret $? "options" || return $?

    fn_prepare_filesys
    xt_ret $? "prepare failed" || return $?

    # customize here
    fn_customize
    xt_ret $? "${FUNCNAME}" || return $?

    fn_prepare_package

    # do images b4 fn_do_tar() for rootfs.sqfs
    fn_do_images
    xt_ret $? "do images" || return $?

    fn_do_tar
    xt_ret $? "tar" || return $?

    fn_do_install
    xt_ret $? "install" || return $?

    fn_echo_succ "
    cd ${tar_package%/*};
    time curl -F \"file=@${tar_package##*/};\" 192.168.2.44/webs/updateCfg
    
    M`du -sm ${tar_package}`
    Get release on ${dir_release}: , enjoy on NXP!
    " | tee ${CWD}/.banner
}

fn_main $@

# /home/s/trunk/filesys/script/upTools/updateExt.sh
# rm -rf /home/s/trunk/filesys/script/pack/*
# cp -a npack.sh  rc.d  rules /home/s/trunk/filesys/script/pack;
# cd /home/s/trunk/filesys/script/pack; svn diff
