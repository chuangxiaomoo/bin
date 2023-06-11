#! /bin/sh
rsync -avz --delete --filter='P .git' test4g@121.40.104.39:/home/test4g/ $@
