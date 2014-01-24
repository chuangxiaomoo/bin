#! /bin/bash 

function fn_main()
{
    if [ "$#" -lt 1 ] ; then
        echo "Usage: $0 keyword" && exit 1 
    fi

    # call from vimrc map
    if [ "$MANWIDTH" == 88 ]  ; then
        f_redirct=/dev/shm/ma
    else
        f_redirct=/dev/stdout
    fi

    keyword=$1 
    TMP=/tmp/.man 

    man -f ${keyword} 2>&1 | tee $TMP  
    [ ${PIPESTATUS[0]} -ne 0 ] && exit 1

    # only one
    line=`cat $TMP | wc -l` 
    [ "${line}" -eq 1 ] && man $keyword > $f_redirct && exit

    # default the 1st
    read -p "Please input manpage index number: " man_index

    while :; do
        [ "${man_index}" == "" ] && man $keyword > $f_redirct && exit

        # multi choice
        indexs=`man -f $keyword | awk -F'[ ()]' '{print $3}'` 
        match_word=`echo ${indexs}| xargs -n 1 | grep "\<$man_index\>"`
        match_open=`echo ${indexs}| xargs -n 1 | grep "\<$man_index"`
        match_lines=${match_word:-${match_open}}

        match_count=`echo $match_lines | wc -w`

        if [ $match_count -eq 1 ]; then
            man $match_lines $keyword > $f_redirct 
            exit
        else
            read -p  "Please input a accuracy index number: " man_index
        fi
    done
}

fn_main $@

