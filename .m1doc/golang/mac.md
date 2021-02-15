# mac profile

sudo vi /etc/profile

也有推荐使用: vim ~/.bash_profile

# 插件安装 要使用 七牛 PROXY

[vim-go](https://www.cnblogs.com/bonelee/p/6500613.html)
[vim-go](https://blog.csdn.net/zxc3590235/article/details/104232764)

先设置 PROXY:

export GO111MODULE=on
export GOPROXY=https://goproxy.cn

再执行 vim :GoInstallBinaries

~/.vim/bundle/vim-go/compiler/go.vim 要注释行 `errorformat+=%-G%.%#`

# mac os X golangci-lint 失败

export CGO_ENABLED=0

# godoc

[](https://jialinwu.com/post/install-godoc/)

cd ~/go/src/golang.org/x/tools/cmd/godoc; go build

godoc -http=:8090

# goland

