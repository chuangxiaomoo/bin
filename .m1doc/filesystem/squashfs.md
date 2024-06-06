## 解压 squashfs 的两种方案

**方法一**

> sudo unsquashfs -d /media/location1 /media/location2/file.squashfs

**方法二**

```bash
## Mount the squashfs FILE.SQUASHFS :
sudo mount -t squashfs PATH/TO/FILE.SQUASHFS /mnt

## Copy his content to DIRECTORY (must exist) :
sudo cp -av /mnt/. PATH/TO/DIRECTORY

## Unmount the squashfs FILE.SQUASHFS :
sudo umount /mnt
```

## 查看信息

> unsquashfs -s 2.sqfs

Found a valid SQUASHFS 4:0 superblock on 2.sqfs.
Creation or last append time Sat Nov 18 14:19:33 2023
Filesystem size 3296.22 Kbytes (3.22 Mbytes)
Compression xz
Block size 65536
Filesystem is exportable via NFS
Inodes are compressed
Data is compressed
Fragments are compressed
Always-use-fragments option is not specified
Xattrs are compressed
Duplicates are removed
Number of fragments 10
Number of inodes 372
Number of ids 1

> mksquashfs mtd2.new/ mtd2.sqfs -comp xz -b 65536

## pad 00 | FF

dd if=/dev/zero of=/dev/stdout bs=1K count=160 | tr '\0' '\377' > FF

