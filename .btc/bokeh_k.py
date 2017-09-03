import sys
import time
from math import pi
import pandas as pd
from bokeh.layouts import gridplot
from bokeh.models import ColumnDataSource, HoverTool, CrosshairTool
from bokeh.plotting import figure, show, output_file
from bokeh.sampledata.stocks import MSFT

# print(time.time())

def plot_k(df):
    i_src = ColumnDataSource(df[df.open <  df.close])
    d_src = ColumnDataSource(df[df.open >= df.close])
    w = 16*60*60*1000 # half day in ms

    TOOLS = "pan,xwheel_zoom,ywheel_zoom,box_zoom,reset,save"

    p = figure(x_axis_type="datetime", tools=TOOLS, plot_width=1500, plot_height=640, title = "MSFT Candlestick") # hei 880
    p.toolbar.active_scroll = "auto"
    p.xaxis.major_label_orientation = pi/4
    p.grid.grid_line_alpha=0.3
    p.background_fill_color = "black"

    p.segment('date', 'high', 'date', 'low', source=i_src, color="red")
    p.segment('date', 'high', 'date', 'low', source=d_src, color="green")

    p.vbar('date', w, 'open', 'close', source=i_src, name="kline", fill_color="red", line_color="red")
    p.vbar('date', w, 'open', 'close', source=d_src, name="kline", fill_color="green", line_color="green")

    p.add_tools(HoverTool(tooltips= [("date","@ToolTipDates"),
                                     ("close","@close{0,0.00}"),
                                     ("high","@high{0,0.00}"),
                                     ("low","@low{0,0.00}")], names= ["kline",], ))
    p.add_tools(CrosshairTool(line_color='grey'))

    inc_process(df, p)

    output_file("candlestick.html", title="candlestick.py example", mode='inline')
    gridplot()
    show(p)  # open a browser

def inc_process(df, p):
    print(df[df.index==0].close.max())              # get value

    tbl_bi = []
    i_bi = 0

    df_fb = df[0:9]
    id_max_hi=df_fb.high.idxmax()
    id_min_lo=df_fb.low.idxmin()

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
    df_len = len(df)

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
            elif id_min_lo-id_max_hi>=4:            # 形成底分型
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
            elif id_max_hi-id_min_lo>=4:            # 形成顶分型
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

    # print(df_fb)
    print('_____')
    pass

print(time.time())
df = pd.DataFrame(MSFT)[:200]
df["date"] = pd.to_datetime(df["date"])
df['ToolTipDates'] = df.date.map(lambda x: x.strftime("%y-%m-%d")) # Saves work with the tooltip later

# print(df.head(3))
# print(df[df.open >= df.close])
# sys.exit(0)

plot_k(df)

# inc_process(df)

print(time.time())

