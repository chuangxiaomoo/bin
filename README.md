bin
===

Frequently-linux-useful-script, and the project include 2 part. 

## part 1

Simple geek bash scripts

## part 2

Stock system of China, get free data vai `w3m -dump` and load the data into mysql.


## Installation

1. links 

ln -sf ~/.vim/.vimrc ~/.vimrc
ln -sf ~/bin/common.rc /etc/common.rc
ln -sf ~/bin/.awdr ~/.awdr

2. append below code block ~/.bashrc
`
. ~/bin/.bashrc
. ~/bin/.export
. ~/bin/.bind
`
3. alternative install

[](+/Decrypt ~/py/README.md)
openssl enc -d -aes128 -in Encrypt.bz2 | tar jxvfP - ~/py/README.md

