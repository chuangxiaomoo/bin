/* 
 *       Filename:  xml_shuttle.c
 *    Description:  
 *        Version:  1.0
 *        Created:  08/20/2014 05:01:46 PM
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

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

char *trimsps(char *src)
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

static int pritnt_usage(char *argv[], int line)
{
    const char *usage_msg = 
    "\nUsage: %s -c CMD {-f FILE | [-n NUM] -k KEY [-v VALUE]} XML-FILE"
    "\n\t"
    "\n\toptions:"
    "\n\t-h, --help             show help"
    "\n\t-i, --inner            writeback to XML-FILE instead of STDOUT"
    "\n\t-f, --file             num-key-value pair records"
    "\n\t-c, --cmd {a|d|w|r}    add del write read"
    "\n\t-n, --num <num>        channel number"
    "\n\t-k, --key <key>        node tag of xml"
    "\n\t-v, --val <val>        node value"
    "\n\t_Error_@%d"
    "\n";

    fprintf(stderr, usage_msg, argv[0], line);
    (line == 0) ?  exit(0) : exit(1);
}


enum optflag {
    FLAG_CMD  = 1,
    FLAG_KEY  = 1 << 1,
    FLAG_VAL  = 1 << 2,
    FLAG_NUM  = 1 << 3,
    FLAG_FILE = 1 << 9,
    FLAG_INNER = 1 << 10 
};

mxml_node_t *xpath_find(mxml_node_t *tree,  const char *xpath, int chn)
{
    const char *delim = "/";
    char *str, *saveptr, *token = NULL; 
    int j, level;
    char haystack[256];
    mxml_node_t *node = tree;

    snprintf(haystack, sizeof(haystack), "%s", xpath);
    for (level = 0, str = haystack; ; level++, str = NULL) {
        token = strtok_r(str, delim, &saveptr);
        if (token == NULL) {
            break;
        }
    }

    // printf("level is %d\n", level);
    snprintf(haystack, sizeof(haystack), "%s", xpath);

    for (j = 1, str = haystack; ; j++, str = NULL) {
        token = strtok_r(str, delim, &saveptr);
        if (token == NULL) {
            break;
        }

        char *attr_name = NULL;
        char *attr_value = NULL;

        // level node find
        if (chn != 0 && j == (level-1)) {
            attr_name = (char *)"chn";
            char temp[8] = {0};
            snprintf(temp, sizeof(temp), "%d", chn);
            attr_value = temp;
        }

        node = mxmlFindElement(node, tree, token, attr_name, attr_value, MXML_DESCEND_FIRST); 

        // printf("chn[%d] mygod %d\n", chn,  j);
        if (node == NULL) {
            break;
        }

        // printf("%d: %s\n", j, token);
    }

    // for precise, (j == 3) is needed
    if (NULL == token && NULL != node) {
        return node;
    } else {
        return NULL;
    }
}

mxml_node_t *xpath_create(mxml_node_t *tree,  const char *xpath, int num)
{
    const char *delim = "/";
    char *str, *saveptr, *token = NULL; 
    int j, level;
    char haystack[256];
    mxml_node_t *papa = tree;
    mxml_node_t *node = NULL;

    snprintf(haystack, sizeof(haystack), "%s", xpath);
    for (level = 0, str = haystack; ; level++, str = NULL) {
        token = strtok_r(str, delim, &saveptr);
        if (token == NULL) {
            break;
        }
    }

    // printf("level is %d\n", level);

    snprintf(haystack, sizeof(haystack), "%s", xpath);

    for (j = 1, str = haystack; ; j++, str = NULL) {
        token = strtok_r(str, delim, &saveptr);
        if (token == NULL) {
            break;
        }
        node = mxmlFindElement(papa, tree, token, NULL, NULL, MXML_DESCEND_FIRST);
        if (node == NULL) {
            // printf("crate %s\n", token);
            papa = mxmlNewElement (papa, token);
            continue;
        } 

        if (num != 1 && j == (level-1)) {
            int i;
            for (i = 1; i < num; i++) {
                node = mxmlFindElement(node, tree, token, NULL, NULL, MXML_NO_DESCEND);
                if (node == NULL) {
                    break;
                }
            }
        }

        if (node == NULL) {
            papa = mxmlNewElement (papa, token);
        } else {
            papa = node;
        } 
        // printf("%d: %s\n", j, token);
    }

    if (NULL == node) {
        return papa;
    } else {
        return NULL;
    }
}

int node_process(char cmd, mxml_node_t *tree, char *key, char *val, int num)
{
    mxml_node_t *node = NULL;

    switch (cmd) {
    case 'a':	
        node = xpath_create(tree, key, num);
        if(NULL != node) {
            // although node-text is empty, keep empty
            mxmlNewText(node, 0, val);
        } else {
            eprintf("%s exist\n", key);
            // return __LINE__;
        }
        break;

    case 'd':	
        node = xpath_find(tree, key, num);
        if(NULL != node) {
            mxmlDelete(node);
        }
        break;

    case 'w':	
        node = xpath_find(tree, key, num);
        if (node == NULL) {
            eprintf("not found: [%d]%s\n", num, key);
            return __LINE__;
        }
        if (NULL != node->child) {
            // printf("set\n");
            mxmlSetText(node->child, 0, val); // mxmlSetTextf() doesn't work
        } else {
            mxmlNewText(node, 0, val);
        }
        break;

    case 'r':	
        node = xpath_find(tree, key, num);
        if (NULL != node) {
           // mxml-2.8  vs mxml-2.7 -> (node->child) vs (node->child->value.text.string)
           // printf("%p\n", (node->child));
           
            if (node->child == NULL) {
                eprintf("%s __got_empty_text__\n", key);
                return __LINE__;
            } else {
                printf("%d %s %s\n", num, key, trimsps(node->child->value.opaque));
            }
        } else {
            eprintf("not found: [%d]%s\n", num, key);
            return __LINE__;
        }
    }
    return 0;
}

int parse_opt(int argc, char *argv[])
{
    char cmd[4] = {0};
    char key[128] = {0};
    char val[128] = {0};
    char file[128] = {0};
    int  num = 0;


    int flag = 0;
    int c;
    while (1) {
        int option_index = 0;
        /* 
         * name;     has_arg;    flag; val;
         * {"quiet", 0,          0,      0}
         *
         * ATTENTION:
         *   when has_arg set to 1, a ':' add in "hc:k:f:v:" accordingly
         *   on cmdline: -q a  <==> -qa
         */
        static struct option long_options[] = {
            {"help" , 0, 0, 'h'},
            {"inner", 0, 0, 'i'},
            {"cmd"  , 1, 0, 'c'},
            {"file" , 1, 0, 'f'},
            {"key"  , 1, 0, 'k'},
            {"val"  , 1, 0, 'v'},
            {"num"  , 1, 0, 'n'},
            {0      , 0, 0, 0  }
        };

        c = getopt_long(argc, argv, "hic:k:f:v:n:", long_options, &option_index);
        if (c == -1)
            break;

        switch (c) {
        case 'c':
            flag |= FLAG_CMD;
            strncpy(cmd, optarg, 1);
            
            if (cmd[0] != 'a' && cmd[0] != 'd' && cmd[0] != 'w' && cmd[0] != 'r') {
                pritnt_usage(argv, __LINE__);
            }
            break;

        case 'f':
            flag |= FLAG_FILE;
            strncpy(file, optarg, sizeof(file));
            break;

        case 'k':
            flag |= FLAG_KEY;
            strncpy(key, optarg, sizeof(key));
            break;

        case 'v':
            flag |= FLAG_VAL;
            strncpy(val, optarg, sizeof(val));
            break;

        case 'n':
            flag |= FLAG_NUM;
            num = atoi(optarg);
            break;

        case 'i':
            flag |= FLAG_INNER;
            break;

        case 'h':
            pritnt_usage(argv, 0);
        default:
            pritnt_usage(argv, __LINE__);
        }
    }

    if (!(flag & FLAG_CMD)) {
        pritnt_usage(argv, __LINE__);
    }

    if ((flag & FLAG_NUM) && num < 1) {
        pritnt_usage(argv, __LINE__);
    }

    // xml-file needed
    if (optind == (argc-1)) {
        if (0 != access(argv[optind], R_OK)) {
            eprintf("file %s is not readable\n", argv[optind]);
            exit(1);
        }
    } else {
        fprintf(stderr, "optind:%d argc-1:%d\n", optind, argc-1);
        pritnt_usage(argv, __LINE__);
    }

    int ret;
    const char *xmlfile = argv[optind];
	FILE *fp_xml = fopen(xmlfile, "r");
    return_val_if_fail(fp_xml != NULL, FAILURE);

    mxml_node_t *tree = NULL;

    if (cmd[0] == 'r') {
        tree = mxmlLoadFile(NULL, fp_xml, MXML_OPAQUE_CALLBACK);   
        return_val_if_fail(tree != NULL, FAILURE);
    } else {
        tree = mxmlLoadFile(NULL, fp_xml, MXML_TEXT_CALLBACK);   
        return_val_if_fail(tree != NULL, FAILURE);
    }

    fclose(fp_xml);

    if (flag & FLAG_FILE) {
        int match;
        FILE *fp;
        char *line = NULL;
        size_t len = 0;

        fp = fopen(file, "r");
        if (fp == NULL) {
            exit(1);
        }

        while ((getline(&line, &len, fp)) != -1) {
            match = sscanf(line, "%d%s%*[ ]%[^\n]", &num, key, val);
            if ((match == 3 && (cmd[0] == 'a' || cmd[0] == 'w')) || 
                (match == 2 && (cmd[0] == 'd' || cmd[0] == 'r'))) {
                ret = node_process(cmd[0], tree, key, val, num);
                if (ret != 0) {
                    pritnt_usage(argv, ret);
                }
            } else {
                eprintf("Retrieved error format line %s\n", line);
            }
        }

        free(line);
        fclose(fp);
    } else {
        ret = node_process(cmd[0], tree, key, val, num);
        if (ret != 0) {
            pritnt_usage(argv, ret);
        }
    }

    if (cmd[0] != 'r') {
        if (flag&FLAG_INNER) {
            FILE *fp = fopen(argv[optind], "w");
            mxmlSaveFile(tree, fp, xml_format_write);
        } else {
            char *ptr = mxmlSaveAllocString(tree, xml_format_write);
            printf("%s\n", ptr);
        }
    }

    return 0;
}

int main(int argc, char *argv[])
{
    parse_opt(argc, argv);
    return 0;
}

