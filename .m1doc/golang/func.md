# 函数

```go
package main

import "fmt"

func main() {
  _,numb,strs := numbers()  // - 表示：只获取函数返回值的后两个
  fmt.Println(numb,strs)
}

// 一个可以返回多个值的函数
func numbers()(int,int,string){
  a , b , c := 1 , 2 , "str"
  return a,b,c
}

// 输出结果： 2 str
```

# 基本类型和数组作为参数，都是值传递。即：在函数中修改，不会改变在 caller 中的值

func(a, b)

# 函数也是一种数据类型


```go
func getsum(a int, b int) {
    return a + b
}

func caller(cb func(int, int) int, x int, y int) {
    return cb(x, y)
}
```

# type 相当于 clang 的 typedef


# 支持对函数返回值命名

```go
func getsum(a int, b int)(int sum) {
    sum = a + b
    return
}
```

# init 函数

* 单独 build 时，全局变量最先被执行。但`import 时，init() 比全局变量先执行`
* 在 main() 之前，被框架调用。


# 匿名函数

```go
// 函数中定义函数
func example() {
    cb := func(a, b int) {
      return a + b
    }
}

// 全局匿名函数
var (
    cb := func(a, b int) {
      return a + b
    }
)
```


