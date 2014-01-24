/*
 * -------------------------------------------------------------------------
 *       Filename:  test_linux_list.c
 *    Description:  
 *        Version:  1.0
 *        Created:  Monday, July 22, 2013 05:42:01 CST
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

/* socket() */
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include "linux_list.h"


struct jcpinfo {
	struct list_head list;
    char *name;
    int data;
};

int main(int argc, char *argv[])
{
    struct jcpinfo head;
	INIT_LIST_HEAD(&(head.list));

    int i;

    for (i = 0; i < 5; i++) {
        struct jcpinfo *p_jcp = malloc(sizeof(struct jcpinfo));
        p_jcp->data = i;
        list_add(&p_jcp->list, &head.list);                         // test add
    }

    struct jcpinfo *p_node;
	struct list_head *it;
	struct list_head *standby;

    printf("for + entry\n");
    list_for_each(it, &head.list) {                                 // test visit
        p_node = list_entry(it, struct jcpinfo, list);          
        printf("%d\n", p_node->data);
    }

    printf("for_&_entry\n");                                        // test for_each + entry
    list_for_each_entry(p_node, &head.list, list) { printf("%d\n", p_node->data); }

    list_for_each_safe(it, standby, &head.list) {                   // against del 
        p_node = list_entry(it, struct jcpinfo, list);       
        if (2 == p_node->data) {
            list_del(it);                                           // test del
            break;  
        }
    }

    printf("after del 2:\n");

    list_for_each_entry(p_node, &head.list, list) { printf("%d\n", p_node->data); }

    list_for_each_safe(it, standby, &head.list) {             
        p_node = list_entry(it, struct jcpinfo, list);       
        if (3 == p_node->data) {
            struct jcpinfo *p_jcp = malloc(sizeof(struct jcpinfo));
            p_jcp->data = 2;
            list_add(&p_jcp->list, it);                             // test insert
            break;  
        }
    }
    printf("after insert 2:\n");
    list_for_each_entry(p_node, &head.list, list) { printf("%d\n", p_node->data); }

    /* splice */
    struct jcpinfo head2join;
	INIT_LIST_HEAD(&(head2join.list));

    for (i = 5; i < 10; i++) {
        struct jcpinfo *p_jcp = malloc(sizeof(struct jcpinfo));
        p_jcp->data = i;
        list_add(&p_jcp->list, &head2join.list);                    // test add
    }

    list_splice_init(&head2join.list, &head.list);                  // suggest to use
    printf("after splice:\n");
    list_for_each_entry(p_node, &head.list, list) { printf("%d\n", p_node->data); }

    return 0;
}

/*---------------------------------------------------
root@Moo:~/c/S/list# ./test_linux_list
for + entry
4
3
2
1
0
for_&_entry
4
3
2
1
0
after del 2:
4
3
1
0
after insert 2:
4
3
2
1
0
after splice:
9
8
7
6
5
4
3
2
1
0
----------------------------------------------------*/
