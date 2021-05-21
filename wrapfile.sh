#! /bin/sh
#---------------------------------------------------------------------------
#          FILE: wrapfile.sh
#         USAGE: ./wrapfile.sh 
#   DESCRIPTION: 
#       OPTIONS: -
#  REQUIREMENTS: -
#          BUGS: -
#         NOTES: -
#        AUTHOR: zhangjian () 
#  ORGANIZATION: 
#       CREATED: 2021-05-18 20时46分40秒
#      REVISION: 1.0 
#---------------------------------------------------------------------------

fn_main()
{

    local i=
    for i in $@; do
        if [ ! -f "$i" ]; then
            echo "file <$i> not exist"
            return 1
        fi

        temp=/tmp/a
        cp $i $temp
        echo "#ifdef __DF_OK__" > $i
        cat $temp >> $i
        echo "#endif" >> $i
    done
}

fn_main $@

