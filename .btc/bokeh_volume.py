#! /usr/bin/python3

import time
from math import pi
import pandas as pd
from bokeh.layouts import gridplot, column
from bokeh.models import ColumnDataSource, HoverTool,CrosshairTool
from bokeh.plotting import figure, show, output_file
from bokeh.sampledata.stocks import MSFT, AAPL
from sys import exit

t_sta = time.time()

def plot_k(df):
    i_src = ColumnDataSource(df[df.open <  df.close])
    d_src = ColumnDataSource(df[df.open >= df.close])
    w = 16*60*60*1000 # half day in ms

    #TOOLS = "pan,crosshair,xwheel_zoom,ywheel_zoom,box_zoom,reset,save"
    TOOLS = "pan,xwheel_zoom,ywheel_zoom,box_zoom,reset"

    pv = figure(x_axis_type="datetime", tools=TOOLS, plot_width=1500, plot_height=160, )    # title="volume"
    pv.vbar('date', w, top='volume', source=i_src, name="kline", fill_color="red", line_color="red")
    pv.vbar('date', w, top='volume', source=d_src, name="kline", fill_color="green", line_color="green")

    pv.toolbar.active_scroll = "auto"
    pv.xaxis.major_label_orientation = pi/4
    pv.grid.grid_line_alpha=0.3
    pv.background_fill_color = "black"

    #pv.xaxis.major_label_overrides = {
    #    i: date.strftime('%m%d') for i, date in enumerate(pd.to_datetime(df["date"]))
    #}

    pv.add_tools(HoverTool(tooltips= [("date","@ToolTipDates"),
                                     ("volume","@volume{0,0.00}")], names= ["volume",], ))
    pv.add_tools(CrosshairTool(line_color='#999999'))

    p = figure(x_axis_type="datetime", tools=TOOLS, plot_width=1500, plot_height=640, title = "MSFT Candlestick") # hei 880
    p.x_range = pv.x_range
    p.toolbar.active_scroll = "auto"
    p.xaxis.major_label_orientation = pi/4
    p.grid.grid_line_alpha=0.3
    p.background_fill_color = "black"
    p.xaxis.visible = False

    p.segment('date', 'high', 'date', 'low', source=i_src, color="red")
    p.segment('date', 'high', 'date', 'low', source=d_src, color="green")

    p.vbar('date', w, 'open', 'close', source=i_src, name="kline", fill_color="red", line_color="red")
    p.vbar('date', w, 'open', 'close', source=d_src, name="kline", fill_color="green", line_color="green")

    hover_tool = p.add_tools(HoverTool(tooltips= [("date","@ToolTipDates"),
                                     ("close","@close{0,0.00}"),
                                     ("high","@high{0,0.00}"),
                                     ("low","@low{0,0.00}")], names= ["kline",], ))
    crosshair_tool = p.add_tools(CrosshairTool(line_color='#999999'))

    # p.toolbar.active_inspect = [hover_tool, crosshair_tool]

    inc_process(df, p)

    output_file("candlestick.html", title="candlestick.py example", mode='inline')
    grid = gridplot([[p], [pv]], sizing_mode="scale_width", merge_tools=False, responsive = True)
    #show(pv)  # open a browser
    #show(column(p, pv))
    show(grid)

def uni_process(df, asc, sta, end):
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

def inc_process(df, p):
    df_len = len(df)
    df_fb = df[0:9]
    id_max_hi=df_fb.high.idxmax()
    id_min_lo=df_fb.low.idxmin()

    df['uni'] = [0 for i in range(len(df))]
    uni_process(df, id_max_hi>id_min_lo, max(id_max_hi,id_min_lo), df_len)

    i_bi = 0
    tbl_bi = pd.DataFrame(columns=('date', 'price'))

    print(id_min_lo, id_max_hi)

    asc = False

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

        print(sta, end, offset)
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
            else:                                   #
                offset += 5
                pass

    # tbl_bi.loc[i_bi] = [df.get_value(id_min_lo, 'date'), df.get_value(id_min_lo, 'low')]
    # i_bi+=1
    print(tbl_bi.date)

    p.line(tbl_bi.date, tbl_bi.price, line_width=1, color="#3060a0")
    p.circle(df.date[df.uni ==  1], df.high[df.uni ==  1]*1.03, size=3, color="red", alpha=0.5)
    p.circle(df.date[df.uni == -1], df.low [df.uni == -1]*0.97, size=3, color="green", alpha=0.5)

    # print(df_fb)
    print('_____')
    pass

print(time.time())
df = pd.DataFrame(AAPL)[:2000]
df["date"] = pd.to_datetime(df["date"])
df['ToolTipDates'] = df.date.map(lambda x: x.strftime("%y-%m-%d")) # Saves work with the tooltip later

print(df.head(3))
# print(df[df.open >= df.close])
# sys.exit(0)

plot_k(df)

# inc_process(df)

print("Spend total:", time.time() - t_sta)


