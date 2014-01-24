/*
 *       Filename:  mxmlapi.c
 *    Description:  
 *        Version:  1.0
 *        Created:  Tuesday, November 26, 2013 07:39:23 CST
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

/* self-header-file */
#include </usr/include/xt_macro.h>

#include <mxml.h>
#include "mxmlapi.h"

static const char* xml_format_write(mxml_node_t *node, int val)
{
	static char strBuf[128];
	const char *str = (const char *)strBuf;
	mxml_node_t *pNode = node;
	int depth = 0;
	int has_elem_child = 0;

	memset(strBuf, 0, sizeof(strBuf));
	while(pNode != NULL)
	{
		pNode = pNode->parent;
		depth ++;
	}
	if(depth >= 2) depth = depth - 2;
	else depth = 0;
	
	if(val == MXML_WS_BEFORE_OPEN)
	{
		memset(strBuf, ' ', depth * 2);
	}
	else if(val == MXML_WS_AFTER_OPEN)
	{
		pNode = node->child;
		while(pNode != NULL)
		{
			if(pNode->type == MXML_ELEMENT)
			{
				has_elem_child = 1;
				break;
			}
			pNode = pNode->next;
		}

		if(has_elem_child)
			strBuf[0] = '\n';
	}
	else if(val == MXML_WS_BEFORE_CLOSE)
	{
		pNode = node->child;
		while(pNode != NULL)
		{
			if(pNode->type == MXML_ELEMENT)
			{
				has_elem_child = 1;
				break;
			}
			pNode = pNode->next;
		}

		if(has_elem_child)
			memset(strBuf, ' ', depth * 2);
	}
	else if(val == MXML_WS_AFTER_CLOSE)
	{
		strBuf[0] = '\n'; 
	}

	return str;
}

static char *trimsps(char *src)
{
    int     i = 0;
    char   *begin = src;

    while (src[i] != '\0') {
        if (src[i] != ' ' && src[i] != '\r' && src[i] != '\n' && src[i] != '\t') {
            break;
        } else {
            begin++;
        }
        i++;
    }
    for (i = strlen(begin) - 1; i > src-begin; i--) {
        if (begin[i] == ' ' || begin[i] == '\r' || 
            begin[i] == '\n' || begin[i] == '\t') {
            begin[i] = '\0';
        } else {
            break;
        }
    }
    return begin;
}

void shownode(mxml_node_t *node, int is_opaque)
{
    return_val_if_fail(node != NULL, RETVOID);

    char *name = node->value.element.name; 
    mxml_node_t *child = node->child;

    if (!child) {
        printf("No TEXT of node[%s]\n", name);
        return;
    }

#define SHOW_VAL_ONLY
#ifdef SHOW_VAL_ONLY
    if (is_opaque) {
        printf("tag:%s <%s>\n", name, trimsps(child->value.opaque)); return;
    }
#endif

    printf("node[%s]: %p, next: %p, prev: %p, par: %p \n", 
               name, node, node->next, node->prev, node->parent);

    int i=0;

    for (; child; child = child->next, i++) {
        if (is_opaque) {
            printf("child[%d] %p: <%s>", i, child, child->value.opaque);
        } else {
            printf("child[%d] %p: <%s>", i, child, child->value.text.string);
        }
        printf(" type: %d\n", child->type);
    }
}

static int load_file2buf(char *file, char *buf, int len)
{
    FILE *fp;
    int nread;

    fp = fopen(file, "r");
    return_val_if_fail(fp != NULL, FAILURE);

    nread = fread(buf, 1, len, fp);
    fclose(fp);

    return_val_if_fail(nread > 0, (printf("nread: %d\n", nread), FAILURE));

    return SUCCESS;
}

// assemble value in map[i].val as XML-format into buf 
int asmbl_xml(mxml_node_t *papa, mxml_node_t *tree, xmlmap_t maps[])
{
    int i = 0;
    xmlmap_t *map = maps;
    mxml_node_t *node;

    for (; map->tag; i++,map++) {
        node = mxmlNewElement(papa, map->tag);

        if (map->type & NTYPE_TREE) {
            asmbl_xml(node, papa, (xmlmap_t *)map->value);
            continue;
        }

        if (map->type & NTYPE_INT) {
            mxmlNewTextf(node, 0, "%d", *(int *)map->value);
        } else if (map->type & NTYPE_STR) {
            mxmlNewTextf(node, 0, "%s", (char *)map->value);
        } else if (map->type & NTYPE_REAL) {
            mxmlNewTextf(node, 0, "%f", *(float *)map->value);
        } 
    }
    return 0;
}

int parse_xml(mxml_node_t *papa, mxml_node_t *tree, xmlmap_t maps[])
{
    int i = 0;
    char *opaque;
    xmlmap_t *map = maps;
    mxml_node_t *node;

    for (; map->tag; i++,map++) {
        if (map->type & NTYPE_BRO) {
            node = mxmlFindElement(node, tree, map->tag, NULL, NULL, MXML_NO_DESCEND);
        } else {
            node = mxmlFindElement(papa, tree, map->tag, NULL, NULL, MXML_DESCEND_FIRST);
        }

        if ((!node) || (!node->child)) {
            continue;
        }

        // printf("tag: %s  ", map->tag);
        // int is_opaque = 1;
        // shownode(node, is_opaque);

        if (map->type & NTYPE_TREE) {
            parse_xml(node, papa, (xmlmap_t *)map->value);
            continue;
        }

        opaque = trimsps(node->child->value.opaque);
        
        if (opaque[0] == '\0') { 
            /* int or float type (map->value) will not change, give a warning here */
        }

        if (NULL == map->value) {
            continue;
        }

        if (map->type & NTYPE_INT) {
            sscanf(opaque, "%d", (int *)map->value);
        } else if (map->type & NTYPE_STR) {
            strcpy((char *)map->value, opaque);
        } else if (map->type & NTYPE_REAL) {
            sscanf(opaque, "%f", (float *)map->value);
        } 
    }

    return 0;
}

static int test_parse()
{
    /* xml文件须以空行结尾，否则在保存时有告警 */
    int ret;
    char buf[2048];
    char *filename = "test.xml";

    char node[8][32] = {{0}};
    int inode;
    float fnode;

    xmlmap_t map_lv30[] = {
        {"node" , NTYPE_STR          , node[1]},
        {"node" , NTYPE_STR|NTYPE_BRO, node[2]},
        {0      ,                            },
    };

    xmlmap_t map_lv31[] = {
        {"node" , NTYPE_STR          , node[3]},
        {"node" , NTYPE_STR|NTYPE_BRO, node[4]},
        {0      ,                            },
    };

    xmlmap_t map_lv2[] = {
        {"node"  , NTYPE_STR           , node[0] },
        {"node"  , NTYPE_REAL|NTYPE_BRO, &fnode  },
        {"node"  , NTYPE_INT|NTYPE_BRO , &inode  },
        {"group" , NTYPE_TREE          , map_lv30},
        {"group" , NTYPE_TREE|NTYPE_BRO, map_lv31},
        {"opnode", NTYPE_STR           , node[5] },
        {0       ,                               },
    };

    xmlmap_t maps[] = {
        {"data", NTYPE_TREE, map_lv2},
        {0     ,                    },
    };

    ret = load_file2buf(filename, buf, sizeof(buf));
    return_val_if_fail(ret == SUCCESS, FAILURE);

    mxml_node_t *tree = mxmlLoadString(NULL, buf, MXML_OPAQUE_CALLBACK);   
    parse_xml(tree, tree, maps);

    int i;
    for (i = 0; i < 6; i++) {
        printf("[%d] %s\n", i, node[i]);
    }

    printf("inode %d\n", inode);
    printf("fnode %f\n", fnode);

    return 0;
}

static int test_asmbl()
{
    int dig = 100;
    float real = 15.123;

    xmlmap_t map_lv20[] = {
        {"node", NTYPE_STR , "vaL4"},
        {"node", NTYPE_STR , "vaL5"},
        {0     ,                   },
    };
    xmlmap_t map_lv21[] = {
        {"node", NTYPE_STR , "vaL6"},
        {"node", NTYPE_STR , "vaL7"},
        {0     ,                   },
    };

    xmlmap_t map_lv1[] = {
        {"node"  , NTYPE_STR , "vaL1"      },
        {"node"  , NTYPE_REAL, &real       },
        {"node"  , NTYPE_INT , &dig        },
        {"group" , NTYPE_TREE, map_lv20    },
        {"group" , NTYPE_TREE, map_lv21    },
        {"opnode", NTYPE_STR , "vaL9 vaL10"},
        {0       ,                         },
    };

    xmlmap_t maps[] = {
        {"data", NTYPE_TREE, map_lv1},
        {0      ,                    },
    };

    mxml_node_t *tree = mxmlLoadString(NULL, XML_HEAD, MXML_NO_CALLBACK);   
    asmbl_xml(tree, tree, maps);
    
    char *ptr = mxmlSaveAllocString(tree, xml_format_write);
    printf("%s\n", ptr);

    FILE * fp = fopen("test.xml", "w");
    mxmlSaveFile(tree, fp, xml_format_write);
    fclose(fp);

    return 0;
}

#define __TEST_MXML_API__
#ifdef __TEST_MXML_API__
int main(int argc, char *argv[])
{
    /* 自己写的xml文件须以空行结尾，否则在保存时有告警 */
    test_asmbl();
    test_parse();
    return 0;
}
#endif

