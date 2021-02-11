# ARRAY for range

在 Go 中，数组是不常见的，因为其长度是类型的一部分，限制了它的表达能力，比如 `[3]int 和 [4]int` 就是不同的类型。

```go
for index, vale := range array {
}

for i, v := range array2 {
}

for _, v := range array3 {
}
```

# ARRAY 参数值传递

```go
func test(arr [3]int) {
}
// 数组的长度是类型的一部分， [3]int 与 [4]int 是不一样的类型
```

# ARRAY 参数引用传递

```go
func test(arr *[3]int) {
}
// 数组的长度是类型的一部分， [3]int 与 [4]int 是不一样的类型
```

# slice 传递任意长度参数

搜索 go slice 结合源码解读

```go
// 切片是数组的引用
// 长度不固定
// slice[i_sta, i_end)，定义如下：

type slice struct {
	array unsafe.Pointer
	len   int
	cap   int
}

package main

import "fmt"

func main() {
    a1 := [1]int{1}
    demo(a1[:])

    a2 := [2]int{1, 2}
    demo(a2[:])
}

func demo(s []int) {
    fmt.Println("Passed:", s)
}
```

# make 创建 slice

```go
slice := make([]int32, len, cap)        // 相当于 malloc()

// append 相当于 clang realloc()
slice  = append(slice, 100, 200, 300)   // 修改 slice
slice2 = append(slice, 100, 200, 300)   // 不修改 slice
```

* 切片可再次切片
* slice 可以 append 扩容


