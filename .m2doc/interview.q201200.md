# 题

1. 产生段错误的原因有哪些？如果 jco_server 出现了段错误，请写出调试的步骤，找出段错误具体在哪一个函数？


2. 说出以下命令的作用，分别用于处理哪些问题？

xargs
arping
dd
df
du
diff
dmesg
gzip
head
kill
md5sum
netstat

3. 说出系统中都有哪些日志文件，分别都是什么作用？

# 答案

1. 段错误

* 产生段错误的原因数组越界、非法指针引用。
* 调试步骤
    * -g 交叉编译得 jco_server.nonstriped
    * strip 后得 jco_server.nonstriped
    * 运行，并触发产生 core 文件
    * 设置 .gdbinit
    * 运行 gdb -c core jco_server.nonstriped
    * bt 打印调用栈

2. 命令的作用

xargs    从 STDIO 构建命令并执行
arping   发送 arp 报文
dd       copy 文件
df       报告文件系统使用情况
du       报告文件使用情况
diff     比较两个文件是否相等
dmesg    查看内核日志
gzip     压缩文件
head     查看文件头n行
kill     发送信号
md5sum   md5校验
netstat  查看网络链接状态

3. 日志

| 日志文件              | note                                 |
| :------               | :------                              |
| dmesg                 | 内核日志 /proc/kmsg Oops kernel SEVG |
| /tmp/messages         | syslog, 打印接口 syslog(), logger    |
| /tmp/messages.dot     | toggle 3 1001, stdout 重定向         |
| /ipc/web/syslog.log   | 同 /tmp/messages                     |
| /ipc/web/log          | 可 HTTP 访问，链接到 /opt/log/       |
| /opt/log/upgrade.log  | 升级日志、恢复出厂日志               |
| /opt/log/alarmlog     | 告警日志，接口 alarm_add_event_log() |
| /opt/log/applog       | 应用日志，接口 LOG                   |
| /opt/log/messages     | 异常重启日志                         |

