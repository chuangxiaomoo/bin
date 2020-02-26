# 修改 root 密码，hostname

* 控制台，修改密码，修改 hostname，重启机器

# 修改 sshd 端口

* vi /etc/ssh/sshd_config 增加`Port 33333`
* 在控制台是增加安全组
* 删除`Port 22` 

# 禁用欢迎信息

chmod -x /etc/update-motd.d/*

# 使用 BASH 为默认 SHELL

sudo dpkg-reconfigure dash
然后选择【否】

# 安装必要的软件

apt install git
apt-get install reptyr
apt-get install ctags

# gitee.com 配置 vim

#

