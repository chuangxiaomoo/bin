# func vs. method

* method 的调用，不区分指针、变量(编译器内部做了处理)
* `func 的形参严格区分`

```go
package main

import (
	"fmt"
)

type Test struct {
	name string
	age  int
}

func (t *Test) Print() {
	fmt.Println("hello", t.name)
}

func main() {
	var me Test = Test{"zhangj", 18}
	you := Test{"moo", 18}

	pme := &me
	pme.Print()
	me.Print()
	(&me).Print()

	you.Print()
}
```
