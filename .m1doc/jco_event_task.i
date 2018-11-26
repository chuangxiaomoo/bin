/* 设计 */

微观：程序 = 数据 + 算法
宏观：系统 = 消息 + 服务

# define Server端处理高并发网络请求主要方法

循环：早期系统使用简单的循环选择解决方案，即循环遍历打开的网络连接的列表，判断是否有要读取的数据。这种方法既缓慢（尤其是随着连接数量增加越来越慢），又低效（因为在处理当前连接时其他连接可能正在发送请求并等待响应）。在系统循环遍历每个连接时，其他连接不得不等待。如果有 100 个连接，其中只有一个有数据，那么仍然必须处理其他 99 个连接，才能轮到真正需要处理的连接。

socket IO复用：这是对循环方法的改进，它用一个结构保存要监视的每个连接的数组，当在socket发现数据时会select/epoll调用会返回到用户空间，然后可以继续后续处理。

异步socket IO：利用现代内核中的多线程支持监听和处理连接，为每个连接启动一个新线程。这把责任直接交给操作系统，但是会在 RAM 和 CPU 方面增加相当大的开销，因为每个线程都需要自己的执行空间。另外，如果每个线程都忙于处理网络连接，线程之间的上下文切换会很频繁。这里的异步其实是不是真正的异步，模拟异步IO，将IO的操作交给专门的thread来处理而异。

# define 系统中任务主要可分为4类

1 timer.定时任务
2 delay.延时任务
3 bgread.网络套按字
4 loop().消息消费者(处理任务.可扩展为thread_pool处理) ev_follow() ev_update()
5 shmbuf().取流

create_BGread_schedule()
create_time_engine()

delay_ctrl_exec(DELAY_CMD_SETETHMAC, outer.mac, sizeof(outer.mac));
eventNotify(JEvent_EthMacCfgChg);

# define Task主要特点

1 机器的本质是人意志的延伸，响应人的req(请求、命令、消息)
2 机器本身是一个横向分层，纵向分解结构。
  req通过层层传导+分解，直到被处理。
  人机交互的过程，[生产者-消费者模型](人生产消息，机器消费) 
3 单核CPU，基本时间分片来完成多任务实现，context切换成本。
  消息服务，以提供[服务](callback)的形式，并行任务串行化，减少context切换损耗，以提高系统效率。
  依赖倒置
4 实现上，每个类别都有一个线程，内部使用静态变量在第一次执行时初始化。如此便不用 init() 函数。

# define 消息生命过程 event-producer-attach-customer

_生:
int cbCentreInit()
    event_manager_register_event_type(p_em, confCmd[i].id_param);
_住:    
    attach_config(JEvent_EthcfgChg, test_attach_config_ethcfg, NULL);
    if !exists(event_manager_register_event_type) printf("This event manager doesn't know about '106' events")
_坏:    
    eventNotify(JEvent_EthcfgChg);
_灭:
    test_attach_config_ethcfg_cb();

# define task 设计

1 调度: 直接使用 TLV + Domain Socket + Select 定时
2 执行: 使用双线程 + 队列
3 调试: 可以显示系统的运行数据，每个task的使用时间
