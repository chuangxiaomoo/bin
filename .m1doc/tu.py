import tushare as ts

# 0. 获取连接备用
# [](http://mp.weixin.qq.com/s/RhGgTEVHqm8aDh2ZzpLviA)
cons = ts.get_apis()


# 1. 股票日线行情
df = ts.bar('600000', conn=cons, freq='D', start_date='2016-01-01', end_date='')
df.head(5)

# 2. 带因子的行情
# ma=[5, 10, 20, 60] 表示一次性获得5/10/20/60日均线
# factors=[‘vr’, ‘tor’]，vr表示量比，tor表示换手率
df = ts.bar('600000', conn=cons, start_date='2016-01-01', end_date='', 
            ma=[5, 10, 20], factors=['vr', 'tor'])
df.head(5)


# 3. 复权行情
# adj=qfq(前复权)， hfq（后复权），默认None不复权
df = ts.bar('600000', conn=cons, adj='qfq', start_date='2016-01-01', end_date='')
df.head(5)


# 4. 分钟数据
# 设置freq参数，分别为1min/5min/15min/30min/60min，D(日)/W(周)/M(月)/Q(季)/Y(年)
df = ts.bar('600000', conn=cons, freq='1min', start_date='2016-01-01', end_date='')
df.head(15)


# 5. 指数日行情
# 设置asset='INDEX'
df = ts.bar('000300', conn=cons, asset='INDEX', start_date='2016-01-01', end_date='')
df.head(5)


# 6. 港股数据, 设置asset='X'
df = ts.bar('00981', conn=cons, asset='X', start_date='2016-01-01', end_date='')
df.head(5)


# 7. 期货数据, 设置asset='X'
df = ts.bar('CU1801', conn=cons, asset='X', start_date='2016-01-01', end_date='')
df.head(5)


# 8. 美股数据, 设置asset='X'

df = ts.bar('BABA', conn=cons, asset='X', start_date='2016-01-01', end_date='')
df.head(5)

# 1. 股票tick
# type:买卖方向，0-买入 1-卖出 2-集合竞价成交
# 数据里没有增加代码一列，如果有需要可以同多df[‘code’] = code实现
df = ts.tick('600000', conn=cons, date='2017-10-26')
df.head(20)

# 2. 期货tick
# 期货tick,type:买卖方向，0:开仓  1:多开   -1:空开
df = ts.tick('CU1801', conn=cons, asset='X', date='2017-10-25')
df.head(20)

# 沪/深港通每日资金流向(南向/北向资金)
df = ts.moneyflow_hsgt()
df.sort_values('date', ascending=False)


