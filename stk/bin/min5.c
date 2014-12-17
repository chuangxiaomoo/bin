/* 
 *       Filename:  min5.c
 *    Description:  
 *        Version:  1.0
 *        Created:  12/17/2014 09:38:40 PM
 *       Revision:  none
 *       Compiler:  gcc
 *         Author:  zhangjian (), 
 *   Organization:  
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

/* file */
#include <fcntl.h>
#include <sys/file.h>

/* socket() */
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include </usr/include/xt_macro.h>
#include <time.h>
#include <sys/stat.h>

struct head {
    int flag;
    int resv1;
    int num;
    int resv2;
} head_t;

struct record {
    int  resv1;
    char symble[8];
    int  resv2;
    char name[12];
    int  resv3;
    int  date;
    float open;
    float high;
    float low;
    float close;
    float volumn;
    float amount;
    int  resv4;
};

int main(int argc, char *argv[])
{
    int ret;
    int len;
    // int offset = 0;
    struct head head;
    struct stat filestat;
    struct record record;

    if (0 == stat("full.PWR", &filestat)) {
        len = filestat.st_size;
    } else {
        printf("stat err\n"); 
        return 1;
    }

    FILE *fp = fopen("/dzh2/SUPERSTK.DAD", "r");
    return_val_if_fail(NULL != fp, FAILURE);

    fseek(fp, 0L, SEEK_SET);
    ret = fread(&head, 1, sizeof(struct head), fp); 
    printf("read %d\n", ret);
    printf("%u\n", head.num);

    int i;
    float v = 0; 
    float a = 0;
    float v1 = 0; 
    float a1 = 0;

      for (i = 0; ; i++) {
        memset(&record, 0, sizeof(record));
        ret = fread(&record, 1, sizeof(struct record), fp); 

        printf("read %d\n", ret);
        if (ret < sizeof(struct record)) {
             break;
        }
        // printf("symble %s\n", record.symble);
        char date[32];
        ret = strftime(date, sizeof(date), "%F %T", gmtime((time_t *)&record.date));
        printf("dats %d\n", record.date);
        printf("date %s\n", date);
        printf("open  %f\n", record.open);
        printf("high  %f\n", record.high);
        printf("low   %f\n", record.low);
        printf("close %f\n", record.close);
        printf("volumn %f\n", record.volumn);
        printf("amount %f\n", record.amount);

        if (a != 0) {
            a1 = (a1 + record.amount)/2;
            v1 = (v1 + record.volumn)/2;
        }

        a+= a1 + record.amount;
        v+= v1 + record.volumn;

        a1 = record.amount;
        v1 = record.volumn;
      }

    // int i;
    // unsigned char *p = (void *)&head;
    // for (i = 0; i < 16; i++) {
    //     printf("%X\n", p[i]);
    // }
    printf("yes %d a : %f v %f \n", i, a, v);
    return 0;
}
