#! /bin/bash -
#---------------------------------------------------------------------------
#          FILE: t2.sh
#         USAGE: ./t2.sh 
#   DESCRIPTION: 
#       OPTIONS: -
#  REQUIREMENTS: -
#          BUGS: -
#         NOTES: -
#        AUTHOR: chuangxiaomoo (God helps those who help themselves) 
#  ORGANIZATION: 
#       CREATED: 2014-02-22 09:05:29 PM
#      REVISION: 1.0 
#---------------------------------------------------------------------------

function fn_main()
{
    
    sina=http://vip.stock.finance.sina.com.cn
    url1="$sina/corp/view/vRPD_NewStockIssue.php?page=1&cngem=0&orderBy=NetDate&orderType=desc"
    url2="$sina/corp/view/vRPD_NewStockIssue.php?page=2&cngem=0&orderBy=NetDate&orderType=desc"

    # w3m -dump "$url1" | grep '2014-' >  newstock
    # w3m -dump "$url2" | grep '2014-' >>  newstock

    cat newstock | grep '2014-' | awk '{print $5, $1}' > onboard.1
    cat newstock | grep '2014-' | awk '{print $5, $1}' | sort -r -g -k1 > onboard.2
}

fn_main $@

