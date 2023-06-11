#! /bin/sh
#---------------------------------------------------------------------------
#         USAGE: ./.2utf8.sh
#   DESCRIPTION: 将所有当前目录内所有 .c 转换为 UTF8
#                默认过滤 feiyan1.6.2 aliyunlibs
#   OUTPUT     :
#                转换文件列表 .xslt.files
#                转换错误文件 .xslt.error

fn_main()
{
    exclude_path="
        feiyan1.6.2
        aliyunlibs
    "

    cpplang=(
        # *.c is default
        '*.h'
        '*.cpp'
        '*.cc'
        '*.xx'
        # include
        '*.hh'
        '*.hpp'
        '*.inc'
    )

    local idx
    local namepatt="-iname '*.c' -print"
    for (( idx=0; idx<${#cpplang[@]}; idx+=1 )); do
        namepatt="${namepatt} -o -type f -iname '${cpplang[$idx]}' -print"
    done

    for x_path in $exclude_path; do
        # -path -prune must begin with '/' './' '../' and
        #               not end with '/'
        x_path=${x_path%/}
        if [ "${x_path:0:1}" != '/' ] && [ "${x_path:0:3}" != '../' ]; then
            x_path=./${x_path#./}
        fi
        [ ! -e "$x_path" ] && echo skip non-exist $x_path && continue
        echo "skip path $x_path"
        exclude_opt="$exclude_opt -path '$x_path' -prune -o"
    done

    eval find . $exclude_opt $namepatt > $clist
    #ho "find . $exclude_opt $namepatt > $clist"; exit

    while read; do
        #echo $REPLY
        enca -L zh_CN   $REPLY  > /tmp/enca
        if grep -q 'Chinese' /tmp/enca; then
            enca -L chinese -x UTF-8 $REPLY
            if [ "${?}" -ne 0 ]; then
                echo $REPLY >> ${error}
                echo -- $REPLY
                cat /tmp/enca
                sed -i 's/$//g' $REPLY
            fi
        fi
    done < ${clist}

    if test -s ${error} ;then
        echo ------------
        echo ${error}
        echo ------------
        cat  ${error}
    fi
}

clist='.xslt.files'
error='.xslt.error'
> ${error}
fn_main $@
