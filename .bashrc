# . ~/bin/.bashrc

# alias
alias    ..='cd ..'
alias   ...='cd ../..'

alias    ll='ls -alF'
alias    la='ls -A'
alias     l='ls -CF'

alias    rr='rm -rf'
alias    rm='rm -i'
alias     i='vi'
alias     m='make'
alias    mh='make http1'
alias    md='Markdown.pl --html4tags'
alias   slc='sloccount'
alias  slcd='sloccount --cached --details'  # slcd | grep "sysctrl" | print_sum
alias     x='chmod 777 '
alias    xt='chmod 777 /tftpboot/*'
alias    xx='tar -zxvf'
alias   irc='vi /root/.bashrc; . /root/.bashrc'
alias   .rc='. /root/.bashrc'
alias   .ps='PS1="[\w]\n\u-> \[\033[0m\]"'
alias    ct='cd ~/sh/t'
alias   cwd='pwd >> ~/.env;vi ~/.env; .rc'
alias   swd='pwd > ~/.swd'    # save pwd
alias   awd='cp ~/.awd /dev/shm/.awd && pwd > ~/.awd && cat /dev/shm/.awd >> ~/.awd'   
alias   iwd='vi /root/.awd'   
alias   gwd='cd `cat ~/.swd`' # save pwd
alias    cs='cscope -Rbq *'
alias vboxr='/etc/init.d/vboxadd-service restart' # ;umount -a 2>/dev/null; mount -a

alias    v1='vi /root/bin/m1'
alias    v2='vi /root/bin/m2'
alias    v7='vi /root/bin/7Lite'
alias    vj='vi /root/bin/j2box'
alias    vr='vi -R'
alias    vt='vi /root/bin/.m2doc/tick'

alias   w3m='w3m -cols 78'

alias   ltmux='TERM=xterm /usr/local/bin/tmux'
alias    tmux='TERM=xterm /usr/bin/tmux'
alias  dialog='TERM=linux dialog'
alias psmysql='ps -ef | grep [m]ysql'
alias   psw3m='ps -ef | grep [w]3m'
alias  kmysql='mysql kts'

# soptter
alias   isp='vi /root/bin/stk/.soptter'   
asp()   { [ -n "$@" ] && echo $@ | xargs -n1 >>/root/bin/stk/.soptter ;}
M()     { m1 $@ | tail -18; } # M() { m1 $@ | nl -w 3 -s' ' | less -i ;}

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
            echo "     invalid path index $path_index"
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

# 
export CDPATH=.:~:/home:/1
export SVN_EDITOR=vim
