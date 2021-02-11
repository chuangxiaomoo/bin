# goroutine

* sync.Mutex lock
  lock.lock()
  lock.unlock()
* 如何同步，等待 goroutine 结束？
  * channel 收集到足够 REPLY
  * sync.WaitGroup

# channel 的本质是线程安全的 FIFO

* chan 的遍历
  * 要先关闭 close(intChan)
  * 只能用 for v := range intChan  {}

# goroutine & chan

```go
// 16.8.4
// 读写同步
// intChan := make(chan int, 10)

package main

import (
	"fmt"
	_ "time"
)

//write Data
func writeData(intChan chan int) {
	for i := 1; i <= 50; i++ { //放入数据
		intChan <- i
		fmt.Println("writeData ", i)
		//time.Sleep(time.Second)
	}

	close(intChan) //关闭
}

//read data
func readData(intChan chan int, exitChan chan bool) {
	for {
		v, ok := <-intChan
		if !ok {
			break
		}
		//time.Sleep(time.Second)
		fmt.Printf("readData 读到数据=%v\n", v)
	}
	//readData 读取完数据后,即任务完成
	exitChan <- true
	close(exitChan)
}

func main() {
	//创建两个管道
	intChan := make(chan int, 50)     // 改成10的话，只要有人读，也不会有问题
	exitChan := make(chan bool, 1)

	go writeData(intChan)
	go readData(intChan, exitChan)
	//time.Sleep(time.Second * 10)
	for {
		v, ok := <-exitChan
		if !ok {
			fmt.Println("err val: ", v)
			break
		} else {
			fmt.Println("suc val: ", v)
		}
	}
}
```
