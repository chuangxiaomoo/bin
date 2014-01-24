/* program */

    1	symbol:sh600000          │  symb         │
    2	code:600000              │  代码         │
    3	name:PuFaYinHang         │  名称         │
    4	trade:0.000              │  最新价       │
    5	pricechange:0.000        │  涨跌额       │
    6	changepercent:0.000      │  涨跌幅       │
    7	buy:0.000                │  买入         │
    8	sell:0.000               │  卖出         │
    9	settlement:8.490         │  昨收         │
   10	open:0.000               │  今开         │
   11	high:0.000               │  最高         │
   12	low:0.000                │  最低         │
   13	volume:0                 │  成交量/手    │
   14	amount:0                 │  成交额/万    │
   15	per:4.632                │  市盈率       │      price-earning ratio
   16	pb:0.848                 │  市净率       │      price-to-book ratio 
   17	mktcap:15836797.231335   │  总市值       │
   18	nmc:12669437.785068      │  流通市值     │      circulation market cap 
   19	turnoverratio:0          │  换手率       │



# rise, soar, jump, launch, bounce, move up,....., etc.
# fall, drop, slide, sink, roll down..... etc.
# bull, bear
# [decline, downslope, downhill] ascent 上下坡


/*  rate 从基数中选多少， 基数是100时如同：percent 
    ratio 比率，如量比 大于1 小于1 
 */

symb     
"代码", "名称", "最新价", "涨跌额", "涨跌幅", "买入", "卖出", "昨收", "今开", "最高", "最低", "成交量/手", "成交额/万", "市盈率", "市净率", "总市值", "流通市值", "换手率",

echo | awk '{ 
    printf "%-6s %-12s %-6s %-6s %-6s %-6s %-6s %-6s %-6s %-6s %-6s %-8s %-8s %-8s\n", \
    "代码", "名称", "最新价", "涨跌额", "涨跌幅", "买入", "卖出", "昨收", "今开", "最高", "最低", "成交量/手", "成交额/万";
}'

