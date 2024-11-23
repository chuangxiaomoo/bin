#! /bin/sh
#---------------------------------------------------------------------------
#          FILE: eck.sh
#         USAGE: ./eck.sh 
#   DESCRIPTION: 根据日志快速排查系统潜在的 Bug
#        AUTHOR: zhangjian () 
#  ORGANIZATION: JCO
#       CREATED: 2024-10-30 08时37分03秒
#      REVISION: 1.0 
#---------------------------------------------------------------------------

maps=(
    "error_message"         功能说明                        Debug指南
    "not null!"             js库handle未初始化为NULL        排查相应代码hdl初始化
)

fn_main()
{

}

fn_main $@

