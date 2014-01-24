/* 
 *       Filename:  xRD.c
 *    Description:  
 *        Version:  1.0
 *        Created:  Sunday, December 01, 2013 03:30:26 CST
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

/* socket() */
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

/* self-header-file */
// #include </usr/include/xt_macro.h>

#if 0

1. Shenzhen

    除权参考价  = （股权登记日总市值+配股总数×配股价－派现金总额）/除权后总股本
                =(（股权登记日总市值+配股总数×配股价－派现金总额）/除权前总股本) /
                        (除权后总股本 / 除权前总股本)
        则相较沪市，则只是在 pei_ratio = pei_ratio * (nmc/cap);

    设当前流通率 k1, 之前流通率 k0
    k0(1+song_ratio+pei_ratio)/(1+song_ratio+k*pei_ratio) = k1

2. 若没有配股，则两市公式通用
3. 若有配股，且全流通，则两市公式通用

4. 只是为了kdj的难看，因此全使用沪市的计算方法。

#endif

int main(int argc, char *argv[])
{
#ifdef __sh__
    // 600960
    float sh_xRD_open;
    float yesclose  = 8.8;
    float song_ratio= 0.3;
    float pei_ratio = 0.0;
    float pei_price = 0.0;
    float div_ratio = 0.026;
    sh_xRD_open = (yesclose + pei_price*pei_ratio - div_ratio) / (1+song_ratio+pei_ratio);
    printf("%f\n", sh_xRD_open);
#else
    // 000887
    // 000982
    float sz_xRD_open;
    float yesclose  = 9.03;
    float song_ratio= 0.0;
    float pei_ratio = 0.3;
    float pei_price = 3.89;
    float div_ratio = 0.;

    sz_xRD_open = (yesclose + pei_price*pei_ratio - div_ratio) / (1+song_ratio+pei_ratio);
    printf("%f\n", sz_xRD_open);
#endif

    return 0;
}
