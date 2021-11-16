# 手册 LEB PEB max_leb_cnt

```bash
# mkfs.ubifs 参数：
  -F：file-system free space has to be fixed up on first mount
  -q：未知
  -r：build file system from directory DIR
  -m：最小输入输出大小为2KiB(2048bytes)，一般为页大小
  -e：逻辑可擦除块(LEB)大小为124KiB=(每块的页数-2)*页大小=（64-2）*2KiB=124KiB=126976bytes
  -c：最多逻辑可擦除块数目(max_leb_cnt)， 这个值是通过 ubinize.cfg 里面的 vol_size=200MiB算出来的， 200M * 1024 / 128K 算出来的。

# ubinize 参数
  -o：输出文件名
  -m: 最小输入输出大小为2KiB(2048bytes)，一般为页大小 
  -p: 物理可擦出块大小(PEB)为128KiB=每块的页数*页大小=64*2KiB=128KiB 
  -s: 用于UBI头部信息的最小输入输出单元，一般与最小输入输出单元(-m参数)大小一样。

# ubinize config
  vol_size=LEB*max_leb_cnt
```

# 案例: 8M 的 rootfs

```bash
# 8M 只有 5M 能用
# 6944 = 124 * 40 = 124 * 8 * 5
rm -rf ${dir_filesys}/system/*
mkfs.ubifs -e 124KiB -c 40 -m 2048 -d ${dir_filesys} -o ${dir_com}/root.ubifs -v >&$errlog
xt_ret $? "`cat $errlog`" || return $?
sleep 1
cat <<-HERE > ${dir_com}/root.cfg
[ubifs]
mode=ubi
image=${dir_com}/root.ubifs
vol_id=0
vol_size=4960KiB
vol_type=static
vol_name=rootfs
vol_alignment=1
HERE
ubinize -o ${dir_com}/rootfs.img -m 2048 -p 128KiB -s 2048 ${dir_com}/root.cfg -v >&$errlog
xt_ret $? "`cat $errlog`" || return $?
```

# Warning 

明明是留了 1M = 8 PEB, 但日志里却只有 reserved 4

```txt
[    1.715411] ubi0: attaching mtd4
[    1.729040] ubi0: scanning is finished
[    1.736905] ubi0 warning: print_rsvd_warning: cannot reserve enough PEBs for bad PEB handling, reserved 4, need 20
[    1.750233] ubi0: attached mtd4 (name "sf-rootfs", size 8 MiB)
[    1.756259] ubi0: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
[    1.763412] ubi0: min./max. I/O unit sizes: 2048/2048, sub-page size 2048
[    1.770459] ubi0: VID header offset: 2048 (aligned 2048), data offset: 4096
[    1.777646] ubi0: good PEBs: 64, bad PEBs: 0, corrupted PEBs: 0
[    1.783789] ubi0: user volume: 1, internal volumes: 1, max. volumes count: 128
[    1.791310] ubi0: max/mean erase counter: 0/0, WL threshold: 4096, image sequence number: 1767051530
[    1.800773] ubi0: available PEBs: 0, total reserved PEBs: 64, PEBs reserved for bad PEB handling: 4
[    1.810145] ubi0: background thread "ubi_bgt0d" started, PID 584
[    1.816373] ubi1: attaching mtd5
[    1.903987] ubi1: scanning is finished
[    1.911791] ubi1 warning: print_rsvd_warning: cannot reserve enough PEBs for bad PEB handling, reserved 8, need 20
[    1.930171] ubi1: attached mtd5 (name "sf-fontfs", size 12 MiB)
[    1.936289] ubi1: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
[    1.943433] ubi1: min./max. I/O unit sizes: 2048/2048, sub-page size 2048
[    1.950477] ubi1: VID header offset: 2048 (aligned 2048), data offset: 4096
[    1.957668] ubi1: good PEBs: 96, bad PEBs: 0, corrupted PEBs: 0
[    1.963819] ubi1: user volume: 1, internal volumes: 1, max. volumes count: 128
[    1.971315] ubi1: max/mean erase counter: 0/0, WL threshold: 4096, image sequence number: 1651905116
[    1.980783] ubi1: available PEBs: 0, total reserved PEBs: 96, PEBs reserved for bad PEB handling: 8
[    1.990161] ubi1: background thread "ubi_bgt1d" started, PID 589
```

# 修改：

PEB = 128KiB
20 PEB = 2.5MiB, 这是需要的最小 for bad PEB, 实际则是需要 3M 
如果是 8MiB, 则 5/8 是所需。

＜ 16M 使用 3M，
>= 16M 使用 4M
