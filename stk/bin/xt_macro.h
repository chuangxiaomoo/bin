/*
 *    Description:  
 *        Version:  1.0
 *        Created:  Friday, November 02, 2012 11:47:59 CST
 *         Author:  zhangjian (), 
 *   Organization:  
 *          Usage:  use the below MACRO if you want to change a log file
 *                  #ifdef CONSOLE
 *                  #   undef CONSOLE
 *                  #endif
 */

#ifndef	_XT_MACRO_H
#define	_XT_MACRO_H

#include <errno.h>

#define TRUE    1
#define FALSE   0
#define FAILURE (-1)
#define SUCCESS 0
#define RETVOID free(NULL)

#define CONSOLE stdout

#define ARRAY_SIZE(array) ((int)(sizeof(array) / sizeof(array[0])))

/* 
 * to replace basename((char *)__FILE__)
 * implement: strrchr return type of __FILE__
 */
static inline const char *__base__(const char *path)
{   
    static const char *base = NULL;
    if (!base) {     /*  */
        const char *p = strrchr(path, '/'); 
        base = (p != NULL) ? (p+1) : path; 
    }
    return base;
}

/* return_val_if_fail(condi, ((printf("what u want print\n"), ret))); */

#define return_val_if_fail(condi, ret) do {                                   \
    if (!(condi)) {                                                           \
        fprintf(CONSOLE, "%s|%d| fail (" #condi ")\n", __FILE__, __LINE__);   \
        return ret; }                                                         \
} while (0)

#define goto_tag_if_fail(condi, tag) do {                                     \
    if (!(condi)) {                                                           \
        fprintf(CONSOLE, "%s|%d| fail (" #condi ")\n", __FILE__, __LINE__);   \
        goto tag; }                                                           \
} while (0)

/* xt_ serial */

#define xt_jump(condi, jump, lable, fmt, args...) do {      \
    if (!(condi)) {                                         \
        fprintf(CONSOLE, "%s|%d| fail (" #condi ") " fmt,   \
              __base__(__FILE__), __LINE__, ##args);        \
        fflush(NULL);                                       \
        jump lable;                                         \
    }                                                       \
} while (0)

#define  xt_pri(fmt, args...)             xt_jump(0, ;, ;, fmt, ##args)
#define  xt_ret(condi, val, fmt, args...) xt_jump(condi, return, val, fmt, ##args)
#define xt_goto(condi, tag, fmt, args...) xt_jump(condi, goto, tag, fmt, ##args)
#define  sy_ret(condi, val, fmt, args...) xt_jump(condi, return, val, "%s\n", strerror(errno))
#define sy_goto(condi, tag, fmt, args...) xt_jump(condi, goto, tag, "%s\n", strerror(errno))

#endif
