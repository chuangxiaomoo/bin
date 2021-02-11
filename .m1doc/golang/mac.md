# mac profile

sudo vi /etc/profile

也有推荐使用: vim ~/.bash_profile

# 插件安装

[vim-go](https://www.cnblogs.com/bonelee/p/6500613.html)
[vim-go](https://blog.csdn.net/zxc3590235/article/details/104232764)

export  GOPROXY=https://goproxy.io,direct

~/.vim/bundle/vim-go/compiler/go.vim 要注释行 `errorformat+=%-G%.%#`

# godoc

[](https://jialinwu.com/post/install-godoc/)

cd ~/go/src/golang.org/x/tools/cmd/godoc; go build

godoc -http=:8090

# goland

