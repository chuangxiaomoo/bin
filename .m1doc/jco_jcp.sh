#!/bin/bash - 

#   DESCRIPTION: list jcps need to be refactory, always end with Cfg

function fn_main() {

    . ~/.env
    jcpfile=$p_/jcpcmd/jcp_cmd.c

    jcp_funcs=(`grep -B20 "MAP_OPT_ARG_S *maps" $jcpfile  | 
                grep "int *JCPCmd" | awk -F"[ \(]" '{print $3}'`)

                    
    str_search=${jcp_funcs[0]}
    
    local idx
    for (( idx=1; idx<${#jcp_funcs[@]}; idx+=1 )); do
        str_search="${str_search}|${jcp_funcs[$idx]}"
    done

    str_search="(${str_search})"

    # grep -E "${str_search}" $jcpfile | awk -F'"' '/JCP_CMD_REG/ { print $2}'

    grep -v -E "${str_search}" $jcpfile | awk -F'"' '/JCP_CMD_REG/ { print $2}'
}

fn_main $@

