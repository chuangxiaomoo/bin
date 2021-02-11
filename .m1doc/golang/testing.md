# e.g.

```go
/* main.go */
package add

import (
	"fmt"
	"time"
	"unsafe"
)

func Add(tail int) int {
	var sum int

	for i := 0; i < 10; i++ {
		sum += i
	}
	return sum
}

```

```go
/* main_test.go */
package add

import (
	"testing"
)

func TestAdd(t *testing.T) {
	res := Add(10)
	if res != 30 {
		t.Fatalf("error %v != 30", res)
	}
	t.Logf("succ")
}
```
