## 目标

## 真正原因 - True causes

## 问题描述 - from R&D or Tester

2019-03-20(Sat)
  测试部  项目讨论会上测试报告: 设备多次出现内存不足导致设备重启

2019-03-27
  测试部  重启得贼快(操作: 恢复出厂)
  研发    出现重启取日志: cat /sys/class/mstar/isp0/isp_ints
  测试部  串口打不进去东西啊
  研发


## 现象分析 - log

> <34960 ms>      OMX[226]        <h265> have no input buffer for 208 ms and 0 buffers cached

## 原因分析 - 原因猜想，目标分解，process to true causes

## 解决方案 - 包括对未来的防御

## Time

  (1) 整个问题过程花费的时间

  (2) 问题引入、发现、解决
      解决引入                自黑光修改PCB以来
      解决日期                2019-03-27 ~ 2019-04-02
      总结日期                2019-04-02

## Introspection
