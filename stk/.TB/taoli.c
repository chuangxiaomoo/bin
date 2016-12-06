Params
    Numeric K(2);
Vars
    NumericSeries Dif(0); 
    NumericSeries Mean(0); 
    NumericSeries Stdn(0); 
    Numeric Lsb(1);
    Numeric M480;
    Numeric N(30);

    Numeric hms0;
    Numeric hms1;
    Numeric k_cnt;
    Numeric i(1);
    Numeric limit(.06);
    Numeric d0_amount(0);
    Numeric d0_vol(0);
    Numeric d0_stl(0);

Begin
    /* Bollin */
    Lsb = minmove*pricescale;
    Dif = (Data0.C - Data1.C)/Lsb;
    Mean = XAverage(Dif, N);
    M480 = XAverage(Dif, 480);
    Stdn = StandardDev(Dif, N, 2);

    PlotNumeric("Dif", Dif, 0, LightGray); 
    PlotNumeric("Mean",Mean,0, Cyan); 
    PlotNumeric("M480",M480,0, Magenta); 
    PlotNumeric("Top", Mean+K*Stdn,0, Green); 
    PlotNumeric("Bot", Mean-K*Stdn,0, Red); 

    /* settle */
    hms0 = IntPart(Data0.Time*1000000);
    hms1 = IntPart(Time[1]*1000000);
    if (Data0.Date*1000000+hms0 > 20161124150000) {
        limit = .07;
    }

    if ( ( hms0 == 210000 || (hms0 == 90000 && hms1 == 145900) ) )  {
        if (hms0 == 210000 && IntPart(Time[345]*1000000) != 210000) {
            k_cnt = 225;
        } else {
            k_cnt = 345;
        }

        i = 1;
        While (i<=k_cnt) {
            d0_amount = d0_amount + (Data0.Open[i]+Data0.High[i]+Data0.Low[i]+Data0.Close[i])/4*Data0.Vol[i];
            d0_vol = d0_vol + Data0.Vol[i];
            i+=1;
        }

        d0_stl = Round(d0_amount/d0_vol,2);
        SetGlobalVar(345, d0_stl);         // No.345
//        FileAppend("E:\\winc\\log.txt", Text(Data0.Date+Data0.Time[i-1]) +  "  amt: " + Text(d0_amount) + " vol: " + Text(d0_vol) + " stl: " + Text(d0_stl)
//            + " Stlxx: " + Text(Data0.Q_PreSettlePrice()) + " Stlyy: " + Text(Data1.Q_PreSettlePrice() ) 
//            + " limit: " + Text(Data0.Date+hms0 + limit)
//            ) ;
    }else {
        d0_stl = GetGlobalVar(345);
    }

    // Commentary(Text(d1_stl));
    if ( (!(hms0 >=  90000 && hms0<= 90400)) && 
         (!(hms0 >= 112600 && hms0<=133400)) &&
         (!(hms0 >= 145600 && hms0<=150000)) &&
         (!(hms0 >= 210000 && hms0<=210400)) && 
         (!(hms0 >= 223000 && hms0<=230000)) &&
            abs((Close-d0_stl)/d0_stl) >= (limit*.58)  &&  Stdn>=2.5 && abs(Mean-M480)>=3 ) {
        FileAppend("E:\\winc\\log.txt", "Mean: " + Text(Mean) + " M480: " + Text(M480) + " Dif: " + Text(Dif) + " Stdn: " + Text(Stdn));

        if (Stdn>=4) {
            i=0;
        } else {
            i=1;
        }

        if (Mean>M480 && Dif>=IntPart(Mean+K*Stdn)+i) {     // 反向空
             PlotBool("Sel",True, Dif+4, Green());
        } else
        if (Mean<M480 && Dif<=IntPart(Mean-K*Stdn)-i) {     // 反向多
             PlotBool("Buy",True, Dif-4, Red());
        }
    }

    /* last print */ 
    If (Dif < 0) {
        Stdn = intpart(Highest(Dif,120)/10-1)*10 - Stdn;
    } else {
        Stdn = intpart(Highest(Dif,120)/10+1)*10 + Stdn;
    }
    PlotNumeric("Stdn",Stdn,0, Rgb(180,180,0)); 

End


