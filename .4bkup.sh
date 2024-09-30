#! /bin/sh

# ~/bin/4bkup.rsync is old

. ~/gitee/social/priv/test4g.rc

sshpass -p ${t4g_pass} rsync -avz --delete --filter='P .git' test4g@121.40.104.39:/home/test4g/www/tool ${1:-/home/test4g/www/tool}

