1. 列出 20 个 Linux 常用命令

2. 什么是 C 语言的预处理、汇编、编译、链接？

3. 命令 gcc hello.c 可以直接得到可执行文件，要单独得到预处理文件，汇编文件，编译文件，分别使用什么命令选项？

4. 不使用 sscanf 等 C 库函数，完成函数 int atoi(const char *str); 其功能是输入字串参数，返回对应 int 数。

5. 编写测试用例，对 atoi() 进行测试？

6. tar -zxvf a.tgz -C /opt
   上面的命令是典型的 Linux 命令，由一个命令名和多个 {-选项 参数} 组成，现编写解析函数
   1. 入参 cmdline 是命令行，argcp, argcp 就传回的指针。
   2. 参数中间可以带空格

    int cmdline_parse_argv(char *cmdline, int *argcp, char ***argvp) {
    int cmdline_free_argv(int argcp, char **argvp) {


    测试函数

    int exec_jcp_cmdline(char *cmdline) {
    int argc = 0;
    char **argv = NULL;

    if (cmdline_parse_argv(cmdline, &argc, &argv) < 0) {
        printf("Error parsing command line.\n");
        return -1;
    }

    for (int i = 0; i < argc; i++) {
        printf("argv[%d]: %s\n", i, argv[i]);
    }

    return cmdline_free_argv(argc, argv);
    }

    exec_jcp_cmdline("cmd -opt1 -opt2 -opt3 #%$* -opt4 123 4567 -opt5 123 4567 ");

    输出结果如下：
    argv[0]: cmd
    argv[1]: -opt1
    argv[2]: -opt2
    argv[3]: -opt3
    argv[4]: #%$*
    argv[5]: -opt4
    argv[6]: 123 4567
    argv[7]: -opt5
    argv[8]: 123 4567
    
