#! /bin/sh
#---------------------------------------------------------------------------
#          FILE: wrapfile.sh
#         USAGE: ./wrapfile.sh 
#   DESCRIPTION: 将参数指向的文件，进行一次类似头文件的 #ifdef #endif
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

