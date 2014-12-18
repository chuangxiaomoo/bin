/* 
 *       Filename:  min5.c
 *    Description:  
 *        Version:  1.0
 *        Created:  12/17/2014 09:38:40 PM
 *       Revision:  none
 *       Compiler:  gcc
 *         Author:  [8c-19-fc-33](http://blog.sina.com.cn/s/blog_62880f760100hetn.html)
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

// one code at a time               // old data-struct
typedef struct {                    //  typedef struct {
    int flag;                       //      int flag;
    int resv1;                      //      int resv1;
    int num;                        //      int num;
    int resv2;                      //      int resv2;
    int  resv3;                     //  } Head;
    char symble[8];                 //  
    int  resv4;                     //  typedef struct {
    char name[12];                  //      int  resv1;
    int  resv5;                     //      char symble[8];
} Head;                             //      int  resv2;
                                    //      char name[12];
typedef struct {                    //      int  resv3;
    int  date;                      //      int  date;
    float open;                     //      float open;
    float high;                     //      float high;
    float low;                      //      float low;
    float close;                    //      float close;
    float volumn;                   //      float volumn;
    float amount;                   //      float amount;
    char   resv32[36];              //      int  resv4;
} Record;                           //  } Record;


int record24_to_48(Record *p24, Record *p48)
{
    int i;
    for (i = 0; i < 24; i++) {
        // printf("open  %f\n",  p24[i].open);
        // printf("high  %f\n",  p24[i].high);
        // printf("low   %f\n",  p24[i].low);
        // printf("close %f\n",  p24[i].close);
        // printf("volumn %f\n", p24[i].volumn);
        // printf("amount %f\n", p24[i].amount);
        memcpy(&p48[i*2], &p24[i], sizeof(Record));
    }
    return SUCCESS;
}

int routine_outmod(Head *head, Record record48[])
{
    int i;
    float a1, a2, v1, v2;

    a1 = a2 = v1 = v2 = 0;

    for (i = 0; i < 48; i+=2) {
        a1+= record48[i].amount;
        a2+= record48[i+1].amount;
        v1+= record48[i].volumn;
        v2+= record48[i+1].volumn;
    }

    char date[32];
    strftime(date, sizeof(date), "%F", gmtime((time_t *)&record48[0].date));
    printf("%s %s %.0f %.0f %.0f %.0f\n", head->symble+2, date, a1, a2, v1, v2);
    // 5796.25 * 10000 -- 579625000
    return SUCCESS;
}

int main(int argc, char *argv[])
{
    int ret;
    int len;
    Head head = {0};
    struct stat filestat;
    Record record24[24];
    Record record48[48];

    int outmode = TRUE;
    if (argc != 1) {
        outmode = FALSE;
    }

    if (0 == stat("full.PWR", &filestat)) {
        len = filestat.st_size;
    } else {
        printf("stat err\n"); 
        return 1;
    }

    FILE *fp = fopen("/dzh2/SUPERSTK.DAD", "r");
  //FILE *fp = fopen("SUPERSTK1.DAD", "r");
    return_val_if_fail(NULL != fp, FAILURE);

    fseek(fp, 0L, SEEK_SET);
    ret = fread(&head, 1, sizeof(Head), fp); 
    printf("read %d\n", ret);
    printf("numb %u\n", head.num);

    int i;
    float v = 0; 
    float a = 0;
    float v1 = 0; 
    float a1 = 0;

    while (1) {
        ret = fread(&record24, 1, sizeof(record24), fp); 
        if (ret < sizeof(record24)) {
            printf("end of file\n");
            return SUCCESS;
        }
        record24_to_48(record24, record48);

        for (i = 1; i < 48-1; i+=2) {
            record48[i].close =  (record48[i-1].close + record48[i+1].close  )/2;
            record48[i].volumn = (record48[i-1].volumn + record48[i+1].volumn)/2;
            record48[i].amount = (record48[i-1].amount + record48[i+1].amount)/2;
            record48[i].date = record48[i-1].date + 300;
        }
        memcpy(&record48[i], &record48[i-1], sizeof(Record));
        record48[i].date += 300;

        if (outmode) {
            routine_outmod(&head, record48);
        }
    }
#ifdef inmod 
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
    printf("yes %d a : %f v %f \n", i, a, v);
#endif
    return 0;
}
// /dzh2/cfg/system/simpleconfig/Market.xml
// /dzh2/data/CB/Raw/MK_VT.txt
