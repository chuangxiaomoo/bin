# troubleshooting

# mysql table is marked as crashed and last (automatic?) repair failed

  解决办法.

  找到mysql的数据库存放的文件夹,这个可以去mysql的配置文件 my.cnf (linux)  
  my.ini(windows)里面找datadir 关键字,后面的就是路径找到对应的数据库文件夹,进
  去后.在该数据库文件夹下执行, <table_name> 是你想要修复的表名,

  #myisamchk -r <table_name>

  如果这样还是不能解决, 停掉mysql,然后

  #myisamchk -r -v -f <table_name>


# 解决MYSQL ibdata1文件的无限增长

  [](http://www.skyarch.cn/blog/linux/mysql-ibdata1/)
  [](http://www.miss77.net/534.html)


  [](http://blog.fens.me/mysql-ibdata1/)

# steps

mysqldump -u root -p --all-database > /opt/others.dump

my.cnf
  [mysqld]
  innodb_file_per_table=1

mysql> show variables like '%per_table%'; 

删除原来的ibdata1文件及日志文件ib_logfile*，删除data目录下的应用数据库文件夹kts(mysql文件夹不要删)

