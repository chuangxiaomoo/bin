# troubleshooting

## 无密登陆失败.1

> mysql -u root mysql
> ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)

参考 [mysql_install](14.本地无密码登陆)

## 无密登陆失败.2 Access denied

按 [mysql_install](14.本地无密码登陆) 操作不会有此问题，此方法只做记录备忘。

```cpp
   # 如 -u root不指定mysql，系统亦默认为mysql 
   # 下面这条命令等同于什么参数也不加的命令： mysql 

    /* 1. start mysqld_safe */
    service mysql stop
    mysqld_safe --user=mysql --skip-grant-tables --skip-networking&
    mysql -u root mysql

    /* 2. 访问表mysql.user，只留一个用户，其它的都删除，防止为空NULL的出现 */
    mysql> DELETE FROM mysql.user WHERE host = '127.0.0.1';
    mysql> update mysql.user set password='' where user='root';
    mysql> SELECT USER, HOST, PASSWORD FROM mysql.user;
    +------+-----------+----------+
    | USER | HOST      | PASSWORD |
    +------+-----------+----------+
    | root | localhost |          |
    +------+-----------+----------+

    FLUSH PRIVILEGES;
    quit

    /* 3. restart */

    // ps -ef  | grep mysqld | awk '{print $2}' | xargs kill -9
    ps -ef  | grep mysqld_safe | awk '{print $2}' | xargs kill -9

    service mysql start

    // 因为密码是空，直接登陆。否则需要 -p passwd
    mysql -u root
```

## mysql table is marked as crashed and last (automatic?) repair failed

  解决办法.

  找到mysql的数据库存放的文件夹,这个可以去mysql的配置文件 my.cnf (linux)
  my.ini(windows)里面找datadir 关键字,后面的就是路径找到对应的数据库文件夹,进
  去后.在该数据库文件夹下执行, <table_name> 是你想要修复的表名,

  $myisamchk -r <table_name>

  如果这样还是不能解决, 停掉mysql,然后

  $myisamchk -r -v -f <table_name>


## 解决MYSQL ibdata1文件的无限增长

  [](http://www.skyarch.cn/blog/linux/mysql-ibdata1/)
  [](http://www.miss77.net/534.html)


  [](http://blog.fens.me/mysql-ibdata1/)

```bash
mysqldump -u root -p --all-database > /opt/others.dump

my.cnf
  [mysqld]
  innodb_file_per_table=1

mysql> show variables like '%per_table%'; 
##删除原来的ibdata1文件及日志文件ib_logfile*，删除data目录下的应用数据库文件夹kts(mysql文件夹不要删)
```

