# oo WHY

* 封装：解耦、安全
* 继承：代码冗余、不易于维护. golang 以`嵌套匿名结构体`的形式实现，提高`复用`
        血源就近原则：A.name A.B.name 找那个更短的变量，即 A.name
        两个匿名祖先中有同名：
        命名祖先的成员访问：
        多重继承
* 多态：通过接口实现。体现了高内聚低耦合的思想

# oo 的步骤

* 声明 type Xxx struct {}
* 编写结构体的字段
* 编写结构体的方法

# oop struct

```go
type Person struct {
  Name string
  Age int
  Scores [5]float64
  ptr *int
  slice []int
  map1 map[string]string
}
// 特点 
// 1. int string 等一律是放在最后
// 2. 变量名在最前
// 3. * [] 等复合修饰在中间
```

# 结构体

```go
var person Persion := Persion{"zhangj", 36}
var person *Person := new(Persion)
```

