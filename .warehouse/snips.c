/* 
 * Usage: STRIP后也能打印调用栈
 * $ cc -rdynamic prog.c -o prog
 **/
void print_callstack()
{
    #define SIZE 10
    int j, nptrs;
    void *buffer[SIZE+1];
    char **strings;

    nptrs = backtrace(buffer, SIZE+1);
    strings = backtrace_symbols(buffer, nptrs); // backtrace_symbols_fd()

    if (strings == NULL) {
        perror("backtrace_symbols");
        return;
    }

    printf("%d backtrace() from %s\n", nptrs, strings[1]);

    for (j = 1; j < nptrs; j++) {
        printf("%s\n", strings[j]);
    }

    free(strings);
}
