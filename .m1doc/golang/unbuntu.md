# https://golang.org/dl/

tar -C /usr/local -xzf go1.15.8.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# 插件参照

https://www.cnblogs.com/bonelee/p/6500613.html

# vim-go 依赖库

mkdir -p $GOPATH/src/golang.org/x
cd $GOPATH/src/golang.org/x
git clone https://github.com/golang/tools.git
git clone https://github.com/golang/lint.git
:GoInstallBinaries
