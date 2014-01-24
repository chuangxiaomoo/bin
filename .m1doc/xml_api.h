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

/* macro */
#define XML_HEAD "<?xml version=\"1.0\" encoding=\"GB2312-80\"?>"

/* typedef */

typedef enum {
    NTYPE_UNDEF = 0,
    NTYPE_TREE = 1 << 1,    /* 子成员不为TEXT，使用"tree" */
    NTYPE_BRO  = 1 << 2,    /* 所有兄弟节点必须写在一起，不是第一个兄弟节点时使用此标记 */
    NTYPE_INT  = 1 << 6,
    NTYPE_STR  = 1 << 7,
    NTYPE_REAL = 1 << 8,
} ntype_e;

typedef struct {
    char    *tag;
    ntype_e type;
    void    *value;
    // int  isset;
} xmlmap_t;

/* declaration */
int asmbl_xml(mxml_node_t *papa, mxml_node_t *tree, xmlmap_t maps[]);
int parse_xml(mxml_node_t *papa, mxml_node_t *tree, xmlmap_t maps[]);

#ifdef __cplusplus
}
#endif
#endif
