# type 值

| NO. | 类型    | 描述                           |
| :-- | :------ | :------                        |
| 1   | byte    | 类似 uint8                     |
| 2   | rune    | 类似 int32                     |
| 3   | uint    | 32 或 64 位，跟 `cpu 位数`一致 |
| 4   | int     | 与 uint 一样大小               |
| 5   | uintptr | 无符号整型，用于存放一个指针   |

# type 引用类型

只是一个地址。

# 垃圾回收

当没有任何变量引用这个地址，该地址就成为一个垃圾，会被 GC 回收。

# new() and make()

1. new和make都不是go的关键字，而是go预定义的函数
2. make返回一个变量而new返回一个变量的指针。
3. 只有make能做的操作：
   * 创建一个chan
   * 创建一个内存预分配的map
   * 创建一个内存预分配的slice，并且slice的len可以不等于cap

