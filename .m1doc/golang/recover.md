```go
package main

import (
	"fmt"
	_ "time"
)

func fn_panic() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("recovered:", r)
		}
	}() // 匿名函数()不能少，否则 err: function must be invoked in defer statement

	var mymap map[int]string

	//mymap = make(map[int]string, 1)   // map 只是一个引用变量，需要 make()

	mymap[0] = "hello"

	fmt.Println(mymap[0])
}

func main() {
	fn_panic()
	fmt.Println("end")
}
```
