# bubble

go 中只有 for 没有 while，这充分展现了类似 PYTHON 的哲学。`Life is short, 每一段路，你只需要一种交通工具`

```go
package main

import "fmt"

/*
 * bubble: 最小的在 0 位置，最大的在 arr[len-1]
 */

//func bubble(arr *[8]int) {        // arr 实现
func bubble(arr []int) { // slice 实现
	for j := 1; j < len(arr); j++ {
		for i := 0; i < len(arr)-j; i++ {
			//fmt.Println("i = ", i, arr[i])
			if arr[i] > arr[i+1] {
				tmp := arr[i]
				arr[i] = arr[i+1]
				arr[i+1] = tmp
			}
		}
	}
}

func main() {
	fmt.Println("vim-go")
	// arr := [8]int{4, 8, 7, 3, 6, 9, 20, 1}   // arr 实现
	arr := []int{4, 8, 7, 3, 6, 9, 20, 1, 55, 0, 99}

	for k, v := range arr {
		fmt.Println(k, v)
	}

	fmt.Println("--------")
	// bubble(&arr)        // arr 实现
	bubble(arr) // arr 实现

	for i := 0; i < len(arr); i++ {
		fmt.Println("i = ", i, arr[i])
	}
}
```

# continue break LABLE

可以直接 continue break 多层循环。

