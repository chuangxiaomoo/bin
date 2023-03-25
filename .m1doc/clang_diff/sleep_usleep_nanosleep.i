# if 差异

1. 粒度不一样
2. sleep() 是库函数，而其它两个是系统函数
3. 实现方式上，sleep() 通过 alarm() 现实，被推送到等待列表。进程处理 Sleeping 状态
4. usleep() suspend 进程，相当于给进程发了一个 STOP 信号

# if 相同点

都是可中断的，且会返回剩余(remain)的时间。

# if Linux中进程的六种状态 https://blog.csdn.net/qq_49613557/article/details/120294908

R运行状态(running)
S睡眠状态(sleeping)
D磁盘休眠状态(Disk sleep)
T停止状态(stopped)
Z僵尸状态(Zombies)
X死亡状态(dead)

孤儿进程
僵尸进程是什么
为什么要有僵尸进程
僵尸进程的危害

