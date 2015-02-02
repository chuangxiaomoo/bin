# 基础数据表

tables="
    day
    fenbi
    stamp_day

    cap
    tbl_yjbb
    xRD
    tbl_xRDdate

    exitcode

    ipo
    rzrq_day
"

function fn_main()
{
    listf='/tmp/kts_tables'

    mysql -N kts <<< "SHOW TABLES" | tee /tmp/kts_tables.org > ${listf}


    local i=
    for i in ${tables}; do
        sed -i "/${i}/d" ${listf}
    done

    echo "begin drop..."

    for i in `cat ${listf}`; do
        echo "DROP TABLE ${i}"
        mysql -N kts <<< "DROP TABLE ${i}"
    done

    # mysqldump kts > /tmp/kts.sql
    
    return $?
}

fn_main $@
