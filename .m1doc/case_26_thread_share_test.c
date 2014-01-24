/*
 * -------------------------------------------------------------------------
 *       Filename:  case_26_thread_share_test.c
 *    Description:  
 *        Version:  1.0
 *        Created:  Saturday, July 20, 2013 06:54:11 CST
 *       Revision:  none
 *       Compiler:  gcc
 *         Author:  zhangjian (), 
 *   Organization:  
 * -------------------------------------------------------------------------
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

char *g_ptr = NULL;
int *g_pint = NULL;

void *thrd1(char *argv)
{
    int icust = 5;
    g_pint = &icust;

    int i = 0;
    char vec[] = "oh my god";
    g_ptr = vec;

    while (i < 3) {
        sleep (1);
        // printf("Gen %s: %d\n", getpid(), i++);
        printf("Gen %s: %d\n", vec, i++);
    }

    return NULL;
}

void *thrd2(char *argv)
{
    int i = 0;

    sleep (1);

    while (i++ < 5) {
        sleep (1);
        printf("            Custom: %d: %s\n", *g_pint, g_ptr);
    }

    return NULL;
}

int main(int argc, char *argv[])
{
    pthread_t pt[2];
    pthread_attr_t attr;

    pthread_create(&pt[0], NULL, thrd1, "mygod1");
    pthread_create(&pt[1], NULL, thrd2, "mygod2");

    pthread_join(pt[0], NULL);
    pthread_join(pt[1], NULL);
    return 0;
}

/*
 * gcc case_26_thread_share_test.c -g -lrt -lpthread
.root@Moo:~/c/thread# ./a.out
Gen oh my god: 0
            Custom: 5: oh my god
Gen oh my god: 1
            Custom: 5: oh my god
Gen oh my god: 2
            Custom: 3703812: j
            Custom: 3703812: j
            Custom: 3703812: j
*/            
