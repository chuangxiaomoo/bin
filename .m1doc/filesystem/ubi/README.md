# ubifs

  [UBIFS介绍](http://www.360doc.com/content/11/1208/10/7958105_170580625.shtml)

  mtd-utils 及 ubi-utils 交叉编译
  [](http://blog.csdn.net/zjjyliuweijie/article/details/7205374)

# 解压 ubi 方法 1

ubi_ctrl 这一步会失败，搞了很久，最终也没有能够走通。

```bash
modprobe nandsim first_id_byte=0x2c second_id_byte=0xda third_id_byte=0x00 fourth_id_byte=0x15
modprobe ubi mtd=0
ubidetach /dev/ubi_ctrl -m 0
ubiformat /dev/mtd0 -s 2048 -f 
ubiattach /dev/ubi_ctrl -m 0 -O 2048
mkdir /mnt/loop
mount -t ubifs ubi0 /mnt/loop
cp -R /mnt/loop/* /new/directory
```

# 解压 ubi 方法 2

https://github.com/jrspruitt/ubi_reader

1. 安装 [python2.7](python2.7) and setuptools pip 
2. 安装 [ubi_reader](filesystem/ubi/ubi-reader-install-and-usage.md): pip2 install ubi_reader

ubireader_extract_files -k rootfs.ubifs

