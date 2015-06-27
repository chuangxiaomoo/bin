# . ~/bin/.bashrc

# make sure no space b4 the 2nd '

alias        FM=''
alias       ASC=''
alias       END=''
alias       NUM=''
alias       TBL=''
alias      COND=''
#lias      FINA=''      # S_I_N_A conflict with Svn
alias      PREV=''
alias      YIST=''
alias      ZIZE=''
alias     LIMIT=''
alias     nmemb=''
alias       mip='PREV=10 mi5 '
alias     PPLUS=''
alias     PARTS=''
alias    ORACLE=''
alias NMC_RATIO=''
alias       wup='.s; FINA=0 up 4; TBL=wind SCREENER 0 || up wind'
alias       fup='.s; FINA=0 up 4'
alias     field=''

alias    ..='cd ..'
alias   ...='cd ../..'
alias    .b='cd ~/bin'
alias    .c="let 'CHAO=!CHAO'; echo \$CHAO; export CHAO"
alias    .5="let 'TOV5=++TOV5%3'; echo \$TOV5; export TOV5"
alias  .dbg="let 'DEBUG=!DEBUG'; echo \$DEBUG; export DEBUG"
alias .sina="let 'SINA=!SINA'; echo \$SINA; export SINA"
#lias    .n='. /opt/nxpbash'
alias    .s='cd ~/bin/stk'
alias   .nb="nc 192.168.100.100 1234 <<< 'ooh my god'"
alias   .ss='cd ~/bin/stk/sql'
alias   .rc='. /root/.bashrc'
alias   .ps='PS1="[\w]\n\u-> \[\033[0m\]"'

alias     f='find'
alias     l='ls -CF'
alias    ls='ls --color=auto'
alias    ll='ls -AlF'
alias    la='ls -A'
alias   lsf='find `ls -A` -maxdepth 0 -type f | xargs'
alias   lsd='find `ls -A` -maxdepth 0 -type d | xargs'
#lias   lsf='find . -maxdepth 1 -type f | sed 's#\./##g' | xargs'
#lias   lsd='find . -maxdepth 1 -name '\''[a-zA-Z]*'\'' -type d | xargs | sed '\''s#\./##g'\'''

alias  ktel="ps -ef | grep [t]elnet | awk '{print \$2}' | xargs kill -9"
alias  ktel="ps -ef | grep [t]elnet | awk '{print \$2}' | xargs kill -9"
alias  kpts="ps -ef | grep '[p]ts/[0-9]' | awk '{print \$2}' | xargs kill -9"
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
alias   irc='vi /root/.bashrc; . /root/.bashrc'
alias    ct='cd ~/sh/t'
alias   cwd='pwd >> ~/.env;vi ~/.env; .rc'
alias   swd='pwd > ~/.swd'                          # save pwd, [pushd .]
alias   awd='cp ~/.awd /dev/shm/.awd && pwd > ~/.awd && cat /dev/shm/.awd >> ~/.awd'   
alias   iwd='vi /root/.awd'   
alias   gwd='cd `cat ~/.swd`'                       # save pwd  [popd]
alias    cs='cscope -Rbq *'
alias vboxr='/etc/init.d/vboxadd-service restart'   # ;umount -a 2>/dev/null; mount -a

alias    v1='vi /root/bin/m1'
alias    v2='vi /root/bin/m2'
alias    v7='vi /root/bin/7Lite'
alias    vj='vi /root/bin/j2box'
alias    vn='vi --noplugin'
alias    vr='vi -R'
alias    vR='vi README*'
alias    vt='vi /root/bin/.m2doc/tick.md'

alias sdiff='svn diff -r PREV'

alias   w3m='w3m -cols 78'

alias   ltmux='TERM=xterm /usr/local/bin/tmux'
alias    tmux='TERM=xterm /usr/bin/tmux'
alias  dialog='TERM=linux dialog'
alias psmysql='ps -ef | grep [m]ysql'
alias   psw3m='ps -ef | grep [w]3m'
alias  kmysql='mysql kts'
alias   xgrep="find . -name '*' -type f | xargs grep --color"
alias  upconf="rm -f /home/s/fs/opt/conf/config.*; svn up /home/s/fs/opt/conf/config.org;" 
alias  clrnfs="Svn | grep nfs | awk '{print $2}' | xargs rm -f"
alias fbcache="sync; echo 3 > /proc/sys/vm/drop_caches"

# soptter
function M()        { m1 $@ | tail -18; } # M() { m1 $@ | nl -w 3 -s' ' | less -i ;}

lwd() 
{
    cat -n /root/.awd 2>/dev/null | grep '[0-9]' || {
        echo "Usage: lwd" &&
        echo "  run awd first" && return
    }

    local path_index
    while read -p "     Select a path you wanna goto [1]: " path_index; do
        local path_goto=`sed -n ${path_index:-1}p /root/.awd 2>/dev/null`
        
        if [ -d "$path_goto" ] ; then
            cd $path_goto
            break
        else
            echo "     invalid path[$path_index]: ${path_goto}"
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
    local ethip="192.168.2.41"
    ifconfig | grep -q -w "$ethip" || ifconfig eth6 $ethip 
    return

    local ip=`ifconfig eth5 | grep "inet addr" | 
                cut -d : -f 2 | cut -d ' ' -f 1`
    local eth5ip="192.168.2.41"
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

    /home/n/rc.d/mksquashfs
    "
}

#orgpath() { export PATH=$ORGPATH; }
#monpath() { export PATH=$MONPATH; }

.tar() 
{
    [ "$#" -ne 2 ] && echo "Usage: .tar -zxvf file.tgz" && return
    mkdir -p ${2%.*} && tar $@ -C ${2%.*}
}

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
export PATH=.:~/bin:$PATH
export CDPATH=.:~:/home:/1
export SVN_EDITOR=vim
