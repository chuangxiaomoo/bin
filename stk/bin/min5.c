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
    float volume;                   //      float volume;
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
        // printf("volume %f\n", p24[i].volume);
        // printf("amount %f\n", p24[i].amount);
        memcpy(&p48[i*2], &p24[i], sizeof(Record));
    }
    return SUCCESS;
}

int routine_daymod(Head *head, Record record48[])
{
    int i;
    float a1, a2, v1, v2;

    a1 = a2 = v1 = v2 = 0;

    for (i = 0; i < 48; i+=2) {
        a1+= record48[i].amount;
        a2+= record48[i+1].amount;
        v1+= record48[i].volume;
        v2+= record48[i+1].volume;
    }

    char date[32];
    strftime(date, sizeof(date), "%F", gmtime((time_t *)&record48[0].date));

    static int count = 0;
    printf("%d\t%s\t%s\t%.2f\t%.2f\t%.4f\t%.4f\n", count++, head->symble+2, date, 
            v1/100, v2/100, a1/10000, a2/10000);
    // 5796.25 * 10000 -- 579625000
    return SUCCESS;
}

int routine_primod(Head *head, Record record48[])
{
    int i;
    float a = 0, v = 0;
    for (i = 0; i < 48; i++) {
        char date[32];
        strftime(date, sizeof(date), "%F", gmtime((time_t *)&record48[i].date));
        char time[32];
        strftime(time, sizeof(time), "%T", gmtime((time_t *)&record48[i].date));
        printf("%s\t%s\t%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n", head->symble+2, date, time, 
            record48[i].open,
            record48[i].high,
            record48[i].low,
            record48[i].close,
            record48[i].volume/100,
            record48[i].amount/10000
        );
        v += record48[i].volume;
        a += record48[i].amount;
    }
    printf("v: %.2f a:%.2f\n", v/100, a/10000);
    // 5796.25 * 10000 -- 579625000
    return SUCCESS;
}

int main(int argc, char *argv[])
{
    int ret;
    Head head = {0};
    Record record24[24];
    Record record48[48];

    int daymode = FALSE;
    if (argc == 1) {
        daymode = TRUE;
    } else {
        if (0 == strncmp(argv[1], "h", 1) || argc != 4) {
            printf("Usage: %s [{help | index kv ka}]\n", argv[0]);
            exit(0);
        }
    }

    FILE *fp = fopen("/dzh2/SUPERSTK.DAD", "r");
  //FILE *fp = fopen("SUPERSTK1.DAD", "r");
    return_val_if_fail(NULL != fp, FAILURE);

    fseek(fp, 0L, SEEK_SET);
    ret = fread(&head, 1, sizeof(Head), fp); 
    fprintf(stderr, "head %d bytes\n", ret);
    fprintf(stderr, "numb %d codes\n", head.num);

    int i;
    float v = 0; 
    float a = 0;
    float v1 = 0; 
    float a1 = 0;

    float kv, ka;
    if (daymode) {
        kv = ka = 1;
    } else {
        kv = atof(argv[2]);
        ka = atof(argv[3]);
    }

    int got_data = FALSE;

    while (1) {
        if (!daymode) {
            fprintf(stderr, "to read %dth record\n", atoi(argv[1]));
            fseek(fp, sizeof(record24)*atoi(argv[1]), SEEK_CUR);
        }
        ret = fread(&record24, 1, sizeof(record24), fp); 
        if (ret < sizeof(record24)) {
            if (got_data == FALSE) {
                fprintf(stderr, "got no data\n");
                return FAILURE;
            }
            fprintf(stderr, "end of file\n");
            return SUCCESS;
        }
        got_data = TRUE;
        record24_to_48(record24, record48);

        for (i = 1; i < 48-1; i+=2) {
            record48[i].open = record48[i].high = record48[i].low = 
            record48[i].close  =      (record48[i-1].close + record48[i+1].close  )/2;
            record48[i].volume = kv * (record48[i-1].volume + record48[i+1].volume)/2;
            record48[i].amount = ka * (record48[i-1].amount + record48[i+1].amount)/2;
            record48[i].date = record48[i-1].date + 300;
        }
        record48[i].open = record48[i].high = record48[i].low = 
        record48[i].close  = record48[i-1].close;
        record48[i].volume = kv * record48[i-1].volume;
        record48[i].amount = ka * record48[i-1].amount;
        record48[i].date = record48[i-1].date + 300;

        if (daymode) {
            routine_daymod(&head, record48);
        } else {
            return routine_primod(&head, record48);
        }
    }

    fclose(fp);
    return 0;
}
// /dzh2/cfg/system/simpleconfig/Market.xml
// /dzh2/data/CB/Raw/MK_VT.txt
