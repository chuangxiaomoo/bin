/*
 *       Filename:  mxmlapi.h
 *    Description:  depend on #include <mxml.h>
 *        Version:  1.0
 *        Created:  Tuesday, November 26, 2013 07:39:23 CST
 *       Revision:  none
 *       Compiler:  gcc
 *         Author:  zhangjian (), 
 *   Organization:  
 */

#ifndef _MXMLAPI_H
#define _MXMLAPI_H
#ifdef __cplusplus 
extern "C" {
#endif

#include <syslog.h>

/* macro */
#define XML_HEAD "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"

#ifndef SUCCESS
#   define SUCCESS		0
#   define FAILURE		(-1)
#endif

#ifndef RETVOID
#define RETVOID __void__()
#endif

#define eprintf(fmt, args...) do {                                      \
    syslog(LOG_CRIT, "[%-16s:%5d] " fmt, __func__,__LINE__,## args);    \
    fprintf(stderr,  "[%-16s:%5d] " fmt, __func__,__LINE__,## args);    \
} while(0)

#define pif(args...) syslog(LOG_CRIT, args)

#define return_val_if_fail(condi, ret) do { \
    if (!(condi)) {                         \
        eprintf("fail (" #condi ")\n");     \
        return ret;                         \
    }                                       \
} while (0)

static inline void __void__() {}

/* typedef */

typedef enum {
    NTYPE_UNDEF = 0,
    NTYPE_TREE = 1 << 1,    /* �ӳ�Ա��ΪTEXT��ʹ��"tree" */
    NTYPE_BRO  = 1 << 2,    /* �����ֵܽڵ����д��һ�𣬲��ǵ�һ���ֵܽڵ�ʱʹ�ô˱�� */
    NTYPE_MULT  = 1 << 3,    /* �����ֵܽڵ����д��һ�� */
    NTYPE_INT  = 1 << 6,
    NTYPE_STR  = 1 << 7,
    NTYPE_REAL = 1 << 8,
} ntype_e;


typedef struct {
    char *key;
    char *val;
} nattr_t;

typedef int (*cb_hdlr)(void *);
typedef struct {
    char    *tag;
    ntype_e type;
    void    *value;
    void    *head;          /* ���ֵܽڵ�ʱ��Ϊ�����׵�ַ */
    int     strusize;         /* ���ֵܽڵ�ʱ��Ϊ�ṹ���ƫ�� */
    nattr_t *attr;          /* ���ڽṹ�����󣬿��Ա�Ĭ�ϳ�ʼ��Ϊ0 */
    // int  isset;
    cb_hdlr hdlr;
    void    *arg;
} xmlmap_t;

/* declaration */
int asmbl_xml(mxml_node_t *papa, mxml_node_t *tree, xmlmap_t maps[]);
int parse_xml(mxml_node_t *papa, mxml_node_t *tree, xmlmap_t maps[], void *head);

int xmlmap_2_buf(xmlmap_t maps[], char *buf, int len);

#ifdef __cplusplus
}
#endif
#endif
