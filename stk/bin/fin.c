/* 
 *       Filename:  fin.c
 *    Description:  
 *        Version:  1.0
 *        Created:  06/04/2014 09:19:10 PM
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
#include <sys/stat.h>

/* socket() */
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>

/* self-header-file */
#include </usr/include/xt_macro.h>

typedef struct finance {
    char sym[12];
    int  date[3];
    float field[48];
} Finance;

int main(int argc, char *argv[])
{
    int len;
    int offset = 8;
    Finance fin;

    struct stat filestat;
    if (0 == stat("full.FIN", &filestat)) {
        len = filestat.st_size;
    } else {
        printf("stat err\n"); 
        return 1;
    }

    FILE *fp = fopen("full.FIN", "r");
    return_val_if_fail(NULL != fp, FAILURE);

    fseek(fp, 8, SEEK_SET);

    // int ret = fread(&fin, sizeof(Finance), 1, fp);
    // printf("%d is ret\n", ret);

    while (1 == fread(&fin, sizeof(Finance), 1, fp)) {
        offset += sizeof(Finance);
        if (offset > len) {
            printf("offset %d of %d\n", offset, len);
            break;
        }
        int code = atoi(fin.sym+2);
#if 1
        if (code == 300001) {
            printf("%s\n", fin.sym);
            int i;
            for (i = 0; i < 3; i++) {
                printf("%d\n", fin.date[i]);
            }
            for (i = 0; i < 48; i++) {
                printf("%f\n", fin.field[i]);
            }
            break;
        }
#endif

        if ( fin.sym[2] == '5'  || 
             fin.sym[2] == '4'  ||
             fin.sym[2] == '2'  ||
             fin.sym[2] == '1'  ||
             fin.sym[2] >  '6'  ||
            (fin.sym[1] == 'H' && fin.sym[2] == '0') ||     // SH0xxxxx
            (code>399000 && code <400000) ||
            fin.field[34] < 1
            ) {
            continue;
        }

        // printf("%06d\t%f\n", code, fin.field[34]);
        // printf("%s\t%f\n", fin.sym+2, fin.field[34]);
        printf("UPDATE cap SET shares = %.2f WHERE code = %s;\n", fin.field[34], fin.sym+2);
    }

    fclose(fp);
    return 0;
}

