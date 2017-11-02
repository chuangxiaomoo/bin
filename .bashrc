# . ~/bin/.bashrc

# make sure no space b4 the 2nd '

alias       ASC=''
alias       BLK=''  # B被BLK独占for其超高频率使用
alias      COND=''
alias      iASC=''
alias     iCOND=''
alias     kCOND=''
alias      CHAO=''
alias     CAUSE=''
alias     CIXIN=''
alias      DOOR=''
alias     iDOOR=''
alias     kDOOR=''
alias     rDOOR=''
alias     vDOOR=''
alias     DEBUG=''
alias       END=''
alias     FIELD=''
alias       HMS=''
alias      iHMS=''
alias       NUM=''
alias       TBL=''
alias       TEN=''
alias    HAVING=''
#lias      FINA=''      # S_I_N_A conflict with Svn
alias      PREV=''
alias      YIST=''
alias     YRISE=''
#lias      STEP=''
#lias     SCALE=''      # 通放大倍数 
alias       WIT=''      # 大智慧
alias     LIMIT=''
alias      iDDE=''
alias      iEND=''
alias     iPASS=''
alias    iLIMIT=''
alias     nmemb=''
alias       OPT=''
alias     PPLUS=''
alias     PARTS=''
alias NMC_RATIO=''
alias       wup='.s; FINA=0 up 4; TBL=wind SCREENER 0 || up wind'
alias       fup='.s; FINA=1 up 4'
#lias     .b='cd ~/bin'
alias .bell.xrd="timeout 3 nc 127.0.0.1 2911 <<< '_xRD_done_'"
alias .bell.win="timeout 3 nc  10.0.2.2 1234 <<< 'duang.wav msg.wav'"
alias   .lschao='xargs -n8</tmp/kts/chao'
alias      .NTP="ntpdate cn.pool.ntp.org"


alias     ..='cd ..'
alias    ...='cd ../..'
alias     .c="let 'CHAO=!CHAO'; echo \$CHAO; export CHAO"
alias     .w="let 'WIT=!WIT'; echo \$WIT; export WIT"
alias     .5="let 'TOV5=++TOV5%3'; echo \$TOV5; export TOV5"
alias  .SINA="let 'SINA=!SINA'; echo \$SINA; export SINA"
alias .DEBUG="let 'DEBUG=!DEBUG'; echo \$DEBUG; export DEBUG"
#lias    .n='. /opt/nxpbash'
alias    .s='cd ~/bin'
alias    .k='cd ~/bin/stk'
alias   .rc='.  ~/.bashrc'
alias  .irc='vi ~/.bashrc +; . ~/.bashrc'
alias  .mor='~/bin/stk/up morningcall'
alias    .u='vi /tmp/kts/chao.u'
alias   .ps='PS1="[\w]\n\u-> \[\033[0m\]"'

alias .de_beep="echo 0 >/tmp/kts/chao.beep"
alias .en_beep="echo 1 >/tmp/kts/chao.beep"

# nc
alias  iinc='vim ~/.inc'
alias  .inc='cat ~/.inc'

alias     f='find . -name'
alias     l='ls -CF'
alias    ls='ls --color=auto'
alias    ll='ls -AlF'
alias    la='ls -A'
alias   lsf='find `ls -A` -maxdepth 0 -type f | xargs'
alias   lsd='find `ls -A` -maxdepth 0 -type d | xargs'
#lias   lsf='find . -maxdepth 1 -type f | sed 's#\./##g' | xargs'
#lias   lsd='find . -maxdepth 1 -name '\''[a-zA-Z]*'\'' -type d | xargs | sed '\''s#\./##g'\'''

alias  kpts="ps -ef | grep '[p]ts/[0-9]' | awk '{print \$2}' | xargs kill -9"
alias  Kpts="ps -ef | grep '[p]ts/[0-9]' | awk '{print \$2}' | xargs kill -9"
alias    rr='rm -rf'
alias    rm='rm -i'
alias     i='vi'
alias     m='make'
alias    mc='make clean'
alias    mh='make http1'
alias    md='Markdown.pl --html4tags'
alias  mweb='mount --bind /home/s/trunk/web2.0/release /home/s/fs/opt/web'
alias umweb='umount /home/s/fs/opt/web'
alias   slc='sloccount'
alias  slcd='sloccount --cached --details'          # slcd | grep "sysctrl" | print_sum
alias     x='chmod 777 '
alias    xt='chmod 777 /tftpboot/*'
alias    xx='tar -zxvf'
alias    ct='cd ~/sh/t'

alias    cs='cscope -Rbq *'
alias vboxr='/etc/init.d/vboxadd-service restart'   # ;umount -a 2>/dev/null; mount -a
alias  8cat='iconv -f cp936 -t utf8'

alias    v1='vi -R ~/bin/m1'
alias    v2='vi -R ~/bin/m2'
alias    v3='vi -R ~/bin/m3'
alias    v7='vi    ~/bin/7Lite'
alias    vj='vi    ~/bin/j2box'
alias    vn='vi --noplugin'
alias    vr='vi -R'
alias    vR='vi -R README*'
alias    vt='vi ~/bin/.m2doc/tick.md'
alias    vz='vi -R ~/bin/stk/.account.md'
alias  v.fc='vi -R ~/.flowchar/main.i'

alias vimdiff='vimdiff "+call Diff_enter()"'

alias w3mdump='/usr/bin/w3m -dump -cols 10000'      # 82时的实际宽度是80

alias   ltmux='TERM=xterm /usr/local/bin/tmux'
alias    tmux='TERM=xterm /usr/bin/tmux'
alias  dialog='TERM=linux dialog'
alias psmysql='ps -ef | grep [m]ysql'
alias   psw3m='ps -ef | grep [w]3m'
alias  kmysql='mysql kts'
alias   igrep="cd ~/bin; find .m* stk/ -name '*' -type f | xargs grep --color"
alias   xgrep="find . -name '*' -type f |grep -v '\.git' | xargs grep --color"
alias  upconf="rm -f /home/s/fs/opt/conf/config.*; svn up /home/s/fs/opt/conf/config.org;" 
alias  clrnfs="Svn | grep nfs | awk '{print $2}' | xargs rm -f"
alias fbcache="sync; echo 3 > /proc/sys/vm/drop_caches"
alias    Calc='set -f; fn_calc'

fn_calc()       { expr0="scale=${SCALE:-3};$@"; bc -l <<< "${expr0}"; set +f; }
function M()    { m1 $@ | tail -18; } # M() { m1 $@ | nl -w 3 -s' ' | less -i ;}

alias   cwd='pwd >>  ~/.env;vi ~/.env; .rc'         # curr-pwd
alias   swd='pwd >   ~/.swd'                        # save pwd, [pushd .]
alias   gwd='cd `cat ~/.swd`'                       # save pwd  [popd]

alias  | grep -w -q awd && unalias awd
alias  | grep -w -q iwd && unalias iwd

awd() { pwd >>  ~/.awd${1}; }
iwd() { vi      ~/.awd${1}; }
lwd() { wd_file=~/.awd${1}
    [ "${1}" = 'l' ] && (cd ~; ls .awd* | grep --color awd) && return
    cat -n $wd_file 2>/dev/null | grep -E "([0-9]|Export)" || {
        echo "Usage: lwd ${1}" &&
        echo "  run awd${1} first" && return
    }

    local path_index
    while read -p "        Select a path you wanna goto [1]: " path_index; do
        local path_goto=`sed -n ${path_index:-1}p ${wd_file} 2>/dev/null | awk '{print $1}'`
        
        if [ -d "$path_goto" ] ; then
            cd $path_goto
            break
        else
            echo  "        invalid path[$path_index]: ${path_goto}"
        fi
    done
}

.Clang_x86() 
{
    # when $1 f, force create
    [ "$1" == 'f' ] && rm -f .clang_complete 
    
    if [ -f .cscope.files ] && [ -f .clang_complete ]; then
        if [ .clang_complete -nt .cscope.files ] ; then
            echo latest! 
            return 0
        fi
    fi 

    cat <<-"HERE" > .clang_complete
	-Dmoo7Lite_clang_x86
	-I/usr/local/include
	-I/usr/lib/i386-linux-gnu/gcc/i686-linux-gnu/4.5.2/include
	-I/usr/lib/i386-linux-gnu/gcc/i686-linux-gnu/4.5.2/include-fixed
	-I/usr/include/i386-linux-gnu
	-I/usr/include
	HERE

    [ -f .cscope.files ] && {
        grep '\.h+$' .cscope.files | xargs -I{} dirname {} | \
            sort -u | sed 's/^/-I/g' >> .clang_complete
    }
}

.Cxxlang_x86() 
{
    # when $1 f, force create
    [ "$1" == 'f' ] && rm -f .clang_complete 
    
    if [ -f .cscope.files ] && [ -f .clang_complete ]; then
        if [ .clang_complete -nt .cscope.files ] ; then
            echo latest! 
            return 0
        fi
    fi 

    echo "" | `gcc -print-prog-name=cc1plus` -v 2>&1 | grep ' /usr/' | \
        sed 's/^ /-I/g' > .clang_complete

    [ -f .cscope.files ] && {
        grep '\.h+$' .cscope.files | xargs -I{} dirname {} | \
            sort -u | sed 's/^/-I/g' >> .clang_complete
    }
}

activate_eth5() 
{
    local ethip="192.168.2.45"
    ifconfig | grep -q -w "$ethip" || ifconfig eth6 $ethip 
    return

    local ip=`ifconfig eth5 | grep "inet addr" | 
                cut -d : -f 2 | cut -d ' ' -f 1`
    local eth5ip="192.168.2.45"
    if [ "$ip" != "$eth5ip" ] ; then
        echo "$ip is different with $eth5ip"
        /etc/init.d/networking restart
    fi
}

psgrep()
{
    test -z "$1" && { echo "Usage: pskill name" && return 1 ;}
    head=${1:0:1}
    body=${1:1}

    # psgrep='ps -ef | grep'
    echo "ps -ef | /bin/grep -E --color [${head}]${body}"
    ps -ef | /bin/grep -E --color "[${head}]${body}"
}

pskill()
{
    test -n "$1" || { echo "Usage: pskill name" && return 1 ;}
    head=${1:0:1}
    body=${1:1}

    # echo $head ${tail}
    ps -ef | grep -E "[${head}]${body}\>" | awk '{print $2}' | xargs kill -9
}

lsgcc()
{
    echo "
    hisi    arm-hisiv100nptl-linux-
    nxp     arm-linux-
    ti      arm_v5t_le-
    grain   arm-unknown-linux-uclibcgnueabi-
    anyka   arm-anykav200-linux-uclibcgnueabi-
    jzzz    mips-linux-uclibc-gnu-

    arm-linux-gcc
    arm-buildroot-linux-uclibcgnueabi-gcc
    aarch64-none-elf-gcc
    arm-none-eabi-gcc
    arm-none-linux-gnueabi-gcc

    /home/n/rc.d/mksquashfs
    "
}

function git_diff() {
    git diff --no-ext-diff -w "$@" | vim -R –
}

#orgpath() { export PATH=$ORGPATH; }
#monpath() { export PATH=$MONPATH; }

.tar() 
{
    [ "$#" -ne 2 ] && echo "Usage: .tar -zxvf file.tgz" && return
    mkdir -p ${2%.*} && tar $@ -C ${2%.*}
}

.nb.mavol()
{
    # mavol20/mavol5的门限
    if [ -z "${1}" ]; then
        echo "nb.mavol: `cat /tmp/kts/mavol`"
    else
        echo "${1:-100} -> /tmp/kts/mavol"
        echo "${1:-100}" > /tmp/kts/mavol
    fi
}

.nb.2015()
{
    # alias  .ma60="let 'WMA=!WMA'; echo \$WMA; export WMA"
    nb_2015=`cat /tmp/kts/2015 2>/dev/null`
    let 'nb_2015=!nb_2015'
    echo "${nb_2015} -> /tmp/kts/2015"
    echo "${nb_2015}" > /tmp/kts/2015
}

cpcom() { mkdir -p /winc/Export/com/; rm -rf /winc/Export/com/*;     cp -a release/com/* /winc/Export/com/ ;}
cptar() { file=`ls release/tar/*.tgz`; 
          mkdir -p /winc/Export/com/; rm -rf /winc/Export/com/*.tgz; cp -a $file         /winc/Export/com/ ;}
cpffw() { file=`ls release/tar/*.ffw`; 
          mkdir -p /winc/Export/com/; rm -rf /winc/Export/com/*.ffw; cp -a $file         /winc/Export/com/ 
          echo ${file##*/} > /winc/Export/com/ffw.txt                                                      ;}
nctar() { file=`ls release/tar/*.tgz`;  nc $1 8006 < $file ;}
nc1234(){ make i;  nc $1 1234 < main/jco_server ;}

# manpage color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# kts variable
export TOV5=0

# 
export PATH=~/bin:$PATH
export CDPATH=.:~:/home
export SVN_EDITOR=vim
