# interface

* 接口，可以看成是一个`只包含函数指针的结构体`
* 接口，是`引用`类型，而不是值类型
* interface_var = struct_var，即相当于`两个类型的指针赋值`

实现接口，是对继承的一种补充：悟空 = 猴子+鱼+鸟

# interface vs. 继承

* 继承      is-a   解决代码复用与维护性
* interface like-a 价值主要在于设计

# 类型断言

* `void *p` 强转

