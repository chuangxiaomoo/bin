#! /bin/bash
#
# 1. @ print all
# 2. / search
# 3. subcommand
#

export ubt=192.168.2.41

function fn_accuracy_help() {
    local sub=${FUNCNAME[2]##fn_}
    local routine="${sub##main}"
    local routine2=${routine:-${0##*/}}

    echo
    echo -e "Usage: `basename $0` <command> <subcommand>\n"
    echo -e "Available subcommands of ${routine:-${0##*/}} ${LASTARG}->"
    echo ${match_lines} | tr ' ' '\n' | sed 's/^/   /g'

    return 0
}    

function fn_help0() {
    local sub=${FUNCNAME[2]##fn_}
    local routine="${sub##main}"
    local routine2=${routine:-${0##*/}}

    echo
    echo -e "Usage: `basename $0` <command> <subcommand>\n"
    echo -e "Available subcommands of ${routine:-${0##*/}}:"

    # echo "${#opts[@]}" 

    if [ "${#opts[@]}" -lt 36 ] ; then
        echo ${opts[@]} | tr ' ' '\n' | sed 's/^/   /g'
    elif [ "${#opts[@]}" -lt 72 ] ; then
        echo ${opts[@]} | awk '{
            for (i = 1; i <= NF; i++) {
                printf("    %-20s", $i)
                i++
                printf("    %-20s\n", $i)
            }
        }' 
    else
        echo ${opts[@]} | awk '{
            for (i = 1; i <= NF; i++) {
                printf("    %-20s", $i)
                i++
                printf("    %-20s", $i)
                i++
                printf("    %-20s\n", $i)
            }
        }' 
    fi

    echo
    return 0
}

function fn_print() {
    local sub=${FUNCNAME[2]##fn_}
    local routine="${sub##main}"
    local routine2=${routine:-${0##*/}}
    local routine3=${routine2##print}

    case "$1" in
    '@')
        for o in ${opts[@]}; do
            echo
            printf -- ">>> %-4s%-4s\n" ${routine3:-"        "} ${o}
            fn_${o} @
        done
        return
        ;;
    '/')
        if [ -z "${2}" ]; then
            $0 @ 2>/dev/null | grep --color '>>>'
            return
        else
            $0 @ 2>/dev/null | grep '>>>' | grep -i -B10 -A2 --color ${2}
            return
        fi 
        ;;
    *)
        ;;
    esac

    # using xargs make system too slow
    # match_word=`echo ${opts[@]}| xargs -n 1 | grep  "\<$1\>"`   
    # match_open=`echo ${opts[@]}| xargs -n 1 | grep  "\<$1"`

    # grep -w not work when chinese, but grep  "\<$1\>" dose  
    match_word=`echo ${opts[@]}| tr ' ' '\n'| grep  "\<$1\>"`   
    match_open=`echo ${opts[@]}| tr ' ' '\n'| grep  "\<$1"`

    match_lines=${match_word:-${match_open}}
    match_count=`echo $match_lines | wc -w`

    if [ $match_count -eq 1 ]; then
        fn_${match_lines} ${@:2}
    elif [ $match_count -eq 0 ] || [ -z "$1" ]; then
        fn_help0
    elif [ $match_count -gt 1 ]; then
        fn_accuracy_help
    fi
}
