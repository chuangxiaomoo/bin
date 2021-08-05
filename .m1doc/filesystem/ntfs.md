# Linux 上使用 NTFS

[](https://www.tuxera.com/community/open-source-ntfs-3g/)
[ntfs-3g](https://samlin35.blogspot.com/2009/07/linux-ntfs.html)

July 14th, 2009 by Chuan-Hsien Lin Last Modified on July 14th, 2009

先來說說我的環境，我是使用一塊 ARM 相容的開發板，Linux Kernel 採用 2.6.22.18。

可以看的出來，硬碟中有個 NTFS 的 Partition。

    -sh-3.2# fdisk -l
    Disk /dev/sda: 82.3 GB, 82348277760 bytes
    255 heads, 63 sectors/track, 10011 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot  Start  End  Blocks  Id System
    /dev/sda1    1      123  987966  7  HPFS/NTFS

尚未在 Linux Kernel 勾選支援 NTFS，直接去掛載 NTFS Partition 會出現問題。

    -sh-3.2# mount -t ntfs /dev/sda1 /mnt/hd1
    mount: mounting /dev/sda1 on /mnt/hd1 failed: No such device

由於 Linux Kernel 本身就可支援 NTFS 了，所以我們 make menuconfig 來設定支援 NTFS，

    <*> NTFS file system support
    [*] NTFS write support

再來執行一次 mount，成功的掛載了，

    -sh-3.2# mount -t ntfs /dev/sda1 /mnt/hd1
    NTFS volume version 3.1.

    -sh-3.2# mount
    rootfs on / type rootfs (rw)
    /dev/root on / type nfs (rw,vers=2,rsize=4096,wsize=4096,hard,nolock,proto=udp,timeo=11,retrans=2,sec=sys,addr=192.168.51.15)
    proc on /proc type proc (rw)
    devpts on /dev/pts type devpts (rw)
    /dev/sda1 on /mnt/hd1 type ntfs (rw,uid=0,gid=0,fmask=0177,dmask=077,nls=iso8859-1,errors=continue,mft_zone_multiplier=1)

雖然掛載後，但卻是只能讀不能寫入，

    -sh-3.2# touch /mnt/hd1/testfile
    touch: /mnt/hd1/testfile: Permission denied

如果想要可以讀寫 NTFS，得使用別的方式，目前比較流行的是使用 ntfs-3g 這個套件。

安裝好 ntfs-3g 去執行的話，會發現少了 fuse 套件，

    -sh-3.2# ./ntfs-3g /dev/sda1 /mnt/hd1
    modprobe: cannot parse modules.dep
    ntfs-3g-mount: fuse device is missing, try 'modprobe fuse' as root

由於後來的 Linux Kernel 裡面都內建了 FUSE 了，所以在 make menuconfig 時指定，

    <*> Filesystem in Userspace support

然後重新編譯 Linux Kernel 後，進到 target board 後再來 mount 一次就可成功了，

    ./ntfs-3g /dev/sda1 /mnt/hd1

如果要可以格式化 NTFS 的 partition 的話，得再裝另一個套件 nefsprogs， 這套件裡有蠻多針對 NTFS 運作相關的程式，像我就會使用產生出來的 mkntfs 去格式化 NTFS，用 ntfslabel 去寫 label。

# 相關資源：

ntfs-3g
http://www.ntfs-3g.org/

nefsprogs
http://www.linux-ntfs.org/

NTFS FAQ (中文)
http://www.linux-ntfs.org/doku.php?id=ntfs-zh_tw

