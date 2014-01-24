/* 
 *       Filename:  dzh.c
 *    Description:  
 *        Version:  1.0
 *        Created:  Saturday, November 30, 2013 11:21:49 CST
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

#include <time.h>

typedef struct record {
    int  secs;
    float song_ratio;
    float pei_ratio;
    float pei_price;
    float div_ratio;
    int   end_flag;
} Reco;

typedef struct bonouce {
    char sym[8];
    char reserv[8];
    Reco reco;
} Bonouce;

int main(int argc, char *argv[])
{
    int ret;
    int len;
    int offset = 0;
    char date[12];
    Bonouce bono;
    Reco reco;
    Reco latest;

    struct stat filestat;
    if (0 == stat("full.PWR", &filestat)) {
        len = filestat.st_size;
    } else {
        printf("stat err\n"); 
        return 1;
    }

    FILE *fp = fopen("full.PWR", "r");
    return_val_if_fail(NULL != fp, FAILURE);

    fseek(fp, 12, SEEK_SET);
    
    while (1 == fread(&bono, sizeof(Bonouce), 1, fp)) {
        offset += sizeof(Bonouce);
        if (offset > len) {
            printf("offset %d of %d\n", offset, len);
            break;
        }

        // printf("%s, off %d\n", bono.sym, offset);

        memcpy(&reco,   &bono.reco, sizeof(Reco));
        memcpy(&latest, &reco, sizeof(Reco));

        do {
            if (reco.end_flag == -1) {
                break;
            }

            fseek(fp, -4, SEEK_CUR);
            offset -= 4;

            fread(&reco, sizeof(Reco), 1, fp);
            offset += sizeof(Reco);
            if (offset > len) {
                // printf("offset %d of %d\n", offset, len);
                break;
            }
            if (reco.secs > latest.secs) {
                memcpy(&latest, &reco, sizeof(Reco));
            }
        } while (1);

        /* start with 9 不是A股个股 */
        if (bono.sym[2] == '9') continue;

        ret = strftime(date, sizeof(date), "%F", gmtime((time_t *)&latest.secs));
        return_val_if_fail(ret == 10, FAILURE);

        printf("%s\t%s\t%f\t%f\t%f\t%f\n", 
                bono.sym+2, date, 
                latest.song_ratio, 
                latest.pei_ratio, 
                latest.pei_price, 
                latest.div_ratio
        );
    }

    fclose(fp);
    return 0;
}

