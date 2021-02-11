# const

```go
// 常量还可以用作枚举
const (
    Unknown = 0
    Female = 1
    Male = 2
)
```

# iota 相当于行号

```go
package main

import "fmt"

func main() {
    const (
            a = iota   //0
            b          //1
            c          //2
            d = "ha"   //独立值，iota += 1
            e          //"ha"   iota += 1
            f = 100    //iota +=1
            g          //100  iota +=1
            h = iota   //7,恢复计数
            i          //8
    )
    fmt.Println(a,b,c,d,e,f,g,h,i)
}

//运行结果为： 0 1 2 ha ha 100 100 7 8
```

# 默认值

都是往 0 靠近的。bool 的变量默认是 false

# 强制转换

