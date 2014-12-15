#! /bin/bash - 
#-----------------------------------------------------------------------------
#          FILE: pack.sh
#         USAGE: ./pack.sh 
#   DESCRIPTION: 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: moo (God helps those who help themselves) 
#  ORGANIZATION: 
#       CREATED: 2012-06-28 11:12:47 CST
#      REVISION: 1.0 
#-----------------------------------------------------------------------------
APP_STRIP=arm_v5t_le-strip
MD5SUM=md5sum

shopt -s gnu_errfmt 

. ./common.rc 
. rules >& /dev/null || { echo "file rules not exist!" && exit 0; }

PK_GENERATE=20181010_GEN
# p_release=/winc/20181010_GEN

# . ./tmp.sh
# globle vars begin
# PLATFORM_E
arr_platform_ids=(
    PLATFORM_NORMAL         #0      # 
    PLATFORM_SV             #1      # starvalley
    PLATFORM_HAIDOU         #2      # hai dou
    PLATFORM_BJYJ           #3      # bjyj
    PLATFORM_HXHT           #4      # hxht
    PLATFORM_YJPL           #5      # bjyj use starvalley platform
    PLATFORM_YJMB           #6      # bjyj and starvalley platform
    PLATFORM_HUAWEI         #7      # HAUWEI platform
    PLATFORM_JCOMB          #8      # normal and starvalley platform
    PLATFORM_FDDI           #9      # FDDI use normal platform
    PLATFORM_JMWC           #10     # 江门炜创use starvalley platform
    PLATFORM_HANDSET        #11     # 手持设备use starvalley platform
    PLATFORM_TDHOME         #12     # 星谷TDHOME use starvalley platform
    PLATFORM_WSCBPI         #13     # 微思创BPI use normal platform
    PLATFORM_DECODE         #14     # decode platform
    PLATFORM_ZXW            #15     # 中星微platform
    PLATFORM_LTAO           #16     # 浪涛platform
    PLATFORM_NVR            #17     # NVR looks like starvalley platform
    PLATFORM_JCOMO          #18     # 捷高行业监控 platform
    PLATFORM_ZTE            #19     # 中兴平台 platform
    PLATFORM_VSIP           #20     # 中盛益华平台 platform
    PLATFORM_MONITOR        #21     # 中性捷高行业监控 platform
    PLATFORM_NZIT           #22     # 南自信息 platform
    PLATFORM_ANV            #23     # 安维 platform
    PLATFORM_PTZCA          #24     # PTZ联动 platform
    PLATFORM_XINY           #25     # 信义3G平台 platform
    PLATFORM_WANHUA         #26     # 万华平台 platform
    PLATFORM_CEC            #27     # 中国电子集团使用行业监控平台 platform
    PLATFORM_NC             #28     # 南车NVR平台 platform
    PLATFORM_ZXLW           #29     # 中兴力维平台 platform
    PLATFORM_ZXLWL          #30     # 中兴力维平台加浪涛平台 platform
    PLATFORM_LTAOOWSP       #31     # 浪涛OWSP平台 platform
    PLATFORM_ZXWNVR         #32     # 中性微NVR
    PLATFORM_KEDA           #33     # 柯达监控平台使用行业监控平台 platform
    PLATFORM_HXHTYFT        #34     # 互信互通英飞拓使用互信互通平台platform
    PLATFORM_KINGHOO        #35     # 金虎视频会议
    PLATFORM_JSFT           #36     # 捷视飞通
    PLATFORM_BQST           #37     # 北清视通
    PLATFORM_NANRUI         #38     # 南瑞使用行业监控平台 platform
    PLATFORM_TIEYUE         #39     # 铁越
    PLATFORM_RAYSHARP       #40     # 安联锐视
    PLATFORM_CZWX           #41     # 创智无线
    PLATFORM_ONVIF          #42     # ONVIF
    PLATFORM_RFID           #43     # RFID
    PLATFORM_GUOBIAO        #44     # 国标
    PLATFORM_GBYFT          #45     # GuoBiaoYFT
    PLATFORM_ZWA            #46     # 之维安
    PLATFORM_HWVOIP         #47     # HWVOIP
    PLATFORM_HZTC           #48     # HZTC
    PLATFORM_JDGM           #49     # 交大光芒
    PLATFORM_TPWS           #50     # 拓普威视
	PLATFORM_YMT            #51	    # 亿码通电子
	PLATFORM_ZYWY           #52	    # 中云网眼
	PLATFORM_MTKG           #53	    # 煤炭科工
	PLATFORM_TSLIVE         #54	    # TS流
	PLATFORM_TUTK           #55     # TAIWAN TUTK
	PLATFORM_XCMJ           #55     # TAIWAN XCMJ
	PLATFORM_HNGS           #55     # TAIWAN HNGS
	PLATFORM_TIANAN         #56     # TIANAN
	PLATFORM_XIONGMAI       #57     # XIONGMAI
	PLATFORM_DAHUA          # 58    # 大华
	PLATFORM_ANNI           # 59    # 安尼
	PLATFORM_MEIDIAN        # 60    # 美电
	PLATFORM_HANBANG        # 61    # 汉邦
	PLATFORM_SZYC           # 62    # 苏州易程
	PLATFORM_IGMP           # 63
	PLATFORM_DCZU           # 64    # 动车组
    PLATFORM_END            #
)
    
for (( idx=0; idx<${#arr_platform_ids[@]}; idx+=1 )); do
    eval ${arr_platform_ids[$idx]}=$idx
done

# typedef enum E_sys_app
# SYSTEM_APP_BEGIN=-1 
arr_sys_app=(
    SYSTEM_APP_SERVER           #0 
    SYSTEM_APP_ENCODE           #1 
    SYSTEM_APP_STREAM           #2
    SYSTEM_APP_ALARM            #3 
    SYSTEM_APP_RECORD           #4 
    SYSTEM_APP_SAVE             #5 
    SYSTEM_APP_VSFTPD           #6 
    SYSTEM_APP_FTPCLIENT        #7 
    SYSTEM_APP_MOBILE           #8 
    SYSTEM_APP_HAIDOU           #9 
    SYSTEM_APP_HXHT             #10
    SYSTEM_APP_BJYJ             #11 
    SYSTEM_APP_HUAWEI           #12 
    SYSTEM_APP_DECODE           #13
    SYSTEM_APP_RTSPC            #14 
    SYSTEM_APP_ZXW              #15 
    SYSTEM_APP_LTAO             #16
    SYSTEM_APP_UI               #17 
    SYSTEM_APP_PLAY             #18 
    SYSTEM_APP_ZTE              #19 
    SYSTEM_APP_VSIP             #20 
    SYSTEM_APP_NZIT             #21 
    SYSTEM_APP_ANV              #22 
    SYSTEM_APP_XINY             #23 
    SYSTEM_APP_WANHUA           #24 
    SYSTEM_APP_MSN              #25 
    SYSTEM_APP_ZXLW             #26 
    SYSTEM_APP_LTAOOWSP         #27 
    SYSTEM_APP_ZXWNVR           #28
    SYSTEM_APP_KINGHOO          #29 
    SYSTEM_APP_JSFT             #30 
    SYSTEM_APP_BEIQING          #31
    SYSTEM_APP_TIEYUE           #32
    SYSTEM_APP_RAYSHARP         #33
    SYSTEM_APP_CZWX             #34
    SYSTEM_APP_ONVIF            #35
    SYSTEM_APP_GUOBIAO          #36
    SYSTEM_APP_HWVOIP           #37
    SYSTEM_APP_HZTC             #38
    SYSTEM_APP_TPWS             #39
    SYSTEM_APP_TSLIVE           #40
    SYSTEM_APP_HTTPD            #41
    SYSTEM_APP_TUTK             #42
    SYSTEM_APP_XCMJ             #43
    SYSTEM_APP_HNGS             #44
    SYSTEM_APP_TIANAN           #45
    SYSTEM_APP_XIONGMAI         #46
    SYSTEM_APP_DAHUA            #47
    SYSTEM_APP_ANNI             #48
    SYSTEM_APP_MEIDIAN          #49
    SYSTEM_APP_HANBANG          #50
    SYSTEM_APP_SZYC             #51
    SYSTEM_APP_DCZU             #52
    SYSTEM_APP_END              #
)

for (( idx=0; idx<${#arr_sys_app[@]}; idx+=1 )); do
    eval ${arr_sys_app[$idx]}=$idx
done
# SYSTEM_APP_E;

# typedef struct
# {
#   BOOL bValid;
#   BOOL bCheck;
#   char *szPlatformName;
#   char *szPostfix;
#   char *szPlatformNote;
#   SYSTEM_APP_E appID[PLATFORM_APP_MAX];
# } PLATFORM_INFO_S;

i_platform_name=2
i_platform_note=4
i_platform_appid=5

# in factory, decode yaffs2 is also normal, so reserve decode on normal
platforminfo=(
   "TRUE    TRUE     normal      DEVELOP      公司内部平台      '$SYSTEM_APP_MOBILE $SYSTEM_APP_GUOBIAO $SYSTEM_APP_DECODE  $SYSTEM_APP_RTSPC \
                                                                                  $SYSTEM_APP_VSFTPD $SYSTEM_APP_FTPCLIENT' " # PLATFORM_NORMAL
   "TRUE    FALSE    sv          SV           星谷平台          '$SYSTEM_APP_MOBILE  $SYSTEM_APP_FTPCLIENT'                 " # PLATFORM_SV
   "FALSE   FALSE    haidou      HD           海斗平台          '$SYSTEM_APP_HAIDOU'                                        " # PLATFORM_HAIDOU
   "TRUE    FALSE    bjyj        YJ           北京易家          '$SYSTEM_APP_BJYJ'                                          " # PLATFORM_BJYJ
   "TRUE    FALSE    hxht        HXHT         互信互通          '$SYSTEM_APP_HXHT'                                          " # PLATFORM_HXHT
   "FALSE   FALSE    yjpl        YJPL         星谷平台_易家LOGO '$SYSTEM_APP_END'                                           " # PLATFORM_YJPL
   "FALSE   FALSE    yjmb        YJMB         易家_星谷平台     '$SYSTEM_APP_BJYJ $SYSTEM_APP_MOBILE $SYSTEM_APP_FTPCLIENT' " # PLATFORM_YJMB
   "TRUE    FALSE    huawei      HUAWEI       华为平台          '$SYSTEM_APP_HUAWEI'                                        " # PLATFORM_HUAWEI
   "FALSE   FALSE    jcomb       JCOMB        公司摩比网平台    '$SYSTEM_APP_END'                                           " # PLATFORM_JCOMB
   "FALSE   FALSE    fddi        FDDI         光纤              '$SYSTEM_APP_END'                                           " # PLATFORM_FDDI
   "FALSE   FALSE    jmwc        JMWC         江门炜创          '$SYSTEM_APP_END'                                           " # PLATFORM_JMWC
   "FALSE   FALSE    handset     HANDSET      手持设备          '$SYSTEM_APP_END'                                           " # PLATFORM_HANDSET
   "FALSE   FALSE    tdhome      TDHOME       星谷TDHOME        '$SYSTEM_APP_MOBILE  $SYSTEM_APP_FTPCLIENT'                 " # PLATFORM_TDHOME
   "FALSE   FALSE    wscbpi      WSCBPI       微思创            '$SYSTEM_APP_END'                                           " # PLATFORM_WSCBPI
   "TRUE    FALSE    decode      DECODE       解码器            '$SYSTEM_APP_DECODE  $SYSTEM_APP_RTSPC'                     " # PLATFORM_DECODE
   "TRUE    FALSE    zxw         ZXW          中星微            '$SYSTEM_APP_ZXW'                                           " # PLATFORM_ZXW
   "TRUE    FALSE    ltao        LTAO         浪涛              '$SYSTEM_APP_MOBILE'                                        " # PLATFORM_LTAO
   "FALSE   FALSE    nvr         NVR          NVR               '$SYSTEM_APP_MOBILE  $SYSTEM_APP_FTPCLIENT'                 " # PLATFORM_NVR
   "TRUE    FALSE    jcomo       JCOMO        捷高行业监控      '$SYSTEM_APP_MOBILE'                                        " # PLATFORM_JCOMO
   "TRUE    FALSE    zte         ZTE          中兴平台          '$SYSTEM_APP_ZTE'                                           " # PLATFORM_ZTE
   "TRUE    FALSE    vsip        VSIP         中盛益华          '$SYSTEM_APP_VSIP'                                          " # PLATFORM_VSIP
   "TRUE    FALSE    monitor     MONITOR      行业监控          '$SYSTEM_APP_MOBILE'                                        " # PLATFORM_MONITOR
   "TRUE    FALSE    nzit        NZIT         南自信息          '$SYSTEM_APP_NZIT'                                          " # PLATFORM_NZIT
   "TRUE    FALSE    anv         ANV          安维              '$SYSTEM_APP_ANV'                                           " # PLATFORM_ANV
   "FALSE   FALSE    ptzca       PTZCA        PTZ联动           '$SYSTEM_APP_END'                                           " # PLATFORM_PTZCA
   "TRUE    FALSE    xiny        XINY         信义              '$SYSTEM_APP_XINY'                                          " # PLATFORM_XINY
   "TRUE    FALSE    wanhua      WANHUA       万华              '$SYSTEM_APP_WANHUA'                                        " # PLATFORM_WANHUA
   "TRUE    FALSE    cec         CEC          中国电子集团      '$SYSTEM_APP_MOBILE'                                        " # PLATFORM_CEC
   "TRUE    FALSE    nc          NC           南车NVR           '$SYSTEM_APP_MOBILE'                                        " # PLATFORM_NC
   "TRUE    FALSE    zxlw        ZXLW         中兴力维          '$SYSTEM_APP_ZXLW'                                          " # PLATFORM_ZXLW
   "TRUE    FALSE    zxlwl       ZXLWL        中兴力维浪涛      '$SYSTEM_APP_ZXLW $SYSTEM_APP_MOBILE'                       " # PLATFORM_ZXLWL
   "TRUE    FALSE    ltaoowsp    LTAOOWSP     浪涛OWSP          '$SYSTEM_APP_LTAOOWSP'                                      " # PLATFORM_LTAOOWSP
   "TRUE    FALSE    zxwnvr      ZXWNVR       中星微NVR         '$SYSTEM_APP_ZXWNVR'                                        " # PLATFORM_ZXWNVR
   "TRUE    FALSE    keda        KEDACOM      科达监控平台      '$SYSTEM_APP_MOBILE'                                        " # PLATFORM_KEDA
   "TRUE    FALSE    hxhtyft     HXHTYFT      互信互通英飞拓    '$SYSTEM_APP_HXHT'                                          " # PLATFORM_HXHTYFT
   "TRUE    FALSE    kinghoo     KINGHOO      金虎              '$SYSTEM_APP_KINGHOO'                                       " # PLATFORM_KINGHOO
   "TRUE    FALSE    jsft        JSFT         捷视飞通          '$SYSTEM_APP_JSFT'                                          " # PLATFORM_JSFT
   "TRUE    FALSE    bqst        BEIQING      北清视通          '$SYSTEM_APP_BEIQING'                                       " # PLATFORM_BQST
   "TRUE    FALSE    nanrui      NANRUI       南瑞平台          '$SYSTEM_APP_MOBILE $SYSTEM_APP_FTPCLIENT'                  " # PLATFORM_NANRUI
   "TRUE    FALSE    tieyue      TIEYUE       铁越              '$SYSTEM_APP_TIEYUE'                                        " # PLATFORM_TIEYUE
   "TRUE    FALSE    raysharp    RAYSHARP     安联锐视          '$SYSTEM_APP_RAYSHARP'                                      " # PLATFORM_RAYSHARP
   "TRUE    FALSE    czwx        CZWX         创智无线          '$SYSTEM_APP_CZWX'                                          " # PLATFORM_CZWX
   "TRUE    FALSE    onvif       ONVIF        ONVIF             '$SYSTEM_APP_ONVIF'                                         " # PLATFORM_ONVIF
   "TRUE    FALSE    rfid        RFID         RFID              '$SYSTEM_APP_END'                                           " # PLATFORM_RFID 
   "TRUE    FALSE    guobiao     GUOBIAO      国标              '$SYSTEM_APP_GUOBIAO'                                       " # PLATFORM_GUOBIAO
   "TRUE    FALSE    gbyft       GBYFT        GuoBiaoYFT        '$SYSTEM_APP_GUOBIAO'                                       " # PLATFORM_GBYFT
   "TRUE    FALSE    zwa         ZWA          之维安            '$SYSTEM_APP_END'                                           " # PLATFORM_ZWA
   "TRUE    FALSE    hwvoip      HWVOIP       HWVOIP            '$SYSTEM_APP_HWVOIP'                                        " # PLATFORM_HWVOIP
   "TRUE    FALSE    hztc        HZTC         HZTC              '$SYSTEM_APP_HZTC'                                          " # PLATFORM_HZTC
   "TRUE    FALSE    jdgm        JDGM         交大光芒          '$SYSTEM_APP_END'                                           " # PLATFORM_JDGM
   "TRUE    FALSE    tpws        TPWS         拓普威视          '$SYSTEM_APP_TPWS'                                          " # PLATFORM_TPWS
   "TRUE    FALSE    ymt         YMT          亿码通电子        '$SYSTEM_APP_END'                                           " # PLATFORM_YMT
   "TRUE    FALSE    zywy        ZYWY         中云网眼          '$SYSTEM_APP_END'                                           " # PLATFORM_ZYWY
   "TRUE    FALSE    mtkg        MTKG         煤炭科工          '$SYSTEM_APP_MOBILE'                                        " # PLATFORM_MTKG
   "TRUE    FALSE    tslive      TSLIVE       TS流              '$SYSTEM_APP_TSLIVE'                                        " # PLATFORM_TSLIVE
   "TRUE    FALSE    tutk        TUTK         TUTK              '$SYSTEM_APP_TUTK'                                          " # PLATFORM_TUTK
   "TRUE    FALSE    xcmj        XCMJ         西昌门禁          '$SYSTEM_APP_XCMJ'                                          " # PLATFORM_XCMJ
   "TRUE    FALSE    hngs        HNGS         沪宁高速          '$SYSTEM_APP_HNGS'                                          " # PLATFORM_HNGS
   "TRUE    FALSE    tianan      TIANAN       天安NVR           '$SYSTEM_APP_TIANAN'                                        " # PLATFORM_TIANAN
   "TRUE    FALSE    xiongmai    XIONGMAI     雄迈NVR           '$SYSTEM_APP_XIONGMAI'                                      " # PLATFORM_XIONGMAI
   "TRUE    FALSE    dahua       DAHUA        大华              '$SYSTEM_APP_DAHUA'                                         " # PLATFORM_DAHUA
   "TRUE    FALSE    anni        ANNI         安尼              '$SYSTEM_APP_ANNI'                                          " # PLATFORM_ANNI
   "TRUE    FALSE    meidian     MEIDIAN      美电              '$SYSTEM_APP_MEIDIAN'                                       " # PLATFORM_MEIDIAN
   "TRUE    FALSE    hanbang     HANBANG      汉邦              '$SYSTEM_APP_HANBANG'                                       " # PLATFORM_HANBANG
   "TRUE    FALSE    szyc        SZYC         苏州易程          '$SYSTEM_APP_SZYC'                                          " # PLATFORM_SZYC
   "TRUE    FALSE    igmp        IGMP         IGMP              '$SYSTEM_APP_END'                                           " # PLATFORM_IGMP
   "TRUE    FALSE    dczu        DCZU         动车组            '$SYSTEM_APP_DCZU'                                          " # PLATFORM_DCZU
)

# appMng从system_ctrl.c中拷贝
# reference to SYSTEM_APP_E
# SYSTEM_APP_MNG_S appMng[SYSTEM_APP_END] = 
i_app_mng_id=0
i_app_mng_name=1
i_app_mng_enable=2

app_mng=(
    "$SYSTEM_APP_SERVER       jco_server     FALSE    0  1     0  0"
    "$SYSTEM_APP_ENCODE       jco_encode     FALSE    0  1     0  0"
    "$SYSTEM_APP_STREAM       jco_stream     FALSE    0  1     0  0"
    "$SYSTEM_APP_ALARM        jco_alarm      FALSE    0  1     0  0"
    "$SYSTEM_APP_RECORD       jco_record     FALSE    0  1     0  0"
    "$SYSTEM_APP_SAVE         jco_save       FALSE    0  1     0  0"
    "$SYSTEM_APP_VSFTPD       jco_vsftpd     FALSE    0  1     0  0"
    "$SYSTEM_APP_FTPCLIENT    jco_ftpclient  FALSE    0  0     0  0"
    "$SYSTEM_APP_MOBILE       jco_mobile     FALSE    0  0     0  0"
    "$SYSTEM_APP_HAIDOU       jco_haidou     FALSE    0  0     0  0"
    "$SYSTEM_APP_HXHT         jco_hxht       FALSE    0  0     0  0"
    "$SYSTEM_APP_BJYJ         jco_bjyj       FALSE    0  0     0  0"
    "$SYSTEM_APP_HUAWEI       jco_huawei     FALSE    0  0     0  0"
    "$SYSTEM_APP_DECODE       jco_decode     FALSE    0  1     0  0"
    "$SYSTEM_APP_RTSPC        jco_rtspc      FALSE    0  1     0  0"
    "$SYSTEM_APP_ZXW          jco_zxw        FALSE    0  1     0  0"
    "$SYSTEM_APP_LTAO         jco_ltao       FALSE    0  1     0  0"
    "$SYSTEM_APP_UI           jco_ui         FALSE    0  1     0  0"
    "$SYSTEM_APP_PLAY         jco_play       FALSE    0  1     0  0"
    "$SYSTEM_APP_ZTE          jco_zte        FALSE    0  1     0  0"
    "$SYSTEM_APP_VSIP         jco_vsip       FALSE    0  1     0  0"
    "$SYSTEM_APP_NZIT         jco_nzit       FALSE    0  1     0  0"
    "$SYSTEM_APP_ANV          jco_anv        FALSE    0  1     0  0"
    "$SYSTEM_APP_XINY         jco_xiny       FALSE    0  1     0  0"
    "$SYSTEM_APP_WANHUA       jco_wanhua     FALSE    0  1     0  0"
    "$SYSTEM_APP_MSN          jco_msn        FALSE    0  1     0  0"
    "$SYSTEM_APP_ZXLW         jco_zxlw       FALSE    0  1     0  0"
    "$SYSTEM_APP_LTAOOWSP     jco_ltaoowsp   FALSE    0  1     0  0"
    "$SYSTEM_APP_ZXWNVR       jco_zxwnvr     FALSE    0  1     0  0"
    "$SYSTEM_APP_KINGHOO      jco_kinghoo    FALSE    0  1     0  0"
    "$SYSTEM_APP_JSFT         jco_jsft       FALSE    0  1     0  0"
    "$SYSTEM_APP_BEIQING      jco_beiqing    FALSE    0  1     0  0"
    "$SYSTEM_APP_TIEYUE       jco_tieyue     FALSE    0  1     0  0"
    "$SYSTEM_APP_RAYSHARP     jco_raysharp   FALSE    0  1     0  0"
    "$SYSTEM_APP_CZWX         jco_czwx       FALSE    0  1     0  0"
    "$SYSTEM_APP_ONVIF        jco_onvif      FALSE    0  1     0  0"
    "$SYSTEM_APP_GUOBIAO      jco_guobiao    FALSE    0  1     0  0"
    "$SYSTEM_APP_HWVOIP       jco_hwvoip     FALSE    0  1     0  0"
    "$SYSTEM_APP_HZTC         jco_hztc       FALSE    0  1     0  0"
    "$SYSTEM_APP_TPWS         jco_tpws       FALSE    0  1     0  0"
    "$SYSTEM_APP_TSLIVE       jco_tslive     FALSE    0  1     0  0"
    "$SYSTEM_APP_HTTPD        jco_httpd      FALSE    0  1     0  0"
    "$SYSTEM_APP_TUTK         jco_tutk       FALSE    0  1     0  0"
    "$SYSTEM_APP_XCMJ         jco_xcmj       FALSE    0  1     0  0"
    "$SYSTEM_APP_HNGS         jco_hngs       FALSE    0  1     0  0"
    "$SYSTEM_APP_TIANAN       jco_tianan     FALSE    0  1     0  0"
    "$SYSTEM_APP_XIONGMAI     jco_xiongmai   FALSE    0  1     0  0"
    "$SYSTEM_APP_DAHUA        jco_dahua      FALSE    0  1     0  0"
    "$SYSTEM_APP_ANNI         jco_anni       FALSE    0  1     0  0"
    "$SYSTEM_APP_MEIDIAN      jco_meidian    FALSE    0  1     0  0"
    "$SYSTEM_APP_HANBANG      jco_hanbang    FALSE    0  1     0  0"
    "$SYSTEM_APP_SZYC         jco_szyc       FALSE    0  1     0  0"
    "$SYSTEM_APP_DCZU         jco_dczu       FALSE    0  1     0  0"
) 

# 各个平台公共的程序、必须的程序
app_idbase=(
    $SYSTEM_APP_SERVER
    $SYSTEM_APP_ENCODE
    $SYSTEM_APP_STREAM
    $SYSTEM_APP_ALARM
    $SYSTEM_APP_RECORD
   #$SYSTEM_APP_SAVE
    $SYSTEM_APP_VSFTPD
    $SYSTEM_APP_UI
    $SYSTEM_APP_MSN
    $SYSTEM_APP_HTTPD
    $SYSTEM_APP_END
) 

# globle vars ending

function fn_cd_workingdir()
{
    cd ${SRC_PATH} >& /dev/null 
}

function fn_startup_check()
{
    [ $UID -eq 0 ]
    xert $? `$PS8` "`whoami` is current user, Please run as root" || return $?

    test -n "`which $APP_STRIP`"
    xert $? `$PS8` "There's no $APP_STRIP, please source ENV var PATH!" || return $?

    test -n "`which $MD5SUM`"
    xert $? `$PS8` "There's no $MD5SUM, please install it first" || return $?

    if ! grep "^192.168.2.254 *jabscodevsvn" /etc/hosts >& /dev/null; then
        fn_echo_succ "set domainname of jabscodevsvn"
        sed -i '/jabscodevsvn/d' /etc/hosts
        echo "192.168.2.254   jabscodevsvn" >> /etc/hosts
    fi

    if [ -n "$SKIP_SVN" ]; then
        fn_echo_warn "skip svn checkout"

        [ -d "$p_filesys" ]
        xert $? `$PS8` "$p_filesys is not exist, -k option is invalid" || return $?

        return 0
    fi

    fn_cd_workingdir
    xert $? `$PS8`  || return $?

    test `expr ${#arr_platform_ids[@]} - 1` -eq  ${#platforminfo[@]}
    xert $? `$PS8` "len of arr_platform_ids and platforminfo are not equel" || return $?

    test `expr ${#arr_sys_app[@]} - 1` -eq  ${#app_mng[@]}
    xert $? `$PS8` "len of arr_sys_app and app_mng are not equel" || return $?

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

    read_PS="Please input the platform id(0~`expr $PLATFORM_END - 1`) you want to pack: [0] "


    if [ -n "$platform_input" ] ; then
        platform_id=$platform_input
    else
        read -p "$read_PS"  platform_id
    fi

    [[ -z "$platform_id" ]] && platform_id=0

    fn_isdigit "$platform_id" && [ "$platform_id" -lt $PLATFORM_END ]

    if [ "$?" -ne 0 ] ; then
        fn_echo_fail "$platform_id is not a valid platform id"
        return 1
    fi


    [ "$platform_id" -ne "$PLATFORM_ONVIF" ]

    if [ "$?" -ne 0 ] ; then
        fn_echo_fail "PLATFORM ONVIF is fusioned into NORMAL, please use id 0!"
        return 1
    fi

    fn_echo_succ "You've choosen `fn_get_platform_info $platform_id $i_platform_note`\n"
}

function fn_sync_ini_files()
{
    local ini=$1
    local bak=${ini%.ini}_bak.ini
    local def=${ini%.ini}.def

    test -f $bak
    xert $? `$PS8`  || return $?
    test -f $def
    xert $? `$PS8`  || return $?

    cp $ini $bak 
    xert $? `$PS8`  || return $?

    cp $ini $def
    xert $? `$PS8`  || return $?

    return 0
}

function fn_makenode()
{
    [ -d "$p_filesys" ] || return 1

    ROOT=$p_filesys
    [ -e $ROOT/dev/console ] || mknod -m 600 $ROOT/dev/console c 5 1
    [ -e $ROOT/dev/null ]    || mknod -m 666 $ROOT/dev/null c 1 3
}


function fn_warn_non_exist_path() {
    if [ -n "$1" ] ; then
        fn_echo_warn "ATTENTION@|${BASH_LINENO[0]}|: Catch a non-exist path: $1\n"
    fi
}

function fn_svn_checkout()
{
    if [ -n "$SKIP_SVN" ]; then
        fn_echo_warn "skip svn checkout\n"
        rm -rf $p_release/*/*
        return 0
    fi 

    fn_cd_workingdir

    # no matter -k or not, clean
    ls | grep -v 'sh$' | grep -v common.rc | grep -v rules | xargs rm -rf 
    xert $? `$PS8` || return $?

    mkdir -p $p_release/Packages $p_release/COM
    xert $? `$PS8` "mkdir" || return $?

    if [ -d "$local_package" ]; then
        fn_echo_succ "package path: $local_package ...\n"
        rm -rf $p_package
        cp -a $local_package $p_package
        xert $? `$PS8`  || return $?
    else
        fn_warn_non_exist_path "$local_package"
        fn_echo_succ "checking package, please wait ...\n"
        svn --quiet export $svn_package package
        xert $? `$PS8` "svn" || return $?
    fi

    if [ -d "$local_bin" ]; then
        fn_echo_succ "bin path: $local_bin ...\n"
        mkdir -p $p_bin
        rm -rf $p_bin/*
        cp -a $local_bin/* $p_bin
        xert $? `$PS8`  || return $?
    else
        fn_warn_non_exist_path "$local_bin"
        fn_echo_succ "checking bin, please wait ...\n"
        svn --quiet export $svn_bin bin
        xert $? `$PS8` "svn $svn_bin" || return $?
    fi

    if [ -d "$local_filesys" ]; then
        fn_echo_succ "filesys path: $local_filesys ...\n"
        mkdir -p $p_filesys
        rm -rf $p_filesys/*
        cp -a $local_filesys/* $p_filesys/
        xert $? `$PS8`  || return $?
    else
        fn_warn_non_exist_path "$local_filesys" 
        fn_echo_succ "checking filesys, please wait ...\n"
        svn --quiet export $svn_filesys filesys
        xert $? `$PS8` "svn $svn_filesys filesys" || return $? 
    fi

    # un-comment
    cd ${p_filesys}/app/vs/conf

    local i=
    for i in config_*; do
        awk -F';' '{print $1}'  ${i} > ${PSHM}/conf && cp ${PSHM}/conf ${i}
        xert $? `$PS8` "un-comment error" || return $?
    done

    # rename
    cd $p_bin_apps

    test -f jco_anlian   && mv    jco_anlian     jco_raysharp  
    test -f jco_gb28181  && mv    jco_gb28181    jco_guobiao   
    test -f jco_guard    && rm -f jco_guard                    
    test -f jco_huasai   && mv    jco_huasai     jco_huawei    
    test -f jco_jiegao   && mv    jco_jiegao     jco_mobile    
    test -f jco_ltaosv   && rm -f jco_ltaosv                   
    test -f jco_sv       && mv    jco_sv         sv_mobile     
    test -f jco_xinyi    && mv    jco_xinyi      jco_xiny      
    test -f jco_zsyh     && mv    jco_zsyh       jco_vsip

    test -f jco_server
    xert $? `$PS8` "$PWD: rename"  || return $?
    
    # fusion
    cp -a $p_bin_apps/* $p_app_vs/                  && \
    cp -a $p_bin_drivers/* $p_extdrv/
    xert $? `$PS8` "cp" || return $?

    #
    # strip makes error: Invalid module format (-1): Exec format error
    #
    ${APP_STRIP} -S $p_extdrv/*.ko
    xert $? `$PS8` "strip" || return $?

    cp -a $p_bin_images/busybox $p_filesys/bin
    xert $? `$PS8` "cp" || return $?

    # make dev node
    fn_makenode
    xert $? `$PS8` "makenode" || return $? 

    return 0
}

function fn_sync_svn_n_upgrade()
{
    # for svn --version lower than <1.7.4>
    fn_cd_workingdir
    find -name '.svn' | xargs rm -rf

    chmod 0755 $p_upgrade/*.sh      && \
    chmod +x $p_filesys/bin/*       && \
    chmod +x $p_filesys/sbin/*      && \
    chmod +x $p_filesys/usr/bin/*   && \
    chmod +x $p_filesys/usr/sbin/*

    xert $? `$PS8` "chmod" || return $?
    # strip and install .def

    cd $p_app_vs

    jco_apps=`ls jco_* | grep -v '.def'`

    test -n "$jco_apps" 
    xert $? `$PS8` "list jco_apps" || return $? 

    local jco
    local is_new_app_found=1
    for jco in $jco_apps; do
        echo ${app_mng[@]} | grep -w "$jco" >& /dev/null
        if [ "$?" -ne 0 ] ; then
            fn_echo_warn "$p_app_vs/$jco"
            is_new_app_found=0
        fi
    done

    if [ "$is_new_app_found" -eq 0 ] ; then
        fn_echo_fail \
        "App newbies found, del it or modify <app_mng> <platforminfo> to go on!\n" \
        "If a platform is added, see PLATFORM_E in type_common.h\n"
        # return 1
    fi

    # add exec
    [ -f nzitsalesvr ] && chmod 0755 nzit* pgrtspserver

    chmod 0755 $jco_apps

    for jco in $jco_apps; do
        $APP_STRIP $jco
        xert $? `$PS8` "strip $jco" || return $?

        jco_size=`stat -c'%s' $jco`
        test "$jco_size" -lt 4500000
        xert $? `$PS8` "$jco with so big size:$jco_size" || return $?

        $APP_STRIP $jco && \
        install $jco $jco.def
        xert $? `$PS8` "strip or install" || return $?
    done

    # cleanup filesys dir
    chown -R root:root $p_filesys
    cd $p_app_vs; 
    rm -f st*
    find . -name '*.tmp' | xargs rm -f

    # remove web execute permission
    for dir in  $p_app_vs/web_sv $p_app_vs/web_decode $p_app_vs/web_nu; do
        find $dir -name '*.bak'     | xargs rm -f
        find $dir -type f -name '*' | xargs chmod -x
    done

    #
    # svn check updateStepx, 
    # we sync between svn and updateStepx manually:
    # (1) to make sure The .so jco_ files are kept only on copy,
    # (2) like rcS, not the same relative path under filesys/ and /upgrade
    #
    cd $p_upgrade
    up_dirs=`ls -d updateStep[0-9]`

    test -n "$up_dirs"
    xert $? `$PS8` "updateStep can't be null:<$up_dirs>" || return $?

    exclude_files="flash_eraseall nandwrite uboot.bin uImage"

    if [ "$skip_chk_upgrade" == true ] ; then
        fn_echo_warn "__skip__ checking upgrade changes ..."
    else
        fn_echo_succ "checking upgrade changes ..."
        for dir in $up_dirs ; do
            files=`find $p_upgrade/$dir -type f`
            test -n "$files"
            xert $? `$PS8` "no files" || return $?

            for f in $files; do
                f=${f##$p_upgrade/$dir/}
                [ "$f" == "readme.txt" ] && continue        # no files in updateStep9 2012-07-16

                echo $exclude_files | grep -w "$f" >& /dev/null  && continue

                f_up=$p_upgrade/$dir/$f

                if [ "$f" == "rcS" ] ; then
                    f_yfs="$p_filesys/etc/init.d/rcS"
                else
                    f_yfs=`find $p_filesys -name "${f##*/}"`
                fi

                test -f "$f_yfs"
                xert $? `$PS8` "ambiguous file of $f_up:$f_yfs" || return $?

                diff $f_yfs $f_up >& /dev/null

                if [ "$?" -ne 0 ] ; then
                    if echo $f_yfs | grep -q -v extdrv; then
                        fn_echo_warn "   Newbie: $f_yfs \n" # no tips for .ko file
                    fi
                    cp -a $f_yfs $f_up
                    xert $? `$PS8` "cp fail, please check" || return $?
                fi
            done
        done
    fi

    #
    # update UBL, uboot, kernel
    #
    cd $p_bin_images
    install UBL_DM36x_NAND.bin          $p_release/COM && \
    install u-boot-1.3.4-dm365_evm.bin  $p_release/COM && \
    install uImage                      $p_release/COM

    xert $? `$PS8` "install $PWD" || return $?

    fn_echo_succ "fusing ubl and u-boot together to uboot.bin\n"
    chmod +x $tool_imgtool
    $tool_imgtool --rtype uboot >& /dev/null   

    install uboot.bin   $p_upgrade/updateStep5/    && \
    install uImage      $p_upgrade/updateStep5/ 
    xert $? `$PS8` "uboot.bin uImage" || return $?

    $MD5SUM uboot.bin   >> $md5check_file       && \
    $MD5SUM uImage      >> $md5check_file
    xert $? `$PS8` "$MD5SUM error" || return $?

    fn_echo_succ "svn update ending ...\n"
}

function fn_pack_booter_ker_only()
{
    [ "$booter_kernel_only" != "true" ] && return 0

    mkdir -p $p_package/booter_kernel/lot
       rm -f $p_package/booter_kernel/lot/*
    cp -a $p_upgrade/updateStep5/* $p_package/booter_kernel/lot
    xert $? `$PS8` "cp" || return $?

    cd $p_package/booter_kernel/lot

    chmod +x uImage uboot.bin flash_eraseall nandwrite
    xert $? `$PS8` "chmod err" || return $?

    local md5file=booter_kernel.md5
    $MD5SUM uboot.bin   >> $md5file       && \
    $MD5SUM uImage      >> $md5file
    xert $? `$PS8` "$MD5SUM err" || return $?

    cat <<-"HERE" > $p_package/booter_kernel/updateExt.sh

function xert() 
{
    [ "${1}" -eq 0 ] && return ${1}
    echo ${@:2}
    return ${1}
}

function fn_md5()
{
    local MD5SUM=md5sum
    local md5ed_file

    md5sum_file=booter_kernel.md5
    cat $md5sum_file
    xert $? `$PS8` "$md5sum_file" || return $?

    while read -p "read md5sum and file" sum md5ed_file; do
        echo "check <${PWD}> <${sum}> <${md5ed_file}>"
        rela_path=`find -name ${md5ed_file##*/}`

        bbox_sum=`$MD5SUM $rela_path | awk '{print $1}'`
        test "$sum" == "$bbox_sum" 
        xert $? `$PS8` "$rela_path is damaged with $bbox_sum" || return $?
    done < ${md5sum_file}

    return 0
}

function fn_up_boot_ker()
{
    echo " 
    -------------------------------------------------------
                Upgrade boot and kernel begin
    -------------------------------------------------------
    "

    # feed wdt
    echo 1 > /dev/watchdog
    cd /app/vs/lot

    fn_md5 
    xert $? `$PS8` || return $?

    chmod +x *
    ./flash_eraseall /dev/mtd0
    ./nandwrite -p /dev/mtd0 uboot.bin

    ./flash_eraseall /dev/mtd2
    ./nandwrite -p /dev/mtd2 uImage

    cd .. && rm -rf lot
    rm -f updateExt.sh

    echo " 
    -------------------------------------------------------
                Upgrade boot and kernel success
    -------------------------------------------------------
    "

    sync && sleep 1 && sync && sleep 1

    rebootd
}

fn_up_boot_ker >> /app/vs/web_nu/upgrade.log 2>&1

HERE

    cd $p_package/booter_kernel/
    chmod +x updateExt.sh
    tar -zcf $p_release/Packages/upgrade_booter_kernel.tgz lot updateExt.sh
    xert $? `$PS8` tar || return $?

    [ -d /winc/20181010_GEN/Packages/ ] && \
        cp $p_release/Packages/upgrade_booter_kernel.tgz /winc/20181010_GEN/Packages/
    fn_echo_succ "\nPack booter & kernel succ, enyoy it!   \n"

    exit 0
}

# 2d array operate

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

# arr[rec][item] = val
function fn_set_2d_array_item()
{
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

function fn_set_platform_info()
{
    fn_set_2d_array_item platforminfo $@
    return $?
}

function fn_get_platform_info()
{
    fn_get_2d_array_item platforminfo $@
    return $?
}

function fn_set_app_mng()
{
    fn_set_2d_array_item app_mng_tmp $@
    return $?
}

function fn_get_app_mng()
{
    fn_get_2d_array_item app_mng_tmp $@
    return $?
}



# $1
function fn_make_platform()
{
    fn_isdigit $1
    xert $? `$PS8` "<$1> must be digit" || return $?

    platform_name=`fn_get_platform_info $1 $i_platform_name`

    test -n "$platform_name"
    xert $? `$PS8` "platform_name is:<$platform_name>"  || return $?

    # format
    eval "`printf "LANG=GB2312 sed '/^platform/c %-31s= %-15s; Platform Name' %s > %s" \
                "platform" "$platform_name" "${confserv_ini/.ini/.def}" "$confserv_ini"`"

    xert $? `$PS8` "sed $platform_name" || return $?

    fn_sync_ini_files $confserv_ini
    xert $? `$PS8`  || return $?

    # in js val must be quoted, szPLName = "val"
    if [ "$newweb" != true ] ; then
        sed -i "/^var szPLName/c var szPLName = \"$platform_name\";" $jsgeneral 
        xert $? `$PS8` "sed $jsgeneral" || return $?
    fi
}

function fn_set_app_true()
{
    app_mng_len=${#app_mng_tmp[@]}

    local id

    # set app_idbase true 
    local idx
    for (( idx=0; idx<${app_mng_len}; idx+=1 )); do
        id=`fn_get_app_mng $idx $i_app_mng_id`
        xert $? `$PS8` || return $?
        
        echo ${app_idbase[@]} | grep --color -w $id >& /dev/null

        if [ "$?" -eq 0 ] ; then
            fn_set_app_mng $idx $i_app_mng_enable TRUE
            xert $? `$PS8` || return $?
        fi
    done

    # bridge
    # set platform_id true
    custom_appids=(`fn_get_platform_info $platform_id $i_platform_appid`)
    xert $? `$PS8` "<$platform_id> <$i_platform_appid>"|| return $?

    for appid in ${custom_appids[@]}; do
        [ $appid -eq "$SYSTEM_APP_END" ] && continue
        fn_set_app_mng $appid $i_app_mng_enable TRUE
        xert $? `$PS8` || return $?
    done
}

function fn_clean_redundant_app()
{
    # cleanup
    rm -rf $p_upgrade/vs

    # copy vs
    cp -a $p_filesys/app/vs $p_upgrade
    chown -R root:root $p_upgrade/vs
    xert $? `$PS8`  || return $?

    # remove some files to reduce update packet
    rm -rf $p_upgrade/vs/fonts
    rm -rf $p_upgrade/vs/jco_*.def
    rm -rf $p_upgrade/vs/web

    local idx
    for (( idx=0; idx<$SYSTEM_APP_END; idx+=1 )); do
        en=`fn_get_app_mng $idx $i_app_mng_enable`
        xert $? `$PS8` || return $?

        if [ "$en" != "TRUE"  ] ; then
            app_name=`fn_get_app_mng $idx $i_app_mng_name`
            xert $? `$PS8` "fn_get_app_mng $idx $i_app_mng_name" || return $?

            rm -rf $p_upgrade/vs/$app_name
            rm -rf $p_app_vs/$app_name*
        fi
    done

    # because KERNEL of 20121207(LTE 4G), rm file will fail
}

# make full.tgz, $MD5SUM, then normal.tgz
function fn_make_tar()
{
    #
    #
    # From this line, no file add and del, _forbid_ any change
    #
    fn_echo_succ "tar ..."

    cd $p_upgrade
    up_dirs=`ls -d updateStep[0-9]`

    test -n "$up_dirs"
    xert $? `$PS8` "updateStep can't be null:<$up_dirs>" || return $?

    cd $p_upgrade
    mv updateStep5/uboot.bin  updateStep5/uImage ./

    for dir in $up_dirs; do

        tar czf vs/$dir.tgz $dir
        xert $? `$PS8` "tar czf vs/$dir.tgz $dir" || return $?

        $MD5SUM vs/$dir.tgz >> $md5check_file
        xert $? `$PS8` "$MD5SUM error" || return $?

        test -f $dir.sh
        xert $? `$PS8` "$dir.sh is not exist" || return $?

        cp $dir.sh vs
    done

    cp updateStart.sh vs/
    xert $? `$PS8` cp || return $?

    # outside vs _to_ reduce extract time
    mv vs/updateStep*.tgz .
    xert $? `$PS8`  || return $?

    cd $p_upgrade/vs
    ls jco* | xargs > FACEBOOK

    tar -czf ../jco.tgz jco_*
    xert $? `$PS8` "tar jco fail" || return $?
    rm -f jco_*

    tar -czf ../full.tgz *
    xert $? `$PS8` "tar fail" || return $?

    # copy full.tgz
    tag_date=".`date +%Y_%m_%d`"
    pkg_release=$p_release/Packages/$platform_name${plt_sign}${tag_sign}${tag_date}.tgz

    $MD5SUM $p_upgrade/full.tgz >> $md5check_file
    xert $? `$PS8` "$MD5SUM error" || return $?

    $MD5SUM $p_upgrade/jco.tgz >> $md5check_file
    xert $? `$PS8` "$MD5SUM error" || return $?

    cd $p_upgrade

    mkdir -p conf && cp vs/conf/config_update.ini conf
    tar -zcf $pkg_release updateExt.sh common.rc full.tgz jco.tgz md5.checks conf updateStep*.tgz uboot.bin uImage
    xert $? `$PS8` "tar error" || return $?

    chmod +x $p_package/script/jco_crypt
    if [ "$crypt" = "true" ] ; then
        $p_package/script/jco_crypt enc $pkg_release
        xert $? `$PS8` "crypt error" || return $?
    fi

    $MD5SUM ${pkg_release} >> $md5check_file
    xert $? `$PS8` "$MD5SUM error" || return $?


    stat $pkg_release >& /dev/null
    xert $? `$PS8` "$pkg_release not exist" || return $?

    echo "    $pkg_release: `stat -c'%s' $pkg_release`"
    echo "
    update command:
    curl -F 'file=@${pkg_release};' 192.168.2.45/webs/updateCfg
    "

}

function fn_make_filesys()
{

    if [ "$no_mkyaffs2" == true ] ; then
        fn_echo_warn "don't make yaffs2 ..."
        return
    fi
    fn_echo_succ "making yaffs2 ..."

    cd $p_filesys 
    fs_size=`du -s --block-size=1 | awk '{print $1}'`

    test "$fs_size" -lt 95000000 
    xert $? `$PS8` "filesys too big size=$fs_size" || return $?

    # make filesys
    fn_cd_workingdir
    chmod +x $tool_mkyaffs2image365
    $tool_mkyaffs2image365 $p_filesys filesys.yaffs2 > /dev/null
    xert $? `$PS8` "" || return $?

    #
    fs_size=`stat -c'%s' $p_filesys`
    xert $? `$PS8` "$p_filesys not exist" || return $?

    test "$fs_size" -lt 90000000
    xert $? `$PS8` "filesys.yaffs2 too big size=$fs_size" || return $?

    # Why don't store as filesys.yaffs2, 
    # 'cause more than 1 platform could be generated at once.
    mv filesys.yaffs2 $p_release/COM/filesys_$platform_name.yaffs2
    fs_size=`stat -c'%s' $p_release/COM/filesys_$platform_name.yaffs2`
    xert $? `$PS8` "file stat fail" || return $?

    echo "    $p_release/COM/filesys_$platform_name.yaffs2: $fs_size"

    # update readme.txt
    readme=$p_release/COM/readme_$platform_name.txt

    cp $p_package/tools/tftpd32.exe          $p_release/COM/
    cp $p_package/readme_Packages/readme.txt $p_release/Packages/readme.txt
    cp $p_package/readme_COM/readme.txt      $readme

    sed -i "s/yaffs2.image.file/filesys_$platform_name.yaffs2/g" $readme
    xert $? `$PS8` "sed" || return $?

    # fs_size_hex=`echo "ibase=10; obase=16; $fs_size" | bc`

    return 0
}


function fn_opt_dbgpack()
{
    #
    # dbgpack must decoupling with rcS inittab
    #

    fn_echo_succ "Customize ${FUNCNAME/fn_opt_/}  ..."

    local FS_ROOT=$p_filesys

    sed -i '/ttyS0 115200/s/#//g' $FS_ROOT/etc/inittab 
    xert $? `$PS8` "sed" || return $?

    # when start, keep 192.168.1.217 
    sed -i -e '/telnetd/s/#//g' $FS_ROOT/etc/init.d/rcS
    xert $? `$PS8` "sed" || return $?

    pkdate=`date +'%F.%T'`

    sed -i  "/ifconfig eth0/i\ulimit -c 0 # zhangj $pkdate" $FS_ROOT/etc/init.d/rcS
    xert $? `$PS8` "sed" || return $?

    sed -i "s/ulimit -c .*/ulimit -c 0 # zhangj/g" $FS_ROOT/app/vs/auto_run.sh
    xert $? `$PS8` "sed" || return $?

    cp  $FS_ROOT/bin/busybox           \
        $FS_ROOT/etc/inittab           \
        $FS_ROOT/etc/init.d/rcS        \
        $p_upgrade/updateStep0

    xert $? `$PS8`  || return $?

    return 0
}

function fn_opt_user_passwd()
{
    # default user passwd is admin/admin
    test -n "$1"
    xert $? `$PS8`  || return $?

    LANG=GB2312 sed -i "/\[admin\]/,/\[/s/^admin\>/$1/" $confuser_ini
    xert $? `$PS8`  || return $?

    sed -i "/tag_customize_username/s/admin/$1/" ${js_login}
    xert $? `$PS8`  || return $?

    if [ -n "${2}" ] ; then
        LANG=GB2312 sed -i "/\[admin\]/,/\[/s/= *admin\>/= $2/" $confuser_ini
        xert $? `$PS8`  || return $?
    fi

    fn_sync_ini_files $confuser_ini
    xert $? `$PS8` || return $?
    
    return $?
}

function fn_opt_ip()
{
    VIP=${1:-192.168.2.45}
    MASK=${2:-255.255.255.0}
    GATEWAY=${3:-${VIP%.*}.1}

    [ -n "$2" ] && VIP=$1

    fn_echo_succ "Customize ${FUNCNAME/fn_opt_/}  ..."
    fn_validate_ip $VIP || VIP=
    xert $? `$PS8` "invalid IP ${1}" || return $?

    local plt=
    for plt in '' sv keda; do
        fn_ini_set "$confserv_ini" eth${plt} ipaddr $VIP
        xert $? `$PS8` "sed $confserv_ini" || return $?

        fn_ini_set "$confserv_ini" eth${plt} submask ${MASK}
        xert $? `$PS8` "sed $confserv_ini" || return $?

        fn_ini_set "$confserv_ini" eth${plt} gateway ${GATEWAY}
        xert $? `$PS8` "sed $confserv_ini" || return $?
    done

    if [ "${newweb}" = "true" ] ; then
        js_sys=${p_app_vs}/web_nu/js/sysinfo.js
        jsnetethnet=${p_app_vs}/web_nu/js/networksetting.js
    fi

    sed -i "s/192.168.1.217/${VIP}/g" ${js_sys}
    xert $? `$PS8`  || return $?
    sed -i "s/192.168.1.217/${VIP}/g" ${jsnetethnet}
    xert $? `$PS8`  || return $?

    fn_sync_ini_files $confserv_ini
    xert $? `$PS8`  || return $?
}

function fn_opt_def_lang_CHN()
{
    sed -i "/tag_lang_default/s/1:/0:/" ${jsgeneral} && \
    sed -i "/tag_lang_default/s/1:/0:/" ${js_login}
    xert $? `$PS8`  || return $?
}

function fn_opt_def_osd_channelname()
{
    fn_echo_succ "\nset default osd channelname ..."

    # $1 is set, use $1, or xx-1
    fn_ini_set "$confvi_ini" osd.channelname.chn0 value "${1:-"台标-1 ;"}"
    xert $? `$PS8` "$FUNCNAME" || return $?

    fn_sync_ini_files $confvi_ini
    xert $? `$PS8` || return $?
}

function fn_opt_def_serv_addr()
{
    fn_echo_succ "\nset default server address ..."

    local servaddr=192.168.1.99
    fn_ini_set "$confserv_ini" jcomo serveraddr $servaddr
    xert $? `$PS8` "sed $confserv_ini" || return $?

    fn_sync_ini_files $confserv_ini
    xert $? `$PS8` || return $?
}

function fn_opt_del_nzit_apps()
{
    rm -f $p_app_vs/nzit*
    rm -f $p_app_vs/pgrtspserver
    rm -f $p_app_vs/nzitrtp_loop.sh
}

function fn_opt_common_osdfonts() {
    sed -i '/preloadable_libiconv/d' ${p_filesys}/etc/profile
    echo "export LD_PRELOAD=/lib/preloadable_libiconv.so" >> ${p_filesys}/etc/profile

    mkdir -p $p_app_vs/osdfont
    # for sake of go-and-come upgrade, only add
    if [ "${use_osdfont_48x48}" = true ] && [ -d $p_bin/ref_48x48 ]; then
        grep -q OSD_MAX_48X48 ${p_app_vs}/jco_encode
        xert $? `$PS8` "48x48 is needed"  || return $?

        fn_echo_succ "cp common osdfont"
        cp -a $p_bin/ref_48x48/osdfont/* $p_app_vs/osdfont
        cp -a $p_bin/ref_48x48/osdfont/* $p_app_vs/fonts
    else
        grep -q OSD_MAX_24X32 ${p_app_vs}/jco_encode
        xert $? `$PS8` "24x32 is needed"  || return $?
    fi

    if [ -d "$p_bin/common/osdfont" ]; then
        fn_echo_succ "cp common osdfont"
        cp -a $p_bin/common/osdfont/* $p_app_vs/osdfont
        cp -a $p_bin/common/osdfont/* $p_app_vs/fonts        # for com pkg and NFS 

    fi 
}

function fn_opt_osd() {
        if [ ! -d "$p_bin_ref_plt4m/osdfont" ] ; then
            fn_echo_warn "ATTENTION: no osdfont customized"
            return 0;
        fi

        mkdir -p $p_app_vs/osdfont
        cp -a $p_bin_ref_plt4m/osdfont/* $p_app_vs/osdfont
        xert $? `$PS8` "cp osdfont" || return $?

        cp -a $p_bin_ref_plt4m/osdfont/* $p_app_vs/fonts    # for com pkg and NFS
        xert $? `$PS8` "$p_bin_ref_plt4m process err" || return $?
        echo
}

function fn_opt_platform()
{
    local i
    case $platform_id in
    $PLATFORM_SV)
        chmod +x $p_app_vs/sv_mobile
        cp $p_app_vs/sv_mobile $p_app_vs/jco_mobile
        xert $? `$PS8` "mv $p_app_vs/jco_sv error" || return $?
        ;;
    $PLATFORM_XCMJ)
        cp -a $p_bin_ref_plt4m/*.pcm $p_app_vs
        xert $? `$PS8` "$p_bin_ref_plt4m process err" || return $?
        echo
        ;;
    $PLATFORM_NZIT)
        chmod 0755 $p_bin_ref_plt4m/nzit*  $p_bin_ref_plt4m/pgrtspserver
        cp -a $p_bin_ref_plt4m/nzit*  $p_bin_ref_plt4m/pgrtspserver $p_app_vs
        xert $? `$PS8` "$p_bin_ref_plt4m process err" || return $?
        echo
        ;;
    $PLATFORM_NORMAL)
        fn_opt_osd
        xert $? `$PS8`  || return $?
        ;;
    $PLATFORM_BQST)
        fn_opt_osd
        xert $? `$PS8`  || return $?
        ;;
    $PLATFORM_ZXW)
        fn_opt_osd
        xert $? `$PS8`  || return $?
        ;;
    $PLATFORM_GBYFT)
        INFINOVA_PTZ=true
        ;;
    $PLATFORM_KEDA)
        # set defaut language Chinese
        fn_opt_def_lang_CHN
        xert $? `$PS8`  || return $?

        # OSD name
        fn_opt_def_osd_channelname
        xert $? `$PS8`  || return $?

        # SERV ADDR
        fn_opt_def_serv_addr
        xert $? `$PS8`  || return $?
        ;;

    $PLATFORM_ZYWY)
        fn_opt_ip 192.168.1.10
        xert $? `$PS8`  || return $?

        fn_ini_set "$confserv_ini" devinfo name "中云网眼"
        xert $? `$PS8`  || return $?
        fn_sync_ini_files $confserv_ini
        xert $? `$PS8` || return $?

        fn_opt_def_osd_channelname "中云网眼"
        xert $? `$PS8`  || return $?
        ;;
    $PLATFORM_NC)
        # 没有1080p，只操作720p(3) d1 cif(1)
        for (( i=0; i<=5; i+=1 )); do
           # base idr
            fn_ini_set "$confvechn_ini" profile_${i} profile    2
            fn_ini_set "$confvechn_ini" profile_${i} bIDREnable 1
        done
        # 1080p  720p cif level-10
        fn_ini_set "$confvechn_ini" profile_1 level      10
        fn_ini_set "$confvechn_ini" profile_3 level      10
        fn_ini_set "$confvechn_ini" profile_5 level      10

        fn_sync_ini_files $confvechn_ini
        xert $? `$PS8`  || return $?
        ;;
    $PLATFORM_RAYSHARP)
        # 没有1080p，只操作720p(3) d1 cif(1)
        for (( i=1; i<=3; i+=1 )); do
           # base 40 idr
            fn_ini_set "$confvechn_ini" profile_${i} profile    2
            fn_ini_set "$confvechn_ini" profile_${i} level      40
            fn_ini_set "$confvechn_ini" profile_${i} bIDREnable 1
        done

        fn_sync_ini_files $confvechn_ini
        xert $? `$PS8`  || return $?

        echo "vechn customizing ..."
        fn_ini_set "$confvechn_ini" ve_attr.normal chns "2,3,0,0,25,2048,30,0,1,:2,1,0,0,25,2048,30,0,1,:"
        xert $? `$PS8`  || return $?

        fn_sync_ini_files $confvechn_ini
        xert $? `$PS8`  || return $?
        ;;
    $PLATFORM_RFID|$PLATFORM_MTKG)
        local FS_ROOT=$p_filesys
        # disable /sbin/getty in /etc/inittab
        sed -i '/ttyS0 115200/s/^/#/g' $FS_ROOT/etc/inittab 
        xert $? `$PS8`  || return $?

        cp $FS_ROOT/etc/inittab $p_upgrade/updateStep0
        xert $? `$PS8`  || return $?
        ;;
    $PLATFORM_HWVOIP)
        for (( i=0; i<=5; i+=1 )); do
            # base 30 idr
            fn_ini_set "$confvechn_ini" profile_${i} profile    2
            fn_ini_set "$confvechn_ini" profile_${i} level      30
            fn_ini_set "$confvechn_ini" profile_${i} bIDREnable 1
        done

        fn_sync_ini_files $confvechn_ini
        xert $? `$PS8`  || return $?
        ;;
    $PLATFORM_GUOBIAO)
        for (( i=0; i<=5; i+=1 )); do
            # QCIF-1080p main-level30, no idr
            fn_ini_set "$confvechn_ini" profile_${i} profile    1
            fn_ini_set "$confvechn_ini" profile_${i} level      30
            fn_ini_set "$confvechn_ini" profile_${i} bIDREnable 0
        done

        fn_sync_ini_files $confvechn_ini
        xert $? `$PS8`  || return $?
        ;;
    $PLATFORM_TIANAN)
        cp -a $p_bin_ref_plt4m/*.so ${p_filesys}/usr/lib
        xert $? `$PS8`  || return $?

        cp -a $p_bin_ref_plt4m/*.so ${p_upgrade}/updateStep0
        xert $? `$PS8`  || return $?
        ;;
    *)
        ;;
    esac

    return 0
}

function fn_opt_xld_platform()
{
    if [ "$platform_id" -ne "$PLATFORM_NZIT" ]; then
        fn_opt_del_nzit_apps
    fi

    if [ "$platform_id" -ne "$PLATFORM_DECODE" ]; then
        rm -rf $p_app_vs/web_decode
    fi

    if [ "$platform_id" -ne "$PLATFORM_SV" ]; then
        rm -f $p_app_vs/sv_mobile
        rm -f $p_app_vs/../extdrv/GobiNet3.ko
        rm -f $p_app_vs/../extdrv/GobiSerial3.ko
        rm -f $p_upgrade/updateStep1/GobiNet3.ko
        rm -f $p_upgrade/updateStep1/GobiSerial3.ko
        rm -rf $p_app_vs/web_sv
    fi

}

function fn_opt_verify_version()
{
    fn_echo_succ "\nCustomize ${FUNCNAME/fn_opt_/}  ..."

    local t_string='T%d.%d.%04X-%s-%s'
    local v_string=${t_string/T/V}

    local count=`grep -c "$t_string" $f_bin_server`
    test $count -eq 1
    xert $? `$PS8` "count err: $count" || return $?

    sed -i "s/${t_string}/${v_string}/g" $f_bin_server
    xert $? `$PS8`  || return $?
}

function fn_lamp60HZ() {
    # default is 50HZ
    echo "lampfrequency 60 ..."
    fn_ini_set "$confvi_ini" vi_attr.chn0 lampfrequency 0
    xert $? `$PS8`  || return $?

    fn_sync_ini_files $confvi_ini
    xert $? `$PS8`  || return $?
}

function fn_opt_chns() {

    local chns="$1"
    echo "chns $chns ..."

    fn_ini_set "$confvechn_ini" ve_attr.normal chns "$chns"
    xert $? `$PS8`  || return $?

    fn_sync_ini_files $confvechn_ini
    xert $? `$PS8`  || return $?
}

function fn_opt_disable_osd_bps() {
    # default is enable
    echo "customizing osd.bps disable ..."
    fn_ini_set "$confvi_ini" osd.bps.chn0 enable 0
    xert $? `$PS8`  || return $?

    fn_sync_ini_files $confvi_ini
    xert $? `$PS8`  || return $?
}

function fn_opt_fix_defreso()
{
    echo "customizing fix_defreso ..."
    # auto_run.sh
    sed -i 's#vs/jco_server#vs/jco_server -o1#g' $p_app_vs/auto_run.sh
    num_serv=`grep -c -- 'jco_server -o1' $p_app_vs/auto_run.sh`
    [ "$num_serv" -eq 1 ]
    xert $? `$PS8`  || return $?

}

function fn_opt_def_fps()
{
    [ "${1}" -eq 25 ] || [ "${1}" -eq 30 ]
    xert $? `$PS8`  || return $?

    local fps=$1
				
    local  chns_720p="2,3,0,0,25,4096,25,0,0,:2,1,0,0,15,512,15,0,0,: "
    local chns_1080p="2,5,0,0,25,8192,25,0,0,:2,1,0,0,15,512,15,0,0,: "
    local  zxlw_720p="2,3,0,0,${fps},3000,${fps},0,0,:2,2,0,0,20,512,20,0,0,: "
    local zxlw_1080p="2,5,0,0,${fps},6000,${fps},0,0,:2,2,0,0,20,512,20,0,0,: "
    echo sed -i -e \"s/${chns_720p}/${zxlw_720p}/g\"     \
            -e \"s/${chns_1080p}/${zxlw_1080p}/g\" ${f_bin_server}
    sed -i -e "s/${chns_720p}/${zxlw_720p}/g"     \
            -e "s/${chns_1080p}/${zxlw_1080p}/g" ${f_bin_server}*
    xert $? `$PS8` "sed error: ${f_bin_server}" || return $?

    # modify default value on webpage
    sed -i -e "/fps_bps_gop__1080P/s/25,8192,25/${fps},6000,${fps}/g"  \
           -e "/fps_bps_gop__720P/s/25,4096,25/${fps},3000,${fps}/g"  \
           -e "/fps_bps_gop__D1/s/25,2048,25/20,512,20/g" ${js_vavideochn}
    xert $? `$PS8`  || return $?
}

i_reso_qcif=0
i_reso_cif=1
i_reso_d1=2
i_reso_720p=3
i_reso_uvga=4
i_reso_1080p=5

function fn_customize_reso()
{
    [ "${#}" -eq 3 ]
    xert $? `$PS8`  || return $?

    local i_reso_=$1
    fn_ini_set "$confveopt_ini" ve_size.index${i_reso_} width  ${2}    && \
    fn_ini_set "$confveopt_ini" ve_size.index${i_reso_} height ${3} 
    xert $? `$PS8`  || return $?
    fn_sync_ini_files $confveopt_ini
    xert $? `$PS8`  || return $?

    return $?
}

function fn_opt_input() {
    case $1 in
    1)  # 1080p_f30_6k_g25 + bps.disable
        fn_opt_chns "2,5,0,0,30,6000,25,1,0,:"
        xert $? `$PS8`  || return $?

        fn_opt_disable_osd_bps
        xert $? `$PS8`  || return $?

        fn_lamp60HZ
        xert $? `$PS8`  || return $?

        fn_opt_fix_defreso
        xert $? `$PS8`  || return $?
        ;;
    2)
        fn_opt_ip 192.168.123.100
        xert $? `$PS8`  || return $?

        fn_opt_user_passwd root admin
        xert $? `$PS8`  || return $?
        ;;
    3|4)
        if [ "${1}" = 3 ] ; then
            CUSTOMIZE_NAME="ANC-320/I14FBS"         # 720p
        else
            CUSTOMIZE_NAME="ANC-320/I24FBS"         # 1080p
        fi
        # AvTrace
        fn_opt_ip 192.168.168.111
        xert $? `$PS8`  || return $?

        # osd name 1~14
        sed -i '/IDC_NAME_CONTENT/s#12#14#g' ${p_app_vs}/web_nu/language/chinese.js          
        sed -i '/IDC_NAME_CONTENT/s#12#14#g' ${p_app_vs}/web_nu/language/english.js           
        sed -i '/IDC_NAME_CONTENT/s#12#14#g' ${p_app_vs}/web_nu/asp/vavideopara.asp 
        sed -i '/id="name"/s#12#14#g'       ${p_app_vs}/web_nu/asp/vavideopara.asp 
        sed -i '/name.length.*name/s#12#14#g' ${p_app_vs}/web_nu/js/vavideopara.js

        fn_echo_succ "Customize osd..."
        fn_ini_set "$confserv_ini" devinfo name "${CUSTOMIZE_NAME}" && \
        fn_ini_set "$confvi_ini" osd.time.chn0 top576   560         && \
        fn_ini_set "$confvi_ini" osd.time.chn0 left576  640         && \
        fn_ini_set "$confvi_ini" osd.time.chn0 top720   708         && \
        fn_ini_set "$confvi_ini" osd.time.chn0 left720  1104        && \
        fn_ini_set "$confvi_ini" osd.time.chn0 top1080  1050        && \
        fn_ini_set "$confvi_ini" osd.time.chn0 left1080 1657        && \
        fn_ini_set "$confvi_ini" osd.bps.chn0  enable   0           && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 left    7   && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 top720  10  && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 top1080 10  && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 value   "${CUSTOMIZE_NAME}"
        xert $? `$PS8`  || return $?

        fn_sync_ini_files $confserv_ini
        xert $? `$PS8`  || return $?

        fn_sync_ini_files $confvi_ini
        xert $? `$PS8`  || return $?

        fn_opt_web 4
        xert $? `$PS8`  || return $?
        ;;
    5)
        fn_opt_ip 192.168.1.253
        xert $? `$PS8`  || return $?

        fn_opt_user_passwd admin 9999
        xert $? `$PS8`  || return $?

        fn_opt_web 5
        xert $? `$PS8`  || return $?
        ;;
    6)
        fn_opt_ip 192.168.0.100
        xert $? `$PS8`  || return $?

        fn_opt_user_passwd admin 888888
        xert $? `$PS8`  || return $?

        local  chns_720p="2,3,0,0,25,4096,25,0,0,:2,1,0,0,15,512,15,0,0,: "
        local chns_1080p="2,5,0,0,25,8192,25,0,0,:2,1,0,0,15,512,15,0,0,: "
        local  hanb_720p="2,3,0,0,25,4000,25,0,0,:2,2,0,0,25,1500,25,0,0,:"
        local hanb_1080p="2,5,0,0,25,6000,25,0,0,:2,2,0,0,25,1500,25,0,0,:"
        echo sed -i -e \"s/${chns_720p}/${hanb_720p}/g\"     \
                -e \"s/${chns_1080p}/${hanb_1080p}/g\" ${f_bin_server}
        sed -i -e "s/${chns_720p}/${hanb_720p}/g"     \
                -e "s/${chns_1080p}/${hanb_1080p}/g" ${f_bin_server}*
        xert $? `$PS8` "sed error: ${f_bin_server}" || return $?
        ;;

    7)
        fn_opt_ip 192.168.1.2       255.255.255.0       192.168.1.1
        xert $? `$PS8`  || return $?

        fn_opt_user_passwd admin 12345
        xert $? `$PS8`  || return $?
        
        fn_ini_set "$confserv_ini" guobiao manufacturer "ZNV"
        xert $? `$PS8`  || return $?
        fn_sync_ini_files $confserv_ini
        xert $? `$PS8` || return $?
        ;;

    8)
        sed -i '/\[admin/aabc                            = 123' $confuser_ini
        xert $? `$PS8`  || return $?
        fn_sync_ini_files $confuser_ini
        xert $? `$PS8` || return $?

        sed -i '/usrname.*admin/s/admin/abc/g' ${js_login}
        xert $? `$PS8`  || return $?
        ;;

    9)
        echo "replace 30fps to 25fps..."

        sed -i '/tag_for_30to25/s/30/25/g' ${p_web_nu}/asp/vavideochn.asp
        sed -i '/tag_for_30to25/s/30/25/g' ${p_web_nu}/js/vavideochn.js
        sed -i '/tag_for_30to25/s/30/25/g' ${p_web_nu}/language/chinese.js
        sed -i '/tag_for_30to25/s/30/25/g' ${p_web_nu}/language/english.js
        xert $? `$PS8`  || return $?
        ;;

    10)
        fn_opt_user_passwd admin 123456
        xert $? `$PS8`  || return $?

        fn_opt_ip 192.168.1.71 255.255.0.0
        xert $? `$PS8`  || return $?

        local fps=10
        local CUSTOMIZE_NAME="K12345 1-1"
                    
        # on FACTORY default
        local  chns_720p="2,3,0,0,25,4096,25,0,0,:2,1,0,0,15,512,15,0,0,: "
        local chns_1080p="2,5,0,0,25,8192,25,0,0,:2,1,0,0,15,512,15,0,0,: "
        local  szyc_720p="2,3,0,0,${fps},2048,${fps},1,0,:2,2,0,0,${fps},1024,${fps},1,0,:"     # 1,0 码率优先
        local szyc_1080p="2,5,0,0,${fps},4096,${fps},1,0,:2,2,0,0,${fps},1024,${fps},1,0,:"
        echo sed -i -e \"s/${chns_720p}/${szyc_720p}/g\"     \
                -e \"s/${chns_1080p}/${szyc_1080p}/g\" ${f_bin_server}
        sed -i -e "s/${chns_720p}/${szyc_720p}/g"     \
                -e "s/${chns_1080p}/${szyc_1080p}/g" ${f_bin_server}*
        xert $? `$PS8` "sed error: ${f_bin_server}" || return $?

        # modify default value on webpage
        
        sed -i -e "/fps_bps_gop__1080P/s/25,8192,25/${fps},4096,${fps}/g"  \
               -e "/fps_bps_gop__720P/s/25,4096,25/${fps},2048,${fps}/g"  \
               -e "/fps_bps_gop__D1/s/25,2048,25/10,1024,10/g" ${js_vavideochn}
        xert $? `$PS8`  || return $?

        sed -i '/tag_cancel_passwd_pattern/s#// ##g' ${p_web_nu}/js/sysusrmange.js
        xert $? `$PS8`  || return $?
        sed -i '/tag_cancel_passwd_pattern/s#，密码必须是字母和数字的组合##g' ${p_web_nu}/language/chinese.js
        xert $? `$PS8`  || return $?
        sed -i '/tag_cancel_passwd_pattern/s#, password should mix character and number##g' ${p_web_nu}/language/english.js
        xert $? `$PS8`  || return $?

        # no auth

        fn_ini_set "$confuser_ini" comm_attr enable 0
        xert $? `$PS8`  || return $?
        fn_sync_ini_files $confuser_ini
        xert $? `$PS8`  || return $?

        # ini
        fn_echo_succ "Customize osd..."
        fn_ini_set "$confvi_ini" osd.time.chn0 top720   0       && \
        fn_ini_set "$confvi_ini" osd.time.chn0 left720  336     && \
        fn_ini_set "$confvi_ini" osd.time.chn0 top1080  0       && \
        fn_ini_set "$confvi_ini" osd.time.chn0 left1080 504     && \
        fn_ini_set "$confvi_ini" osd.bps.chn0  enable   0         && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 left   1919 && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 top720  0   && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 top1080 0   && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 value   "${CUSTOMIZE_NAME}"
        xert $? `$PS8`  || return $?

        fn_sync_ini_files $confserv_ini
        xert $? `$PS8`  || return $?

        # 告警丢失
        fn_ini_set "$confvi_ini" vl_attr.chn0 enable 1
        xert $? `$PS8`  || return $?
        fn_ini_set "$confvi_ini" vl_attr.chn0 timestrategy '0:2164260863,1:2164260863,2:2164260863,3:2164260863,4:2164260863,5:2164260863,6:2164260863,'
        xert $? `$PS8`  || return $?
        fn_sync_ini_files $confvi_ini
        xert $? `$PS8`  || return $?
        ;;

    11|12|13|14)
        let customtype=$1-10
        fn_ini_set "$confserv_ini" product customtype $customtype
        xert $? `$PS8`  || return $?
        fn_sync_ini_files $confserv_ini
        xert $? `$PS8`  || return $?
        ;;
    15)
        sed -i "/tag_lang_russian/s/false/true/" ${jsgeneral}
        xert $? `$PS8`  || return $?
        ;;
    16)
        fn_opt_def_lang_CHN
        xert $? `$PS8`  || return $?
        ;;
    21)
        sed -i "s/force_show_trSerialSet = 0/force_show_trSerialSet = 1/g" ${js_setting}
        xert $? `$PS8`  || return $?
        ;;
    22)
        DEVNAME="S9233-J20BH"
        fn_opt_devname
        xert $? `$PS8`  || return $?
        ;;
    25)
        fn_opt_def_fps 25
        ;;
    30)
        fn_opt_def_fps 30
        ;;
    48)
        use_osdfont_48x48=true;
        ;;
    50)
        classid_old='clsid:2319F6E6-ABD3-4b68-BADF-05D8796FA072'
        classid_new='clsid:4b1f2b74-f741-4659-b516-18fa853cd7ef'
        grep -l -R "${classid_old}" ${p_web_nu}  | xargs sed -i "s/${classid_old}/${classid_new}/g" 
        xert $? `$PS8` "id replace" || return $?
        ;;
    61)
        fn_customize_reso $i_reso_qcif 640 360
        xert $? `$PS8`  || return $?
        sed -i '/tag_for_qcif_2_vga/s/QCIF/VGA/g' ${p_web_nu}/asp/vavideochn.asp
        xert $? `$PS8`  || return $?
        sed -i '/tag_for_qcif_2_vga/s/QCIF/VGA/g' ${p_web_nu}/js/mainview.js
        xert $? `$PS8`  || return $?

        # no auth
        fn_ini_set "$confuser_ini" comm_attr enable 0
        xert $? `$PS8`  || return $?
        fn_sync_ini_files $confuser_ini
        xert $? `$PS8`  || return $?

        # del D1
        # sed -i '/tag_for_del_opt_d1/d' ${p_web_nu}/asp/vavideochn.asp
        # xert $? `$PS8`  || return $?
        # sed -i '/tag_for_del_opt_d1/d' ${p_web_nu}/js/vavideochn.js
        # xert $? `$PS8`  || return $?

        # qcif2vga baudrate
        sed -i -e '/tag_for_qcif_2_vga/s/1024/4096/g' \
                -e '/tag_for_qcif_2_vga/s/IDC_BPS_FAIL_QCIF/IDC_BPS_FAIL_VGA/g' ${p_web_nu}/js/vavideochn.js
        xert $? `$PS8`  || return $?

        # on FACTORY default qcif-2-vga
        local  chns_720p="2,3,0,0,25,4096,25,0,0,:2,1,0,0,15,512,15,0,0,: "
        local chns_1080p="2,5,0,0,25,8192,25,0,0,:2,1,0,0,15,512,15,0,0,: "
      local  steven_720p="2,3,0,0,25,4096,25,0,0,:2,0,0,0,25,2048,25,0,0,:"
      local steven_1080p="2,5,0,0,25,8192,25,0,0,:2,0,0,0,25,2048,25,0,0,:"
        echo sed -i -e \"s/${chns_720p}/${steven_720p}/g\"     \
                -e \"s/${chns_1080p}/${steven_1080p}/g\" ${f_bin_server}
        sed -i -e "s/${chns_720p}/${steven_720p}/g"     \
                -e "s/${chns_1080p}/${steven_1080p}/g" ${f_bin_server}*
        xert $? `$PS8` "sed error: ${f_bin_server}" || return $?

        fn_ini_set "$confvechn_ini" ve_attr.normal chns '2,0,0,0,25,2048,25,0,0,'
        fn_sync_ini_files $confserv_ini

        ;;
    62)
        fn_customize_reso $i_reso_cif 640 360
        xert $? `$PS8`  || return $?
        ;;
    63)
        fn_customize_reso $i_reso_d1 640 360
        xert $? `$PS8`  || return $?
        ;;
    64)
        fn_customize_reso $i_reso_d1 640 480
        xert $? `$PS8`  || return $?
        ;;
    65)
        fn_customize_reso $i_reso_d1 704 576            # d1 -> 4cif
        xert $? `$PS8`  || return $?

        sed -i '/tag_for_d1_2_4cif/s/D1/4CIF/g' ${p_web_nu}/asp/exdcofiguration.asp
        xert $? `$PS8`  || return $?

        sed -i '/tag_for_d1_2_4cif/s/D1/4CIF/g' ${p_web_nu}/asp/vavideochn.asp
        xert $? `$PS8`  || return $?
        sed -i '/tag_for_d1_2_4cif/s/D1/4CIF/g' ${p_web_nu}/js/mainview.js
        xert $? `$PS8`  || return $?
        sed -i '/tag_for_d1_2_4cif/s/D1/4CIF/g' ${p_web_nu}/js/mainchn.js
        xert $? `$PS8`  || return $?
        sed -i '/tag_for_d1_2_4cif/s/D1/4CIF/g' ${p_web_nu}/js/vavideochn.js
        xert $? `$PS8`  || return $?

        sed -i '/IDC_BPS_FAIL_D1/s#\<D1#4CIF#g' ${p_app_vs}/web_nu/language/chinese.js          
        sed -i '/IDC_BPS_FAIL_D1/s#\<D1#4CIF#g' ${p_app_vs}/web_nu/language/english.js          
        xert $? `$PS8`  || return $?
        ;;
    70)
        fn_customize_reso $i_reso_720p 1280 960
        xert $? `$PS8`  || return $?
        ;;
    78)
        fn_customize_reso $i_reso_1080p 1600 1200
        xert $? `$PS8`  || return $?
        ;;
    91)
        fn_opt_web 6
        xert $? `$PS8`  || return $?

        fn_opt_ip 192.168.1.120
        xert $? `$PS8`  || return $?

        fn_opt_user_passwd 888888 888888
        xert $? `$PS8`  || return $?

        # use  the sync fo fn_opt_devname
        sed -i "s/result.dome_modle/''/g" ${p_web_nu}/js/mainview.js 
        xert $? `$PS8` "sed $confserv_ini" || return $?

        # IPC cann't be set for tar package
        # DEVNAME="IPC" fn_opt_devname
        ;;
    92)
        fn_opt_web 7
        xert $? `$PS8`  || return $?

        fn_opt_ip 192.168.1.138
        xert $? `$PS8`  || return $?

        fn_opt_user_passwd admin 123456
        xert $? `$PS8`  || return $?
        ;;
    93)
        local  chns_720p="2,3,0,0,25,4096,25,0,0,:2,1,0,0,15,512,15,0,0,: "
        local chns_1080p="2,5,0,0,25,8192,25,0,0,:2,1,0,0,15,512,15,0,0,: "
        local  aoqm_720p="2,3,0,0,25,4096,25,0,0,:2,1,0,0,25,1024,25,0,0,:"
        local aoqm_1080p="2,5,0,0,25,8192,25,0,0,:2,1,0,0,25,1024,25,0,0,:"
        echo sed -i -e \"s/${chns_720p}/${aoqm_720p}/g\"     \
                -e \"s/${chns_1080p}/${aoqm_1080p}/g\" ${f_bin_server}
        sed -i -e "s/${chns_720p}/${aoqm_720p}/g"     \
                -e "s/${chns_1080p}/${aoqm_1080p}/g" ${f_bin_server}*
        xert $? `$PS8` "sed error: ${f_bin_server}" || return $?
        ;;
    94)
        fn_opt_ip 192.168.1.19
        xert $? `$PS8`  || return $?

        DEVNAME="ADNXP-V01" fn_opt_devname
        xert $? `$PS8`  || return $?
        fn_opt_user_passwd system system
        xert $? `$PS8`  || return $?

        local  chns_720p="2,3,0,0,25,4096,25,0,0,:2,1,0,0,15,512,15,0,0,: "
        local chns_1080p="2,5,0,0,25,8192,25,0,0,:2,1,0,0,15,512,15,0,0,: "
        local   apd_720p="2,3,0,0,25,3072,30,0,1,:2,2,0,0,25,512,30,0,1,: "
        local  apd_1080p="2,5,0,0,25,6144,30,0,1,:2,2,0,0,25,512,30,0,1,: "
        echo sed -i -e \"s/${chns_720p}/${apd_720p}/g\"     \
                -e \"s/${chns_1080p}/${apd_1080p}/g\" ${f_bin_server}
        sed -i -e "s/${chns_720p}/${apd_720p}/g"     \
                -e "s/${chns_1080p}/${apd_1080p}/g" ${f_bin_server}*
        xert $? `$PS8` "sed error: ${f_bin_server}" || return $?

        # osd position of APD
        CUSTOMIZE_NAME="Camera-1"
        fn_echo_succ "Customize osd..."
        fn_ini_set "$confvi_ini" osd.time.chn0 top720   704         && \
        fn_ini_set "$confvi_ini" osd.time.chn0 left720  1176        && \
        fn_ini_set "$confvi_ini" osd.time.chn0 top1080  1042        && \
        fn_ini_set "$confvi_ini" osd.time.chn0 left1080 1647        && \
        fn_ini_set "$confvi_ini" osd.bps.chn0  enable   0           && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 left     20   && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 top720   24    && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 top1080  32    && \
        fn_ini_set "$confvi_ini" osd.channelname.chn0 value   "${CUSTOMIZE_NAME}"
        xert $? `$PS8`  || return $?

        fn_sync_ini_files $confserv_ini
        xert $? `$PS8`  || return $?

        fn_sync_ini_files $confvi_ini
        xert $? `$PS8`  || return $?


        ;;
    *)
        return 1
        ;;
    esac
}

function fn_makerinfo()
{
    local pack_date=`date +'%F.%T'` 
    local pack_ip=`fn_get_if_ip | grep 192.168.2` 

    [ -n "$pack_ip" ]
    xert $? `$PS8` "machine ip is no in net 192.168.2.255" || return $?

    echo "Release $pack_date@$pack_ip" 
    echo "Revirsion $revision"
    echo "Option: $org_opt" 

    if [ -n "$platform_input" ] ; then
        echo "Platforms: $platform_input" 
    fi
}

function fn_opt_issue()
{
    fn_makerinfo >> $p_release/Packages/RELEASE
    xert $? `$PS8` "maker info error" || return $?

    cp $p_release/Packages/RELEASE $p_release/COM/RELEASE && \
    cp $p_release/Packages/RELEASE $p_app_vs/web_nu

    xert $? `$PS8` "cp" || return $?
}

function fn_opt_devname()
{
    fn_echo_succ "\nset default device name ..."

    fn_ini_set "$confserv_ini" devinfo name "$DEVNAME"
    xert $? `$PS8` "sed $confserv_ini" || return $?

    fn_sync_ini_files $confserv_ini
    xert $? `$PS8` || return $?
}


function fn_opt_infinova_ptz()
{
    fn_ini_set "$confptz_ini" chn0 protocol "PELCO_D(INFINOVA)"
    xert $? `$PS8` "sed $confptz_ini" || return $?

    fn_sync_ini_files $confptz_ini
    xert $? `$PS8` || return $?
}


function fn_opt_web() { 
    local web_customize
    case $1 in
        1) web_customize=$p_bin/web_jssj            ;;
        2) web_customize=$p_bin/web_szlx            ;;
        3) web_customize=$p_bin/web_cnb             ;;
        4) web_customize=$p_bin/web_AvTrace         ;;
        5) web_customize=$p_bin/web_WISION          ;;
        6) web_customize=$p_bin/web_tsinghuaTongfang;;
        7) web_customize=$p_bin/web_videoTerc       ;;
        *) echo "unknow web INDEX" && return 1  ;;
    esac

    [ -d "$web_customize" ]
    xert $? `$PS8` "$web_customize not exist" || return $?

    fn_echo_warn "Customize on ${web_customize}..."

    cp -a $web_customize/* ${p_app_vs}/web_nu
    xert $? `$PS8` cp || return $?
}

function fn_opt_blackmargin() 
{
    fn_echo_succ "\nblackmargin ..."

    local -a arr_black=(${2//,/ })
    local x=${arr_black[0]}
    local y=${arr_black[1]}
    local reso=$1

    reso=`echo $reso | tr [a-z] [A-Z]`

    [ "${#arr_black[@]}" -eq 2 ]
    xert $? `$PS8` "black margin[${#arr_black[@]}]: $1" || return $?

    [ "$reso" == "720P" ] || [ "$reso" == "1080P" ]
    xert $? `$PS8` "invalid reso: $reso" || return $?

    [ "$x" -le 1920 ] && [ "$x" -ge -1920 ]
    xert $? `$PS8` "invalid x: $x" || return $?

    [ "$y" -le 1080 ] && [ "$y" -ge -1080 ]
    xert $? `$PS8` "invalid y: $y" || return $?

    let modx=x%4
    let mody=y%4
    [ $modx -eq 0 ] && [ $mody -eq 0 ]
    xert $? `$PS8` "invalid x[$x] y[$y]" || return $?

    # echo $reso $x $y
    fn_ini_set "$confvi_ini" blackmargin.${reso} posx ${x}
    xert $? `$PS8`  || return $?
    fn_ini_set "$confvi_ini" blackmargin.${reso} posy ${y}
    xert $? `$PS8`  || return $?

    fn_sync_ini_files $confvi_ini
    xert $? `$PS8`  || return $?
}

function fn_opt_newweb() 
{
    fn_echo_succ "\nweb2.0..." 
    test ! -f $local_release/js/general.js
    xert $? `$PS8` "release dir [$local_release] is invalid" || return $?

    # 使用开拓者上的插件
    (rm -rf ${p_app_vs}/web_nu/* ) # && rm -rf `ls | grep -v IPCameraOCXSetup.exe`
    xert $? `$PS8` "cd rm" || return $?

    cp -a $local_release/* ${p_app_vs}/web_nu/
    xert $? `$PS8` "cp" || return $?

    ( cd ${p_app_vs}/web_nu/ && chmod -R 644 * )
    xert $? `$PS8` "${FUNCNAME}" || return $?
}
#
#  be called before `tar full.tgz` and `$tool_mkyaffs2image365`
#
function fn_customize()
{
    if [ "$dbgpack" == true ]; then
        fn_opt_dbgpack
        xert $? `$PS8`  || return $?
    fi

    if [ -n "$VIP" ]; then
        fn_opt_ip
        xert $? `$PS8`  || return $?
    fi

    if [ "$verify" == true ] ; then
        fn_opt_verify_version
        xert $? `$PS8`  || return $?
    fi

    if [ -n "$DEVNAME" ] ; then
        fn_opt_devname
        xert $? `$PS8`  || return $?
    fi

    if [ -n "$INFINOVA_PTZ" ] ; then
        fn_opt_infinova_ptz
        xert $? `$PS8`  || return $?
    fi

    if [ -n "$web_index" ] ; then
        fn_opt_web $web_index
        xert $? `$PS8`  || return $?
    fi

    if [ "$newweb" == true ] ; then
        fn_opt_newweb
        xert $? `$PS8`  || return $?
    fi

    if [ -n "$MARGIN720P" ] ; then
        fn_opt_blackmargin 720P $MARGIN720P
        xert $? `$PS8`  || return $?
    fi

    if [ -n "$MARGIN1080P" ] ; then
        fn_opt_blackmargin 1080P $MARGIN1080P
        xert $? `$PS8`  || return $?
    fi

    fn_opt_issue
    xert $? `$PS8`  || return $?

    fn_opt_common_osdfonts
    xert $? `$PS8`  || return $?

    fn_opt_platform
    xert $? `$PS8`  || return $?

    fn_opt_xld_platform
    xert $? `$PS8`  || return $?

    # put option at the end
    if [ -n "$opt_input" ] ; then
        local opt0=
        for opt0 in ${opt_input//:/ }; do
            echo "process option ${opt0}"
            fn_opt_input $opt0
            xert $? `$PS8`  || return $?
        done
    fi
    return 0
}

function fn_asm_nfs()
{
    [ "$asmnfs" != "true" ] && return 1

    fn_echo_succ "\n    Asm nfs filesys succ!"
    fn_echo_succ "\n    Enjoy it!"

    return 0
}
#
# $1 the platforms from
#
function fn_make_release()
{
    local idx=$1

    [ "$idx" -lt $PLATFORM_END ] 
    xert $? `$PS8` "invalid idx $idx" || return $?

    fn_echo_succ "packing `fn_get_platform_info $idx $i_platform_note`\n"


    # tag all app a tagTRUE, and tagFALSE apps will be remove
    fn_set_app_true
    xert $? `$PS8` || return $?

    # fn_customize must be here, before fn_make_tar
    fn_customize
    xert $? `$PS8` || return $?

    fn_clean_redundant_app
    xert $? `$PS8` || return $?

    fn_asm_nfs && return 0

    fn_make_tar
    xert $? `$PS8` || return $?

    fn_make_filesys    
    xert $? `$PS8` || return $?

}


function fn_make_changelog()
{
    echo
    # fn_echo_succ $FUNCNAME starting ...
}

function fn_usage()
{
    echo "
Usage: ENVIRONMENT=val ./$SRC_NAME [OPTION]

OPTION
    --crypt
        加密升级包。现场是2014-03-18后的版本时使用此选项
    -d, --dbgpack
        debug package and check whether a debug_pack.tgz need to be released

    -h, --help
        display help messages and exit

    -i, --install
        install

    -r, --revision REVISION
        pack history revision REVISION
        and get package in rev_REVISION/20181010_GEN/Packages

    -y, --yft_ptz
        enable YFT PELCO_D,
        when guobiao, set config_ptz.ini chn0:protocol PELCO_D(INFINOVA)

    -k, --skip_chk_upgrade
        
        换了平台不能使用 -k

        both the below VAR will be set:
        SKIP_SVN=1          
                is for files in filesys/app/vs,            
                not overwrite by svn checkout

        skip_chk_upgrade=1  
                when customize upgrade .tgz packet, it's convenient.

                files in p_upgrade such as updateStep0/{rcS, inittab} has 
                a copy from p_filesys, if not set, the files will             
                be compared with same-name file in p_filesys and synced             
                if changed.
                                                                                       
        /* when md5sum compare, 
         * arm_v5t_le-strip jco_xxx first.
         */
        when skip jco_xxx, replace file p_filesys/app/vs            
        when skip uImage, replace file uImage

    -l, --list
        list the platform id and corresponding platform names

    --margin720p
    --margin1080p

        x,y 2元组以','分隔，如：
        --margin720p x,y
        --margin1080p x,y

    -n, --name DEVNAME
        append DEVNAME was set to config_server.ini|devinfo:name|

    --newweb
        web2.0, and provide a dirctory variables local_release in file rules
        
    -N|--No_mkyaffs2)
        for same time and space, only .tgz pack was made, no .yaffs2

    -v, --verify
        release version, test version is default

    -o, --opt opt_input
        
        -- 使用:分隔，同时使能多个opt。如：-o 1:2:3
        
        1   1080p_f30_6k_g25, disable osd.bps

        2   喜恩碧  默认IP地址：192.168.123.100
                    默认帐号:root
                    默认密码：admin

        3   AvTrace 720P ANC-320/I14FBS
                    图片LOGO
                    包含--web 4
                    DEVNAME         
                    DNS
                    IP
                    OSD time name

        4   AvTrace 1080P ANC-320/I24FBS
                    其它同3

        5   WISION  登陆页面背景图片由WISON提供
                    设备默认IP:  192.168.1.253
                    设备默认的用户名为admin密码为9999

        6   汉邦定制

            默认编码通道设置
            1080P设备：1080P（25帧，6144，i帧间隔：25）+ D1(25帧，512， i帧间隔：25)
            720P设备： 720P （25帧，3072，i帧间隔：25）+ D1(25帧，512， i帧间隔：25)

            默认IP： 192.168.0.100， 网关： 192.168.0.1
            用户名admin，密码888888

        7   zxlw定制

            默认用户密码： amdin:12345
            默认IP: 192.168.1.2   子网掩码：255.255.255.0， 网关 192.168.1.1
            
            GUOBIAO manufacturer--> ZNV

        8   中维世纪

            默认用户密码： abc:123 （保持原有admin:admin）

        9   网页提示及限制：帧率 replace 30 to 25

        10  苏州易程定制

            1.网络出厂默认设置
                ip 192.168.1.71; mask 255.255.0.0; gw 192.168.1.1;
            2.视频参数
                a.主流 1080p; 码流4M; 帧率10; i帧间隔 10;
                b.辅流 D1;    码流1M; 帧率10; i帧间隔 10
            3. 易程对接设置页面：
                a.增加版本号:  第一版出厂版本默认是v1.0.0  ***需要提供网页或界面配置
                b.公司名:EASYWAY
                c.车厢号:出厂默认 1
                d.设备位置号:出厂默认 1 

            4. 开启告警丢失

            5. 用户名：admin  密码：123456

        11  [product:customtype 1] Argers机芯定制，枪机当球机用 
        12  [product:customtype 2] NVS gps
        13  [product:customtype 3] 雨刮小角度定制
        14  [product:customtype 4] IGMP

        15  定制俄语版
        16  默认中文

        21  force_show_trSerialSet 强制显示串口定制页面
        22  foxcom定制             设备名称: S9233-J20BH


        25  fps25（分辨率切换、恢复出厂时默认值）

            默认编码参数： 
            1080P设备：1080P（25帧，6M， i帧间隔：25） + D1(20帧，512K， i帧间隔：20)
            720P设备： 720P （25帧，3M，i帧间隔：25） + D1 （20帧， 512K， i帧间隔：20）

        30  fps30（分辨率切换、恢复出厂时默认值）

            默认编码参数： 
            1080P设备：1080P（30帧，6M， i帧间隔：30） + D1(20帧，512K， i帧间隔：20)
            720P设备： 720P （30帧，3M，i帧间隔：30） + D1 （20帧， 512K， i帧间隔：20）

        48  osd字体48x48定制

        50  clsid 替换
            clsid:2319F6E6-ABD3-4b68-BADF-05D8796FA072 -->
            clsid:4b1f2b74-f741-4659-b516-18fa853cd7ef

        61   qcif定制：            640*360
        62    CIF定制：352x288 --> 640x360
        63     D1定制：720x576 --> 640x360
        64     D1定制：720x576 --> 640x480
        65     D1定制：720x576 --> 704x576
        70   720p定制：            1280*960
        78  1080p定制：            1600*1200

        91 清华同方定制
            user: 888888 passwd: 888888
            IP: 192.168.1.120

        92 动力盈科定制
            only LOGO IP passwd

        93 奥奇曼定制

        94 定制安普达

            1. 设备的默认IP地址修改为192.168.1.19. 
            2. 默认主管理员的账号为system，system。
            3. 标题OSD默认在左上角， 时间OSD默认在右下角。
            4. 1080P：25帧 + 5M + 30I帧间隔+定码流 ； CIF 25帧 + 500K + 30I帧间隔+定码流
                720P：25帧 + 3M + 30I帧间隔+定码流 ； CIF 25帧 + 500K + 30I帧间隔+定码流


    -p, --platform PLATFORM_ID
        append PLATFORM_ID as platform id, skip the interaction of select platform

    --web web_index
        The argument following the --web is used to indicate the customizing info.
        The web_index which are currently  supported include:
        1   金山松佳
        2   深圳联信
        3   喜恩碧
        4   AvTrace

    -q, --quite
        equal to --platform=PLATFORM_NORMAL
        
ENVIRONMENT
    SKIP_SVN
        if \$SKIP_SVN is set, no matter what it is, skip svn chechout. U can
        customize package not in svn. But files in _array_ pubs just like 
        jco_server will not be customized. If you like, U can modify pubs
        
    VIP
        if \$VIP is set and a valid IP, its value is used as IP in config_server.ini
    INSTALL_PATH
        if with -i OPTION, 20181010_GEN will be install in to \$INSTALL_PATH

EXAMPLES    
    SKIP_SVN=1 ./$SRC_NAME
    VIP=192.168.5.80 ./$SRC_NAME
    ./$SRC_NAME -i
    "
}


function fn_install_pkg()
{
    local cwd=${PWD}

    [ -z "$INSTALL_PATH" ] && INSTALL_PATH=/winc/
    [ -z "$TFTP_PATH" ] && TFTP_PATH=/tftpboot/

    mkdir -p $INSTALL_PATH/$PK_GENERATE
    (cd $INSTALL_PATH/$PK_GENERATE && rm -rf COM  Packages  release) 

    test ! -f $PK_GENERATE/COM/filesys.yaffs2 && \
    mv $PK_GENERATE/COM/filesys*.yaffs2  $PK_GENERATE/COM/filesys.yaffs2 
    # xert $? `$PS8` "src: $PK_GENERATE/COM/filesys*.yaffs2" || return $?

    # tftp
    local filelist="filesys.yaffs2 UBL_DM36x_NAND.bin u-boot-1.3.4-dm365_evm.bin uImage"
    cd $PK_GENERATE/COM/ >& /dev/null

    rm -f $TFTP_PATH/*.tgz
    cp -a ../Packages/*.tgz $TFTP_PATH/
    xert $? `$PS8`  || return $?

    cp -a $filelist $TFTP_PATH
    xert $? `$PS8` "" || return $?

    chmod 777 $TFTP_PATH/*
    cd ${cwd} >& /dev/null

    cd $PK_GENERATE/Packages/ >& /dev/null
    for tgz_file in *.tgz; do
        $MD5SUM $tgz_file >> ${tgz_file/tgz/md5}
    done

    # 20181010_GEN
    cd ${cwd} >& /dev/null
    cp -a $PK_GENERATE $INSTALL_PATH/ 
    xert $? `$PS8` "install" || return $?

    fn_echo_succ "install success"
}

function fn_getopt()
{
    # : after opt indicate value must be give, e.g. -t is a test, 
    # login_shell is seperated by ','
    # revision is for 1466 of 20121213

    shortopts="bcdhiykln:No:p:qr:t:v"
    longopts1="chinese,crypt,dbgpack,newweb,help,install,yft_ptz,skip_chk_upgrade"
    longopts2="list,name:,nfs,No_mkyaffs2,platform:"
    longopts3="opt:,quiet,revision:,test:,verify,web:,margin720p:,margin1080p:"
    longopts="$longopts1,$longopts2,$longopts3"

    # after below statement, $@ was set end with '--'
    eval set -- "$(getopt -n $0 -o "$shortopts" -l "$longopts" 2> $PSHM/set "--" "$@")" 

    # echo $PSHM/set
    if [ -s "$PSHM/set" ] ; then
        fn_echo_fail `cat $PSHM/set`
        fn_echo_warn "Type './$SRC_NAME -h' for usage. "
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
        -b)
            readonly booter_kernel_only=true    ;;
        --crypt)
            readonly crypt=true    ;;
        -d|--dbgpack)
            readonly tag_sign='.d'
            readonly dbgpack=true        ;;
        --newweb)
            readonly newweb=true         ;;
        -i|--install)
            fn_install_pkg       
            exit $?
            ;;
        -y|--yft_ptz)
            # when $PLATFORM_GBYFT, it's true
            INFINOVA_PTZ=true
            ;;
        -k|--skip_chk_upgrade)
            readonly SKIP_SVN=1
            readonly skip_chk_upgrade=true
            ;;
        -l|--list)
            fn_list_plt4m
            exit $?
            ;;
        --nfs)
            readonly asmnfs=true
            ;;
        --margin720p)
            shift
            readonly MARGIN720P="$1"
            ;;
        --margin1080p)
            shift
            readonly MARGIN1080P="$1"
            ;;
        -n|--name)
            shift
            readonly DEVNAME="$1"
            ;;
        -N|--No_mkyaffs2)
            readonly no_mkyaffs2=true
            ;;
        -o|--opt)
            shift
            readonly opt_input=$1
            ;;
        -p|--platform)
            shift
            readonly platform_input=$1
            ;;
        -q|--quite)
            readonly platform_input=0
            ;;
        -r|--revision)
            shift
            readonly revision="$1"
            readonly at_revision="@$1"
            ;;
        -t|--test) 
            shift
            echo "Testing $1" $LINENO
            return 1
            ;;
        -v|--verify)
            readonly tag_sign='.v'
            readonly verify=true
            ;;
        --web)
            shift
            readonly web_index="$1"
            ;;
        --)
            break ;;
        --help|-h|*)
            fn_usage
            return 1
            ;;
        esac
        shift
    done
}

function fn_main()
{
    org_opt=$@
    export LANGUAGE="en_US.UTF-8"

    # variables

    readonly     svn_package=$svn_origin/package

    readonly     p_bin=$SRC_PATH/bin
    readonly     p_bin_apps=$p_bin/apps
    readonly     p_bin_drivers=$p_bin/drivers
    readonly     p_bin_images=$p_bin/image

    readonly     p_filesys=$SRC_PATH/filesys
    readonly     p_package=$SRC_PATH/package
    readonly     p_release=$SRC_PATH/20181010_GEN
    readonly     p_upgrade=$p_package/upgrade

    readonly     tool_mkyaffs2image365=$p_package/tools/mkyaffs2image365
    readonly     tool_imgtool=$p_package/tools/imgtool

    readonly      p_app_vs=${p_filesys}/app/vs
    readonly      p_web_nu=${p_filesys}/app/vs/web_nu
    readonly      p_extdrv=${p_filesys}/app/extdrv
    readonly     jsgeneral=${p_app_vs}/web_nu/js/general.js
                    js_sys=${p_app_vs}/web_nu/js/sys.js
    readonly      js_login=${p_app_vs}/web_nu/js/login.js
    readonly    js_setting=${p_app_vs}/web_nu/js/setting.js
               jsnetethnet=${p_app_vs}/web_nu/js/netethnet.js
    readonly js_vavideochn=${p_app_vs}/web_nu/js/vavideochn.js
    readonly  f_bin_server=${p_app_vs}/jco_server
    readonly    confvi_ini=${p_app_vs}/conf/config_vi.ini
    readonly   confptz_ini=${p_app_vs}/conf/config_ptz.ini
    readonly  confserv_ini=${p_app_vs}/conf/config_server.ini
    readonly  confport_ini=${p_app_vs}/conf/config_port.ini
    readonly  confuser_ini=${p_app_vs}/conf/config_user.ini
    readonly confveopt_ini=${p_app_vs}/conf/config_veopt.ini
    readonly confvechn_ini=${p_app_vs}/conf/config_vechn.ini
    readonly md5check_file=$p_upgrade/md5.checks

    fn_getopt "$@"
    if [ "$?" -ne 0 ] ; then
        return 0
    fi

    # fn_echo_succ $FUNCNAME starting ...
    echo
    fn_echo_succ "$PWD is working dir\n"

    fn_startup_check $@
    xert $? `$PS8` || return $?

    rm -f $md5check_file

    local app_mng_tmp=("${app_mng[@]}")
    local platform_id                      # set in fn_select_platform
    local platform_name                     # set in fn_make_platform

    fn_select_platform
    xert $? `$PS8` || return $?

    if [ -n "$branch" ] ; then
        if [ "$branch" != "t" ] || [ "$platform_id" != "0" ]; then
            TERM=linux dialog --yesno \
                "Are you sure pack on branch <$branch>?" 12 40
            [ "$?" -ne 0 ] && exit 1
        fi
    fi

    fn_svn_checkout
    xert $? `$PS8` || return $?

    fn_sync_svn_n_upgrade
    xert $? `$PS8` || return $?

    fn_pack_booter_ker_only                 # exit when pack succ
    xert $? `$PS8` || return $?

    fn_make_platform $platform_id
    xert $? `$PS8` || return $?

    readonly p_bin_ref_plt4m=$p_bin/ref_${platform_name}

    fn_make_release $platform_id
    xert $? `$PS8` || return $?

    #fn_make_changelog  
    #xert $? `$PS8` || return $?

    echo
    fn_echo_succ "pack all platform success, enjoy it!\n"
}

fn_main $@

if [ "$?" -ne 0 ] ; then
    fn_echo_fail "pack failed, please check according to the prompt above!\n"
    exit 1
fi

# vi -d qpack.sh /1/svn/package.t/script/qpack.sh
# from 2013-10-23 用各分支下的打包脚本打包

