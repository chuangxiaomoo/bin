```cpp
# 1. 输出结果

int arr[]={5,6,7,8,9,10};
int *ptr=arr;
*(ptr++)+=123;
printf(＂%d,%d＂,*ptr,*(++ptr));

# 2. 输出结果

void footprint(int first_run, int count)
{
    if ((!first_run) || (++count)) {
        printf("%d\n", count);
    }
}

int main(int argc, char *argv[])
{
    footprint(0, 4);
    return 0;
}

# 3. 编写 helloworld.c

1. 简述预处理(preprocess)、汇编(assemble)、编译(compile)、链接(link)、执行(run)对源文件或可执行文件都做了什么？
2. 编写 helloworld.c，实现打印输出 "Hello World!"
3. 写出 gcc 进行上述操作的命令。

# 4. 编写标准宏

MIN()，这个宏输入两个参数并返回较小的一个
DBG(fmt, args...)，这个宏将文件与行号同时打印到 stdout 和 stderr

# 6. 如何避免头文件被重复包含？如何使C++的函数可以被 C 调用？

# 7. 函数定义时，数组名和指针指针作为参数，有什么区别？

int func(char *p)
int func(char p[])

# 8. 用变量a 给出下面的定义

一个指向有10个整型数数组的指针;                             
一个指向函数的指针，该函数有一个整型参数并返回一个整型数;   
一个有10个指针的数组，该指针指向一个函数，该函数有一个整型参数并返回一个整型数; 

# 9. 用 C 语言实现冒泡算法

# 10. 不使用库函数，实现函数 int atoi(const char *str)，将字串转换为整型？
```
