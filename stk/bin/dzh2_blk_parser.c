/* 
 *       Filename:  dzh2_blk_parser.c
 *    Description:  
 *        Version:  1.0
 *        Created:  Friday, December 20, 2013 11:01:24 CST
 *       Revision:  none
 *       Compiler:  gcc
 *         Author:  chuangxiaomoo (), 
 *   Organization:  
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

/* file */
#include <fcntl.h>
#include <sys/file.h>
#include <sys/types.h>
#include <sys/stat.h>

/* socket() */
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

/* self-header-file */
#include </usr/include/xt_macro.h>

int main(int argc, char *argv[])
{
    char buf[32*1024] = {0};
    char *filepath = "/dzh2/USERDATA/block/融资融券.BLK";

    struct stat filestat;
    if (0 == stat(filepath, &filestat)) {
        // int len = filestat.st_size;
    } else {
        printf("stat err\n"); 
        return 1;
    }

    FILE *fp = fopen(filepath, "r");
    return_val_if_fail(NULL != fp, FAILURE);

    fseek(fp, 4, SEEK_SET);
    int reads = fread(buf, 1, sizeof(buf), fp);
    fclose(fp);
    // printf("rzrq number: %d\n", reads/12);
    /* sz123456 + 0000 */

    int i;
    for (i = 0; i < reads; i+=12) {
        printf("%s\n", buf+i+2);
    }

    return 0;
}
