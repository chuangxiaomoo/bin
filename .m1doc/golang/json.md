# json

https://www.json.cn/

# tag

# 反序列化

```go
  //定义一个 slice
  var slice []map[string]interface{}

  //反序列化,不需要 make,因为 make 操作被封装到 Unmarshal 函数
  err := json.Unmarshal([]byte(str), &slice)

  if err != nil {
    fmt.Printf("unmarshal err=%v\n", err)
    fmt.Printf("反序列化后 slice=%v\n", slice)
  }
```
