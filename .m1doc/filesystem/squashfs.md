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

