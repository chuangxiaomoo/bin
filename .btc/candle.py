import time
from math import pi
import pandas as pd
from bokeh.layouts import gridplot, column
from bokeh.models import ColumnDataSource, HoverTool,CrosshairTool
from bokeh.plotting import figure, show, output_file
from bokeh.sampledata.stocks import MSFT, AAPL
from sys import exit

def fn_plot_volume(df, p_v):
    w = 16*60*60*1000 # half day in ms
    i_src = ColumnDataSource(df[df.open <  df.close])
    d_src = ColumnDataSource(df[df.open >= df.close])

    p_v.vbar('date', w, top='volume', source=i_src, name="volumn", fill_color="red", fill_alpha=0, line_width=0.8, line_color="red" )
    p_v.vbar('date', w, top='volume', source=d_src, name="volumn", fill_color="green",             line_width=0.8, line_color="green")

    p_v.toolbar.active_scroll = "auto"
    p_v.xaxis.major_label_orientation = pi/4
    p_v.grid.grid_line_alpha=0.3
    p_v.background_fill_color = "black"
    p_v.sizing_mode = 'stretch_both'

    hover_tool = p_v.add_tools(HoverTool(tooltips=[
                ("date","@ToolTipDates"),
                ("volume","@volume{0,0.00}"),
                ("diff","@diff{0,0.00}"),
                ("macd","@macd{0,0.00}"),
                ("dea","@dea{0,0.00}")], names= ["volumn","macd"], mode="mouse", point_policy="follow_mouse"))
    pass

def fn_ma(df, col, N):
    sum = 0
    for i in range(len(df)):
        if i>=20:
            sum -= df.get_value(i-20, 'close')
            sum += df.get_value(i, 'close')
            df.set_value(i, col, sum/20)
        elif i==19:
            sum += df.get_value(i, 'close')
            df.set_value(i, col, sum/20)
        else:
            sum += df.get_value(i, 'close')
    pass

def fn_plot_kline(df, p_k, all_source):
    w = 16*60*60*1000 # half day in ms
    i_src = ColumnDataSource(df[df.open <  df.close])
    d_src = ColumnDataSource(df[df.open >= df.close])

    p_k.toolbar.active_scroll = "auto"
    p_k.xaxis.major_label_orientation = pi/4
    p_k.grid.grid_line_alpha=0.3
    p_k.background_fill_color = "black"

    p_k.segment('date', 'high', 'date', 'low', source=i_src, name="kline", color="red", line_width=0.8)
    p_k.segment('date', 'high', 'date', 'low', source=d_src, name="kline", color="green", line_width=0.8)

    p_k.vbar('date', w, 'open', 'close', source=i_src, name="kbar", fill_color="black", line_color="red", line_width=0.8)
    p_k.vbar('date', w, 'open', 'close', source=d_src, name="kbar", fill_color="green", line_color="green", line_width=0.8)

    p_k.line('date', 'ma20', source=all_source, name='ma20', line_color="purple")

    hover_tool = p_k.add_tools(HoverTool(tooltips= [
                ("date","@ToolTipDates"),
                ("close","@close{0,0.00}"),
                ("high","@high{0,0.00}"),
                ("low","@low{0,0.00}"),
                ("ma20","@ma20{0,0.00}"),
                ], names=["kline","kbar"], mode="mouse")) # vline doesn't work
    p_k.sizing_mode = 'stretch_both'

def fn_ema(df, src, dst, N):
    for i in range(len(df)):
        if i>0:
            df.set_value(i, dst, (2*df.get_value(i, src)+(N-1)*df.get_value(i-1,dst))/(N+1))
        else:
            df.set_value(i, dst, df.get_value(0, src))
    return df[dst]

def fn_plot_macd(df, p_m, all_source):
    w = 16*60*60*1000 # half day in ms
    i_macd = ColumnDataSource(df[df.macd >= 0])
    d_macd = ColumnDataSource(df[df.macd <  0])
    # plot
    p_m.toolbar.active_scroll = "auto"
    p_m.xaxis.major_label_orientation = pi/4
    p_m.grid.grid_line_alpha=0.1
    p_m.background_fill_color = "black"
    p_m.vbar('date', w/4, top='macd', source=i_macd, name='macd', fill_color="red", line_color="red")
    p_m.vbar('date', w/4, top=0, bottom='macd', source=d_macd, name='macd', fill_color="green", line_color="green")
    p_m.line('date', 'diff', source=all_source, name='macd', line_color="white")
    p_m.line('date', 'dea',  source=all_source, name='macd', line_color="yellow")
    pass

def fn_uni_process(df, asc, sta, end):
    asc_bi = asc
    hi = 0
    lo = 1

    k1 = [df.get_value(sta, 'high'), df.get_value(sta, 'low')]
    for i in range(sta+1, end-1):
        k2 = [df.get_value(i, 'high'), df.get_value(i, 'low')]
        # print(i, k1[hi] , k2[hi] , k1[lo] , k2[lo])
        if (k1[hi] >= k2[hi] and k1[lo] <= k2[lo]) or (k2[hi] >= k1[hi] and k2[lo] <= k1[lo]):
            if asc_bi:
                k1 = [max(k2[hi],k1[hi]), max(k1[lo], k2[lo])]
                df.set_value(i, 'uni', 1)                       # up
                # print('got i asc:', df.get_value(i, 'date'), i)
            else:
                k1 = [min(k2[hi],k1[hi]), min(k1[lo], k2[lo])]
                df.set_value(i, 'uni', -1)                      # down
                # print('got i dsc:', df.get_value(i, 'date'), i)
                pass
        elif k2[hi] > k1[hi]:                           # k2 新高
            asc_bi = True
            k1 = k2
        elif k2[lo] < k1[lo]:                           # k2 新低
            asc_bi = False
            k1 = k2

def fn_plot_fenbi(df, p_k, tbl_bi):
    df_len = len(df)
    df_fb = df[0:9]
    id_max_hi=df_fb.high.idxmax()
    id_min_lo=df_fb.low.idxmin()

    df['uni'] = [0 for i in range(len(df))]
    fn_uni_process(df, id_max_hi>id_min_lo, max(id_max_hi,id_min_lo), df_len)

    i_bi = 0
    asc = False
    # print(id_min_lo, id_max_hi)

    if id_max_hi - id_min_lo >= 4:
        tbl_bi.loc[i_bi] = [df.get_value(id_min_lo, 'date'), df.get_value(id_min_lo, 'low')]
        i_bi+=1
        tbl_bi.loc[i_bi] = [df.get_value(id_max_hi, 'date'), df.get_value(id_max_hi, 'high')]
        i_bi+=1
        asc = True
    elif  id_max_hi - id_min_lo <= -4:
        tbl_bi.loc[i_bi] = [df.get_value(id_max_hi, 'date'), df.get_value(id_max_hi, 'high')]
        i_bi+=1
        tbl_bi.loc[i_bi] = [df.get_value(id_min_lo, 'date'), df.get_value(id_min_lo, 'low')]
        i_bi+=1
        asc = False
    else:
        print('I am retrying')
        pass

    id_max_hi0 = id_max_hi
    id_min_lo0 = id_min_lo
    asc0 = asc

    sta = 0
    end = 0
    offset = 0

    while sta < df_len-1 and end < df_len-1:
        sta = max(id_max_hi0, id_min_lo0)
        end = sta+offset+5<=df_len-1 and sta+offset+5 or df_len-1
        df_fb = df[sta:end]

        # print(sta, end, offset)       # useful info
        id_max_hi=df_fb.high.idxmax()
        id_min_lo=df_fb.low.idxmin()

        if asc0:
            if id_max_hi != id_max_hi0 and df.get_value(id_max_hi, 'high') > df.get_value(id_max_hi0, 'high'):   # 创新高
                tbl_bi.loc[i_bi-1] = [df.get_value(id_max_hi, 'date'), df.get_value(id_max_hi, 'high')]
                id_max_hi0 = id_max_hi
                offset = 0
                continue

            # 形成底分型
            elif id_min_lo-id_max_hi>=4 and \
                    (id_min_lo-id_max_hi - len(df[(df.index>=id_max_hi) & (df.index<=id_min_lo) & (df.uni != 0)]) >= 4):
                tbl_bi.loc[i_bi] = [df.get_value(id_min_lo, 'date'), df.get_value(id_min_lo, 'low')]
                i_bi+=1
                asc0 = False
                offset = 0
                id_min_lo0 = id_min_lo
                continue
            else:                                   #
                offset += 5
                pass
        elif not asc0:
            if id_min_lo != id_min_lo0 and df.get_value(id_min_lo, 'low') < df.get_value(id_min_lo0, 'low'):
                tbl_bi.loc[i_bi-1] = [df.get_value(id_min_lo, 'date'), df.get_value(id_min_lo, 'low')]
                id_min_lo0 = id_min_lo
                offset = 0
                continue
            # 形成顶分型
            elif id_max_hi-id_min_lo>=4 and \
                    (id_max_hi-id_min_lo - len(df[(df.index>=id_min_lo) & (df.index<=id_max_hi) & (df.uni != 0)]) >= 4):
                tbl_bi.loc[i_bi] = [df.get_value(id_max_hi, 'date'), df.get_value(id_max_hi, 'high')]
                i_bi+=1
                asc0 = True
                offset = 0
                id_max_hi0 = id_max_hi
                continue
            else:
                offset += 5
                pass

    p_k.line(tbl_bi.date, tbl_bi.price, line_width=1, color="#3060a0")
    p_k.triangle(df.date[df.uni ==  1], df.high[df.uni ==  1]*1.03, size=5, color="red", alpha=0.5)
    p_k.triangle(df.date[df.uni == -1], df.low [df.uni == -1]*0.97, size=5, color="green", alpha=0.5)
    print('_____')
    pass

def fn_plot_segmt(p_k, tbl_bi):
    # 因为 even 非中心对称，so use segment but not rect
    i_shu = 0
    tbl_shu = pd.DataFrame(columns=('sta', 'end', 'hig', 'low'))
    tbl_shu.loc[i_shu] = ['2006-01-10', '2006-02-10', 86.4, 62.9 ]
    print(tbl_shu.sta)
    w = 24*60*60*1000 # half day in ms
    p_k.hbar( (180+220)/2, 220-180,
              pd.to_datetime('2007-12-05'), pd.to_datetime('2008-01-08'),
               name="shu2", line_color="white", fill_alpha = 0, line_width = 0.8)
    p_k.segment(tbl_shu.sta, tbl_shu.hig, tbl_shu.end, tbl_shu.low, name="shu", color="white")
    pass

def fn_main():
    df = pd.DataFrame(AAPL)[:2000]
    df["date"] = pd.to_datetime(df["date"])
    df['ToolTipDates'] = df.date.map(lambda x: x.strftime("%y-%m-%d")) # Saves work with the tooltip later

    # print(df.head(3))

    TOOL_k = "pan,xwheel_zoom,ywheel_zoom,box_zoom,reset"
    TOOL_v = "pan,ywheel_zoom"
    TOOL_m = "pan,ywheel_zoom"

    p_k = figure(x_axis_type="datetime", tools=TOOL_k, plot_width=1504, plot_height=600)     # title = "MSFT Candlestick") # hei 880
    p_v = figure(x_axis_type="datetime", tools=TOOL_v, plot_width=1504, plot_height=160)     # title="volume"
    p_m = figure(x_axis_type="datetime", tools=TOOL_m, plot_width=1504, plot_height=200)     # hei 880

    p_k.add_tools(CrosshairTool(line_color='#999999'))
    p_m.add_tools(CrosshairTool(line_color='#999999'))
    p_v.add_tools(CrosshairTool(line_color='#999999'))

    p_k.x_range = p_v.x_range = p_m.x_range         # 3 link must at one line
    p_k.xaxis.visible = p_v.yaxis.visible = p_v.xaxis.visible = False

    df['ma20'] = [0.0 for i in range(len(df))]
    fn_ma(df, 'ma20', 20)

    df['long'] = [0.0 for i in range(len(df))]
    df['short'] = [0.0 for i in range(len(df))]
    df['diff'] = fn_ema(df, 'close', 'short', 12) - fn_ema(df, 'close', 'long', 26)
    df['dea'] = fn_ema(df, 'diff', 'dea', 9)
    df['macd'] = 2*(df['diff']-df['dea'])

    all_source = ColumnDataSource(df)
    tbl_bi = pd.DataFrame(columns=('date', 'price'))

    fn_plot_kline(df, p_k, all_source)
    fn_plot_fenbi(df, p_k, tbl_bi)
    fn_plot_segmt(p_k, tbl_bi)
    fn_plot_volume(df, p_v)
    fn_plot_macd(df, p_m, all_source)

    output_file("chan.html", title="chan", mode='inline')
    grid = gridplot([[p_k], [p_v], [p_m]], merge_tools=False, responsive=True)
    grid.sizing_mode = 'stretch_both'
    show(grid)
    pass

t_sta = time.time()
fn_main()
print("Spend total:", time.time() - t_sta)
