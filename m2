#! /bin/bash

ubt=192.168.2.45
ARCHIVE=~/bin/.m2doc/
 . ${ARCHIVE}.pri.bashrc
cd ${ARCHIVE}

function fn_herb()                      {
function fn_5邪()                       { cat herb_5邪 ;}
function fn_中医学理论体系()            { cat herb_中医学理论体系 ;}
function fn_medicine()                  { cat herb_medicine ;}
    local opts=(
        中医学理论体系
        5邪
        case                            # 叶天士 临症指南
        medicine                        # 常见药
    )
    fn_print $@
}

function fn_mng()                       {
function fn_honor()    	                { cat mng_honor ;}
function fn_promotion()                 { cat mng_promotion ;}
function fn_01_审时度势见机行事()       { cat mng_01_审时度势见机行事 ;}
function fn_02_行不言之教()             { cat mng_02_行不言之教 ;}
function fn_03_培养新人()               { cat mng_03_培养新人 ;}
function fn_04_一次失败的项目经理招聘() { cat mng_04_一次失败的项目经理招聘 ;}
function fn_11_王熙凤()                 { cat mng_11_王熙凤 ;}
function fn_talk()                      { cat mng_talk ;}
function fn_recruiting_招聘()           { cat mng_recruiting_招聘 ;}
function fn_newbie()                    { cat mng_newbie ;}
function fn_error_11()                  { cat mng_error_11 ;}
function fn_p_你会泡员工吗()            { cat mng_p_你会泡员工吗 ;}
function fn_00_官僚及管理的本质()       { cat mng_00_官僚及管理的本质 ;}
function fn_21_莱茵河为何总是清的()     { cat mng_21_莱茵河为何总是清的 ;}
function fn_22_莱茵河如何跨国治污()     { cat mng_22_莱茵河如何跨国治污 ;}
    local opts=(
        recruiting_招聘                 # recruiting 先于 cultivate
        error_11
        newbie
        honor
        talk
        promotion                       # 晋升以来
        p_你会泡员工吗
        00_官僚及管理的本质             # 对于自我意识的延伸
        01_审时度势见机行事             # 作一个有能力的人是获得 honor 的基础
        02_行不言之教
        03_培养新人                     # cultivate
        04_一次失败的项目经理招聘       # 产品经理

        11_王熙凤                       # 天下大事，必作于细

        21_莱茵河为何总是清的
        22_莱茵河如何跨国治污
    )
    fn_print $@
}

function fn_annual()                    {
function fn_plan_what()                 { cat annual_plan_what ;}
function fn_report_what()               { cat annual_report_what ;}
function fn_seminar_what()              { cat annual_seminar_what ;}
function fn_2011_investment_report()    { cat annual_2011_investment_report ;}
function fn_2014_jco()                  { cat annual_2014_jco ;}
function fn_2014_spring_festival()      { cat annual_2014_spring_festival ;}
function fn_2014_grandpa_inlaw()        { cat annual_2014_grandpa_inlaw ;}
function fn_2014_national_day()         { cat annual_2014_national_day ;}
function fn_2012_plan()                 { cat annual_2012_plan                   annual_2012_report;}
function fn_2013_plan()                 { cat annual_2013_plan annual_2013_event annual_2013_report;}
function fn_2014_plan()                 { cat annual_2014_plan annual_2014_event annual_2014_report;}
function fn_2015_plan()                 { cat annual_2015_plan annual_2015_event annual_2015_report;}
function fn_2016_plan()                 { cat annual_2016_plan annual_2016_event annual_2016_report 
                                              annual_2016_ljsw annual_2016_xiaolai ;}
function fn_2017_plan()                 { cat annual_2017_plan ;}
    local opts=(
        plan_what                       # 基于`以终为始`的理念
        report_what
        seminar_what
        2011_investment_report
        2014_spring_festival
        2014_jco
        2014_grandpa_inlaw
        2014_national_day               # NationalDay
        2012_plan
        2013_plan
        2014_plan                       # `多算胜，少算不胜`
        2015_plan
        2016_plan
        2017_plan
    )
    fn_print $@
}

#
# Just like BRAIN sort KNOWLEDGE always, we need sort contineuously!
# a BOOK can append with a reflect
#
function fn_book()                      {
function fn_cept()                      { cat book_cept ;}
function fn_laozi()                     { cat book_laozi ;}
function fn_sunzi()                     { cat book_sunzi;
                                          cat arch_sunzi ;}
function fn_liutao()                    { cat book_liutao ;}
function fn_lunyu()                     { cat book_lunyu ;}
function fn_36ji()                      { cat book_36ji ;}

function fn_shenglvqimeng()             { cat book_shenglvqimeng ;}
function fn_think_fast_n_slow()         { cat book_think_fast_n_slow ;}

function fn_01_商君书()                 { cat book_01_商君书 ;}
function fn_02_韩非子()                 { cat book_02_韩非子 ;}
function fn_aq_如何提问()               { cat book_aq_如何提问 ;}
function fn_yl_你的灯亮着吗()           { cat book_yl_你的灯亮着吗
                                          cat read_yl_你的灯亮着吗 ;}
function fn_lf_雷锋日记()               { cat book_lf_雷锋日记 ;}
function fn_economic_naturalist()       { cat book_economic_naturalist
                                          cat read_economic_naturalist ;}
function fn_10years()                   { cat book_10years ;}
function fn_conservatism()              { cat book_conservatism ;
                                          cat read_conservatism ;}
function fn_f1_富同学穷同学()           { cat book_f1_富同学穷同学 ;}
function fn_f2_海底捞你学不会()         { cat book_f2_海底捞你学不会 ;}
function fn_f3_教父()                   { cat book_f3_教父 ;}
function fn_66_佛语()                   { cat book_66_佛语 ;}

function fn_000_黄晓捷谈在校学习()      { cat book_000_黄晓捷谈在校学习 ;}
function fn_010_李笑来谈读书经验()      { cat book_010_李笑来谈读书经验
                                          cat book_011_李笑来谈阅读操作系统 ;}

function fn_012_李笑来人人都能用英语()  { cat book_012_李笑来人人都能用英语
                                              book_012_李笑来反复通读至少一本语法书
                                              book_012_中文英语非一一对应之处 ;}

function fn_013_李笑来从筷子到开挂人生(){ cat book_013_李笑来从筷子到开挂人生
                                              book_dt_暗时间
                                              book_tf_把时间当作朋友
                                              TIME
                                              xiaolai_cept
                                              xiaolai_Execution_vs_Implementation
                                              FeynmanTechnique
                                        ;}

function fn_100_周鸿祎自述()            { cat book_100_周鸿祎自述 ;}
function fn_101_livermore()             { cat book_101_livermore ;}
function fn_103_雷军的第二个四年()      { cat book_103_雷军的第二个四年 ;}
function fn_104_罗永浩天生骄傲()        { cat book_104_罗永浩天生骄傲 ;}

function fn_200_逃不开的经济周期()      { cat book_200_逃不开的经济周期 ;}
function fn_201_经济学通识()            { cat book_201_经济学通识 ;}
function fn_202_苏黎世投机定律()        { cat book_202_苏黎世投机定律 ;}

function fn_303_论证是一门学问()        { cat book_303_论证是一门学问 howto_argument ;}
function fn_304_金字塔原理()            { cat book_304_金字塔原理 book_py_金字塔原理 ;}

function fn_310_人类简史()              { cat book_310_人类简史 read_310_人类简史 ;}
function fn_311_信息简史()              { cat book_311_信息简史 read_311_信息简史 ;}
function fn_320_失控()                  { cat book_320_失控 ;}

function fn_899_权力的游戏()            { cat book_899_权力的游戏 ;}
function fn_900_平凡的世界()            { cat book_900_平凡的世界 ;}
function fn_tiandao()                   { cat book_tiandao book_遥远的救世主;}
    local opts=(
        cept
        wanna                           # 想读的书
        sunzi                           # 孙子兵法
        laozi                           # 道德经 daodejing
        liutao                          # 六韬.太公兵法
        36ji                            # 36计
        lunyu                           # 论语
        shenglvqimeng                   # 声律启蒙
        tiandao                         # 天道.遥远的救世主
        01_商君书
        02_韩非子
        aq_如何提问                     # reading
        lf_雷锋日记
        yl_你的灯亮着吗                 # light question
        PPT演示之道                     # to read
        economic_naturalist             # 牛奶可乐
        10years                         # 我的职场十年：修炼
        conservatism                    # 保守主义
        think_fast_n_slow

        f2_海底捞你学不会
        f1_富同学穷同学
        f3_教父
        66_佛语

        000_黄晓捷谈在校学习
        010_李笑来谈读书经验
        011_李笑来谈阅读操作系统
        012_李笑来人人都能用英语
        013_李笑来从筷子到开挂人生

        100_周鸿祎自述
        101_livermore
        103_雷军的第二个四年
        104_罗永浩天生骄傲              # kaiwu

        200_逃不开的经济周期
        201_经济学通识                  # xuezhaofeng
        202_苏黎世投机定律

        303_论证是一门学问
        304_金字塔原理

        310_人类简史
        311_信息简史                    # 理解植物
        312_万物简史
        320_失控
        321_混沌：开创新科学

        899_权力的游戏                  # A_Song_of_Ice_and_Fire
        900_平凡的世界
    )
    fn_print $@
}

function fn_music()    	                {
function fn_misc()                      { cat music_misc ;}
function fn_theory()                    { cat music_theory ;}
    local opts=(
        misc
        theory
    )
cat music ;
}

function fn_mindhacks()                 { cat mindhacks ;}
function fn_guang()    	                { cat guang ;}
function fn_poet()    	                { cat poet ;}
function fn_personage()                 { cat personage ;}
function fn_01_囧_jiong()               { cat 01_囧_jiong ;}

function fn_howto()                     {
function fn_01_提高逻辑思维能力()       { cat howto_01_提高逻辑思维能力 ;}
function fn_02_训练思维的深度和缜密度() { cat howto_02_训练思维的深度和缜密度 ;}
function fn_03_沟通_communication()     { cat howto_03_沟通_communication ;}
function fn_04_屌丝如何逆袭()           { cat howto_04_屌丝如何逆袭 ;}
function fn_05_挑选西瓜()               { cat howto_05_挑选西瓜 ;}
    local opts=(
        01_提高逻辑思维能力
        02_训练思维的深度和缜密度
        03_沟通_communication
        04_屌丝如何逆袭
        05_挑选西瓜
    )
    fn_print $@
}

function fn_problem()                   {
function fn_X-Y()                       { cat problem_X-Y ;}
function fn_solving()                   { cat problem_solving ;}
function fn_ask_question()              { cat problem_ask_question ;}
function fn_present()                   { cat problem_present ;}
    local opts=(
        X-Y                             # 问题分类
        solving                         # Howto
        ask_question                    # sometimes，问题产生源自问问题的方式
        present                         # 回归问题本身
    )
    fn_print $@
}

function fn_english()                   {
function fn_US_TV_series()              { cat english_US_TV_series ;}
function fn_vocabulary()                { cat english_vocabulary ;}
function fn_sentence()                  { cat english_sentence ;}
function fn_speaking()                  { cat english_speaking ;}
function fn_listening_layers()          { cat english_listening_layers ;}
function fn_reading()                   { cat english_reading ;}
function fn_interprete()                { cat english_interprete ;}
function fn_interpreting()              { cat english_interpreting ;}
function fn_friends()                   { cat english_friends ;}
function fn_clips()                     { cat english_clips ;}
function fn_Proverbs_in_Alphabet()      { cat english_Proverbs_in_Alphabet ;}
    local opts=(
        Proverbs_in_Alphabet
        clips                           #
        friends                         # 老友记
        US_TV_series                    # 美剧
        vocabulary
        sentence
        speaking
        listening_layers                # 语言的层次
        reading
        interpreting                    # 在电脑上用vi补全对照听写
    )
    fn_print $@
}

function fn_zhihu()                     {
function fn_yolfilm()                   { cat zhihu_yolfilm ;}
function fn_在酒桌上遭人恶意灌酒()      { cat zhihu_在酒桌上遭人恶意灌酒 ;}
function fn_牛人名人再忙也要上知乎？()  { cat zhihu_牛人名人再忙也要上知乎？ ;}
function fn_郭敬明的电影《小时代》？()  { cat zhihu_郭敬明的电影《小时代》？ ;}
    local opts=(
        yolfilm
        在酒桌上遭人恶意灌酒
        牛人名人再忙也要上知乎？
        郭敬明的电影《小时代》？
    )
    fn_print $@
}

function fn_article()                   {
function fn_01_高铁陆权战略()           { cat article_01_高铁陆权战略 ;}
function fn_03_教育的意义()             { cat article_03_教育的意义 ;}
function fn_04_周国平：交往的质量()     { cat article_04_周国平：交往的质量 ;}
function fn_05_whatsfriend()            { cat article_05_whatsfriend ;}
function fn_06_哪些知识会让你变蠢？()   { cat article_06_哪些知识会让你变蠢？ ;}
function fn_07_如何构建经济学思维方式() { cat article_07_如何构建经济学思维方式 ;}
function fn_08_novel()                  { cat article_08_novel ;}

function fn_20_学习学习再学习()         { cat article_20_学习学习再学习
                                          cat article_21_快速学习的几个基本原则
                                          cat article_22_把虚拟变成现实的觉悟
                                          cat article_23_从自我出发做选择的能力 # joc-needed
                                          cat article_24_永葆热情的上瘾式学习法
                                          ;}

function fn_38_我是如何摆脱哑巴英语的() { cat article_38_我是如何摆脱哑巴英语的 ;}
function fn_39_给你把万能钥匙你要不要() { cat article_39_给你把万能钥匙你要不要 ;}
function fn_40_学习批判性思考()         { cat article_40_学习批判性思考 ;}
function fn_41_如何成为高品质的勤奋者() { cat article_41_如何成为高品质的勤奋者;
                                          cat article_41_如何成为高品质的勤奋者2 
                                              article_41_读书的低水平勤奋陷阱 
                                              article_41_你的阅读造就了你
                                          ;}
function fn_42_思考工具及框架()         { cat article_42_思考工具及框架 ;}
function fn_43_如何科学的思考()         { cat article_43_如何科学的思考 ;}
function fn_44_学得太慢是一种罪()       { cat article_44_学得太慢是一种罪 ;}
function fn_45_拷问知识正确和增长遮蔽() { cat article_45_拷问知识正确和增长遮蔽 
                                          cat article_46_学习金字塔的知识留存率
                                          ;}
function fn_50_十种好的学习方式()       { cat article_50_十种好的学习方式 ;}

function fn_51_怎样成为一个高手()       { cat article_51_怎样成为一个高手       # 心得+举例
                                          cat article_52_怎样炼成世界级高手
                                          cat article_55_成为高手之进入高水平反馈
                                          cat article_56_成为高手之缺乏耐心
                                          cat article_57_十分钟读完刻意练习
                                          cat article_58_十分钟读完元认知
                                          ;}

function fn_61_计算思维()               { cat article_61_计算思维 ;}

function fn_71_不自律何自由？()         { cat article_71_不自律何自由？
                                          cat article_72_唯有自律方得自由
                                          cat article_73_尊重事实是自律的第一原则
                                          ;}

function fn_100_人际关系痛苦的根源()    { cat article_100_人际关系痛苦的根源 ;}
function fn_101_分享与慷他人之慨()      { cat article_101_分享与慷他人之慨 ;}
function fn_102_同事是你共享生命的战友(){ cat article_102_同事是你共享生命的战友 ;}
function fn_103_协作跟进？如何跟进？()  { cat article_103_协作跟进？如何跟进？
                                          cat article_104_节奏：论工作中的博弈
                                          ;}

function fn_110_中国哲学体系的困惑？()  { cat article_110_中国哲学体系的困惑？ ;}
function fn_111_喜欢有之或喜欢用之？()  { cat article_111_喜欢有之或喜欢用之？ ;}
function fn_112_我们何需抱怨被误解()    { cat article_112_我们何需抱怨被误解 ;}

function fn_201_“非上帝投机者”的自赎()  { cat article_201_“非上帝投机者”的自赎 ;}

function fn_gsq_房价什么情况下会崩()    { cat article_gsq_房价什么情况下会崩 ;}

    local opts=(
        01_高铁陆权战略
        02_铁道部取消
        03_教育的意义
        04_周国平：交往的质量
        05_whatsfriend
        06_哪些知识会让你变蠢？
        07_如何构建经济学思维方式
        08_novel

        38_我是如何摆脱哑巴英语的
        39_给你把万能钥匙你要不要
        40_学习批判性思考               # 用以致学、阅读本质=填补信息缺口
        41_如何成为高品质的勤奋者
        42_思考工具及框架
        43_如何科学的思考
        44_学得太慢是一种罪
        45_拷问知识正确和增长遮蔽
        50_十种好的学习方式

        51_怎样成为一个高手

        61_计算思维

        71_不自律何自由？
        72_唯有自律方得自由

        100_人际关系痛苦的根源          # 缺乏界限感
        101_分享与慷他人之慨
        102_同事是你共享生命的战友
        103_协作跟进？如何跟进？

        110_中国哲学体系的困惑？
        111_喜欢有之或喜欢用之？
        112_我们何需抱怨被误解

        201_“非上帝投机者”的自赎

        gsq_房价什么情况下会崩          # 股社区
    )
    fn_print $@
}

function fn_value()                     {
function fn_01_传统()                   { cat value_01_传统 ;}
function fn_02_当代()                   { cat value_02_当代 ;}
    local opts=(
        01_传统
        02_当代
    )
    fn_print $@
}

function fn_stevejobs()                 { cat stevejobs ;}
function fn_socrates()                  { cat socrates ;}
function fn_aesthetics()                { cat aesthetics ;}
function fn_tick()                      { cat tick.md ;}

function fn_stk()                       {
function fn_cept()                      { cat stk_cept ;}
function fn_ipo_ops()                   { cat stk_ipo_ops ;}
function fn_ipo_rules()                 { cat stk_ipo_rules ;}
function fn_cost()                      { cat stk_cost ;}
function fn_rzrq()                      { cat stk_rzrq ;}
function fn_tougu()                     { cat stk_tougu ;}
function fn_urls()                      { cat stk_urls ;}
function fn_caorenchao()                { cat stk_caorenchao ;}

function fn_00_技术分析()               { cat stk_00_技术分析 ;}
function fn_01_战术()                   { cat stk_01_战术 ;}
function fn_02_小数据()                 { cat stk_02_小数据 ;}
function fn_03_大数据()                 { cat stk_03_大数据 ;}
function fn_07_牛眼投资法()             { cat stk_07_牛眼投资法 ;}
function fn_11_N_XD_XR_DR()             { cat stk_11_N_XD_XR_DR ;}
function fn_13_除权后的股票难以上涨()   { cat stk_13_除权后的股票难以上涨 ;}
function fn_15_逐笔_分笔_分时_逐单()    { cat stk_15_逐笔_分笔_分时_逐单 ;}

function fn_20_fenbi()                  { cat stk_20_fenbi ;}
function fn_10_dazhihui()               { cat stk_10_dazhihui ;}
function fn_tdx()                       { cat stk_tdx ;}

function fn_jc_这不是独家买卖()         { cat stk_jc_这不是独家买卖 ;}
function fn_jc_Golf智慧_快就是慢()      { cat stk_jc_Golf智慧_快就是慢 ;}
    local opts=(
        ipo_rules
        ipo_ops                         # 新股
        urls
        cost                            # 手续费 佣金
        rzrq                            # 融资融券
        tougu                           # 投顾大赛
        caorenchao                      # 曹仁超

        00_技术分析                         # strategy
        01_战术                         # tactics
        02_小数据                       # 个股 data
        03_大数据                       # macro data
        07_牛眼投资法                   # bulleye

        tdx                             # 通达信 同花顺(ths 10jqka)
        wenhua                          # 文华财经
        TradeBlazer                     # TB
        10_dazhihui                     # dzh 大智慧
        11_N_XD_XR_DR                   # 除权除息
        13_除权后的股票难以上涨
        15_逐笔_分笔_分时_逐单          # DDX 大单
        20_fenbi

        jc_这不是独家买卖
        jc_Golf智慧_快就是慢            # 把目标放在心中；严谨，但不能太认真
    )
    fn_print $@
}

function fn_futures()                   {
function fn_cept()                      { cat futures_cept ;}
    local opts=(
        cept
    )
    fn_print $@
}

function fn_math()                      {
function fn_e_n_log()                   { cat math_e_n_log ;}
function fn_11_magical_70()             { cat math_11_magical_70 ;}
function fn_12_fibonacci_sequence()     { cat math_12_fibonacci_sequence ;}
    local opts=(
        e_n_log                         # 数学常数 对数 指数
        11_magical_70
        12_fibonacci_sequence           # 斐波那契数列
    )
    fn_print $@
}

function fn_why()                       {
function fn_01_为什么拿好人卡()         { cat why_01_为什么拿好人卡 ;}
function fn_02_一朝天子一朝臣()         { cat why_02_一朝天子一朝臣 ;}
    local opts=(
        01_为什么拿好人卡
        02_一朝天子一朝臣
    )
    fn_print $@
}

function fn_films()                     { cat videos movies ;}

function fn_logic()                     {
function fn_cept()                      { cat logic_cept ;}
function fn__essence()                  { cat logic__essence ;}
function fn__struct()                   { cat logic__struct ;}
function fn__1st_principle()            { cat logic__1st_principle
                                          cat book_The_Principle
                                          cat test_The_Principle    #古严：我对《原则》的践行心得
                                          cat love_36_questions
                                          cat 
                                          ;
function fn_training500()               { cat logic_training500 ;}
function fn_puzzle()                    { cat logic_puzzle ;}
function fn_formal()                    { cat logic_formal ;}
function fn_informal()                  { cat logic_informal ;}
function fn_informal_wiki()             { cat logic_informal_wiki ;}
function fn_fallacy()                   { cat logic_fallacy ;}
function fn_language()                  { cat logic_language ;}
function fn_BeingLogical()              { cat logic_BeingLogical ;}
function fn_CognitiveBiases()           { cat logic_CognitiveBiases ;}
function fn_TrapsPitfalls()             { cat logic_TrapsPitfalls ;}
    local opts=(
        cept
        training500
        puzzle                          # 我理解的一些谜
        formal                          #   形式逻辑(普通逻辑)
        informal                        # 非形式逻辑
        informal_wiki                   # 定义
        _essence                        # 本质
        _struct                         # 结构
        _1st_principle                  # 第一原则
        fallacy                         #                      二十四条逻辑谬误
        TrapsPitfalls                   # 逻辑坑
        language                        # 英语逻辑实现
        BeingLogical                    # 简单逻辑学
        CognitiveBiases                 # 认知偏差
    )
    fn_print $@
}

function fn_phi()                       {
function fn_wdf_01_心安之窄门()         { cat phi_wdf_01_心安之窄门 ;}
function fn_wdf_02_国民性()             { cat phi_wdf_02_国民性 ;}
function fn_wdf_03_儒道互补，内方外圆() { cat phi_wdf_03_儒道互补，内方外圆 ;}
function fn_wdf_04_第八意识()           { cat phi_wdf_04_第八意识 ;}
function fn_wdf_05_哲学自由()           { cat phi_wdf_05_哲学自由 ;}
function fn_wdf_06_哲学与其它知识学科() { cat phi_wdf_06_哲学与其它知识学科 ;}
function fn_wdf_07_哲学实践()           { cat phi_wdf_07_哲学实践 ;}
function fn_wdf_08_哲学与知识()         { cat phi_wdf_08_哲学与知识 ;}
function fn_wdf_09_科学之非经验的基础() { cat phi_wdf_09_科学之非经验的基础 ;}
function fn_wdf_10_哲学与世界观关系2()  { cat phi_wdf_10_哲学与世界观关系2 ;}
function fn_wdf_11_哲学入门()           { cat phi_wdf_11_哲学入门 ;}
function fn_wdf_13_理念世界()           { cat phi_wdf_13_理念世界 ;}
function fn_wdf_14_人生理想的证明()     { cat phi_wdf_14_人生理想的证明 ;}
function fn_wdf_15_本体论()             { cat phi_wdf_15_本体论 ;}
function fn_wdf_16_哲学第一命题()       { cat phi_wdf_16_哲学第一命题 ;}
function fn_wdf_17_让思想发现思想()     { cat phi_wdf_17_让思想发现思想 ;}
function fn_wdf_18_语言()               { cat phi_wdf_18_语言 ;}
function fn_wdf_19_范畴是最大的概念()   { cat phi_wdf_19_范畴是最大的概念 ;}
function fn_wdf_20_3大领域的革命()      { cat phi_wdf_20_3大领域的革命 ;}
function fn_wdf_21_精神之自由()         { cat phi_wdf_21_精神之自由 ;}
function fn_wdf_22_精神似一种子()       { cat phi_wdf_22_精神似一种子 ;}
function fn_wdf_23_历史的逻辑预存论()   { cat phi_wdf_23_历史的逻辑预存论 ;}
function fn_wdf_24_理性的智慧遭遇虚无() { cat phi_wdf_24_理性的智慧遭遇虚无 ;}
function fn_wdf_25_上手之于概念()       { cat phi_wdf_25_上手之于概念 ;}
function fn_wdf_26_未言语前已心领神会() { cat phi_wdf_26_未言语前已心领神会 ;}
function fn_wdf_27_人必有一死()         { cat phi_wdf_27_人必有一死 ;}
function fn_wdf_28_终极关怀()           { cat phi_wdf_28_终极关怀 ;}

function fn_flowers12()                 { cat phi_flowers12 ;}
function fn_00_Plato()                  { cat phi_00_Plato ;}
function fn_01_KarlMarx()               { cat phi_01_KarlMarx ;}
function fn_02_Kant()                   { cat phi_02_Kant ;}
function fn_03_Popper()                 { cat phi_03_Popper ;}
function fn_04_Hume()                   { cat phi_04_Hume ;}
function fn_05_Mill()                   { cat phi_05_Mill ;}
function fn_06_Russell()                { cat phi_06_Russell ;}
function fn_07_IsaacNewton()            { cat phi_07_IsaacNewton ;}
function fn_08_Freud()                  { cat phi_08_Freud ;}
function fn_09_Socrates()               { cat phi_09_Socrates ;}
function fn_0a_Miltonfriedman()         { cat phi_0a_Miltonfriedman ;}

function fn_emotion()                   { cat phi_emotion ;}
function fn_relationship()              { cat phi_relationship ;}

function fn_epistemology()              { cat phi_epistemology;
                                          cat phi_brain;
                                          cat phi_ref ;}
function fn_valuetheory()               { cat phi_valuetheory ;}

    local opts=(
        phi_cept                        # 哲学 = 形而上学+伦理学+认识论
        epistemology                    # 认识论+学习+计算机类比+脑科学+theory of knowledge
        valuetheory

        flowers12                       # 哲学12钗
        00_Plato                        # 柏拉图
        01_KarlMarx                     # pelple's本质
        02_Kant                         # Immanuel 康德
        03_Popper                       # 证伪主义 Karl.波普尔
        04_Hume                         # 大卫.休谟
        05_Mill                         # 约翰·斯图亚特·穆勒(也译作·密尔)
        06_Russell                      # Bertrand.罗素
        07_IsaacNewton                  # 1687年他发表《自然哲学的数学原理》
        08_Freud                        # 佛洛伊德.自我.本我.超我
        09_Socrates                     # 苏格拉底-诘问法

        0a_Miltonfriedman               # 米尔顿·弗里德曼

        emotion                         # 人是情绪的动物.Anger.七情六欲
        relationship

        wdf_01_心安之窄门
        wdf_02_国民性
        wdf_03_儒道互补，内方外圆       # 中国文化精神传统的特征
        wdf_04_第八意识
        wdf_05_哲学自由
        wdf_06_哲学与其它知识学科
        wdf_07_哲学实践
        wdf_08_哲学与知识
        wdf_09_科学之非经验的基础
        wdf_10_哲学与世界观关系2
        wdf_11_哲学入门                 # 入哲学之门，先过“区分精神与自然意识”
        wdf_12_
        wdf_13_理念世界
        wdf_14_人生理想的证明
        wdf_15_本体论
        wdf_16_哲学第一命题             # 水是万物的始基
        wdf_17_让思想发现思想
        wdf_18_语言
        wdf_19_范畴是最大的概念
        wdf_20_3大领域的革命            # 哲学、宗教、艺术
        wdf_21_精神之自由
        wdf_22_精神似一种子             # 黑格尔
        wdf_23_历史的逻辑预存论         # 黑格尔
        wdf_24_理性的智慧遭遇虚无
        wdf_25_上手之于概念             # 马克思--实践是一切认知的基础与源泉
        wdf_26_未言语前已心领神会
        wdf_27_人必有一死               # 海伦凯勒 & 乔布斯 & 雷锋 & 保尔柯察金
        wdf_28_终极关怀                 # 宗教之必然
    )
    fn_print $@
}

function fn_huawei()                    {
function fn_to_sort()                   { cat huawei_to_sort ;}
function fn_forum()                     { cat huawei_forum ;}
function fn_cultural()                  { cat huawei_cultural ;}
function fn_account_临行()              { cat huawei_account_临行 ;}
function fn_C语言的限定词()             { cat huawei_C语言的限定词 ;}

function fn_Oracle()                    { cat huawei_Oracle ;}
function fn_OSMU()                      { cat huawei_OSMU ;}
function fn_misc()                      { cat huawei_misc ;}

function fn_Dong_语录()                 { cat huawei_Dong_语录 ;}
function fn_Dong_letter()               { cat huawei_Dong_letter ;}
function fn_Dong_建议大家都去当2b县长() { cat huawei_Dong_建议大家都去当2b县长 ;}
function fn_Dong_【苏格拉底】关于专家() { cat huawei_Dong_【苏格拉底】关于专家 ;}
function fn_Dong_工作如解题解题如抽丝() { cat huawei_Dong_工作如解题解题如抽丝 ;}
function fn_Dong_优良的笔头表达能力()   { cat huawei_Dong_优良的笔头表达能力 ;}
function fn_Dong_研发要我来喂()         { cat huawei_Dong_研发要我来喂 ;}
function fn_Dong_产品经理()             { cat huawei_Dong_产品经理 ;}

function fn_Du_DIY与戴明()              { cat huawei_Du_DIY与戴明 ;}
function fn_Du_提升C代码质量()          { cat huawei_Du_提升C代码质量 ;}
function fn_Du_模块中慎用vmalloc()      { cat huawei_Du_模块中慎用vmalloc ;}
function fn_Du_关于哲学()               { cat huawei_Du_关于哲学 ;}
function fn_Du_企业和军队()             { cat huawei_Du_企业和军队 ;}
function fn_Du_乱弹几点感悟()           { cat huawei_Du_乱弹几点感悟 ;}
function fn_Du_letter1()                { cat huawei_Du_letter1 ;}
function fn_Du_letter2()                { cat huawei_Du_letter2 ;}
function fn_Mo_letter1()                { cat huawei_Mo_letter1 ;}
function fn_Mo_letter2()                { cat huawei_Mo_letter2 ;}

function fn_Zhu_Petimer()               { cat huawei_Zhu_Petimer ;}
function fn_Zhu_雄辩()                  { cat huawei_Zhu_雄辩 ;}
function fn_Qi_领导管理人才()           { cat huawei_Qi_领导管理人才 ;}
function fn_Qi_疾病()                   { cat huawei_Qi_疾病 ;}

function fn_WiMax_meeting()             { cat huawei_WiMax_meeting meeting ;}
    local opts=(
        WiMax_meeting                   # 唯一一次大会
        cultural
        misc                            # 一些哲学、师道
        to_sort                         # 未整理的 ruby valgrind 等
        account_临行                    # 最后一次上传到csdn评论的账号 cu.h
        forum                           # 论坛里的小伙伴
        C语言的限定词

        Oracle
        OSMU                            # 张义强团队

        Du_DIY与戴明                    # Master Du
        Du_提升C代码质量                # 壁垒，根本不在于是否采用OO
        Du_模块中慎用vmalloc            # 多用 _get_free_pages
        Du_企业和军队
        Du_乱弹几点感悟
        Du_关于哲学
        Mo_letter1                      # 来往信件
        Du_letter1
        Mo_letter2
        Du_letter2

        Dong_语录                       #
        Dong_产品经理                   # pm
        Dong_letter                     # 张冬
        Dong_建议大家都去当2b县长
        Dong_【苏格拉底】关于专家       # 【对话苏格拉底】关于专家
        Dong_工作如解题解题如抽丝
        Dong_优良的笔头表达能力
        Dong_研发要我来喂

        Zhu_Petimer                     # 李国柱
        Zhu_雄辩
        Qi_领导管理人才                 # 翟世琦
        Qi_疾病
    )
    fn_print $@
}

function fn_humor()                     {
function fn_Joe()                       { cat humor_Joe ;}
function fn_misc()                      { cat humor_misc ;}
function fn_animals()                   { cat humor_animals ;}
function fn_duanzi()                    { cat humor_duanzi ;}
    local opts=(
        Joe
        misc
        animals
        duanzi
    )
    fn_print $@
}

function fn_girl()                      {
function fn_misc()                      { cat girl_misc ;}
function fn_letters()                   { cat girl_letters juzi ;}
function fn_00_jiebao()                 { cat girl_00_jiebao ;}
function fn_01_tingbao()                { cat girl_01_tingbao ;}
function fn_11_2013相亲记()             { cat girl_11_2013相亲记 ;}
function fn_12_wife()                   { cat girl_12_wife ;}
function fn_100_手把手教你泡妞()        { cat girl_100_手把手教你泡妞 ;}
    local opts=(
        misc
        letters
        11_2013相亲记                   # xiangqin 爱情观
        00_jiebao
        01_tingbao
        12_wife                         # 贤良12妻
        100_手把手教你泡妞
    )
    fn_print $@
}

function fn_prof()                      {
function fn_01_思考一()                 { cat prof_01_思考一 ;}
function fn_11_Geek与产品机器()         { cat prof_11_Geek与产品机器 ;}
    local opts=(
        01_思考一
        11_Geek与产品机器
    )
    fn_print $@
}

function fn_sbfm()                      { cat sbfm ;}

function fn_ljsw()                      {
function fn_voice()                     { cat ljsw_voice ;}
function fn_00_曾国藩()                 { cat ljsw_00_曾国藩 ;}
function fn_01_教育()                   { cat ljsw_01_教育 ;}
function fn_02_傻帽悲观派()             { cat ljsw_02_傻帽悲观派 ;}
function fn_04_民主政治()               { cat ljsw_04_民主政治 ;}
function fn_06_胡适()                   { cat ljsw_06_胡适 ;}
function fn_07_大数据()                 { cat ljsw_07_大数据 ;}
function fn_08_大家都有拖延症()         { cat ljsw_08_大家都有拖延症 ;}
function fn_L0_孤独寂寞朋友()           { cat ljsw_L0_孤独寂寞朋友 ;}

function fn_144_什么是好的经济学()      { cat ljsw_144_什么是好的经济学 ;}
function fn_210_右派为什么这么横()      { cat ljsw_210_右派为什么这么横 ;}
function fn_215_发现你的太平洋()        { cat ljsw_215_发现你的太平洋 ;}

function fn_0802_他拯救了美国？()       { cat ljsw_0802_他拯救了美国？ ;}
function fn_0809_改变世界的箱子()       { cat ljsw_0809_改变世界的箱子 ;}
function fn_0815_费马大定理()           { cat ljsw_0815_费马大定理 ;}
function fn_0822_南明为什么扛不住()     { cat ljsw_0822_南明为什么扛不住 ;}
function fn_0907_纳粹的毒瘾()           { cat ljsw_0907_纳粹的毒瘾 ;}
function fn_0920_3D打印()               { cat ljsw_0920_3D打印 ;}
function fn_0926_领导，你为啥不信我？() { cat ljsw_0926_领导，你为啥不信我？;}
function fn_1003_张勋复辟()             { cat ljsw_1003_张勋复辟 ;}
function fn_1017_外交()                 { cat ljsw_1017_外交 ;}
function fn_1008_怎样炼成世界级高手()   { cat ljsw_1008_怎样炼成世界级高手 ;}
function fn_0521_物种战争()             { cat ljsw_0521_物种战争 ;}
    local opts=(
        voice
        00_曾国藩
        01_教育
        02_傻帽悲观派
        03_成功人士的3个品质            # 优越感、不安全感、自控力
        04_民主政治
        05_格局                         # 琐屑在大小格局中的`避错`与`无能`
        06_胡适                         # 少谈些主义
        07_大数据                       # 大国不可不识数
        08_大家都有拖延症
        51_右派为什么那么横             # 保守派的3个特性
        L0_孤独寂寞朋友                 #

        144_什么是好的经济学
        210_右派为什么这么横
        215_发现你的太平洋              # 创业
        0802_他拯救了美国？
        0809_改变世界的箱子
        0815_费马大定理
        0822_南明为什么扛不住           # 八旗制度 去中心化 海尔创业平台
        0907_纳粹的毒瘾                 # 希特勒
        0920_3D打印                     #
        0926_领导，你为啥不信我？       # 权力
        1003_张勋复辟                   # 权力2
        1017_外交                       # 强国思维
        1008_怎样炼成世界级高手
        0521_物种战争
    )
    fn_print $@
}

function fn_zhenhuan()                  {
function fn_01_曹云金()                 { cat zhenhuan_01_曹云金 ;}
function fn_11_煎饼果子()               { cat zhenhuan_11_煎饼果子 ;}
    local opts=(
        01_曹云金
        11_煎饼果子

    )
    fn_print $@
}

function fn_family()                    {
function fn_00_不滥爱()                 { cat family_00_不滥爱 ;}
function fn_01_王海滨()                 { cat family_01_王海滨 ;}
function fn_02_地图()                   { cat family_02_地图 ;}
function fn_03_为什么现在不相亲()       { cat family_03_为什么现在不相亲 ;}
function fn_04_责任与中年危机()         { cat family_04_责任与中年危机 ;}
    local opts=(
        00_不滥爱                       # thinking for love
        01_王海滨                       # 男人的责任与爱
        02_地图                         # map 家天下
        03_为什么现在不相亲             #
        04_责任与中年危机               # 责任缘自曾经获得帮助

    )
    fn_print $@
}

function fn_ideas()                     { cat ideas ;}
function fn_idealism()                  { cat idealism ;}
function fn_sanxing三省()               { cat sanxing三省 ;}
function fn_rose()                      { cat rose ;}
function fn_interview()                 { cat career 50_faq tek jd interview ;}

function fn_influence()                 {
function fn_cept()                      { cat influence_cept ;}
function fn_agile()                     { cat influence_agile ;}
function fn_sxmm()                      { cat influence_sxmm ;}
function fn_stock()                     { cat influence_stock ;}
    local opts=(
        cept
        agile
        sxmm
        stock                           #
    )
    fn_print $@
}

function fn_economic()                  {
function fn_cept()                      { cat economic_cept ;}
function fn_currency()                  { cat economic_currency ;}
function fn_keynesian()                 { cat economic_keynesian ;}
function fn_fortune()                   { cat economic_fortune ;}
function fn_交易与合约()                { cat economic_交易与合约 ;}
    local opts=(
        cept                            # 利率 汇率 基础概念
        currency                        # 货币经济学
        keynesian                       # 凯恩斯主义经济学
        fortune                         # 古典自由主义 国富论
        交易与合约                      #
    )
    fn_print $@
}

function fn_dream()                     { cat dream ;}

function fn_finance()                   {
function fn_cept()                      { cat finance_cept ;}
function fn_leverage()                  { cat finance_leverage ;}
function fn_fortune()                   { cat finance_fortune ;}
function fn_behavioral()                { cat finance_behavioral ;}
function fn_market()                    { cat finance_market ;}
    local opts=(
        cept                            #
        leverage                        # 杠杆
        behavioral                      # 行为金融学 behavioral finance
        market                          # Yale.open
    )
    fn_print $@
}

function fn_texaspoker()                {
function fn_philosophy()                { cat texaspoker_philosophy ;}
function fn_life()                      { cat texaspoker_life ;}
function fn_xiuxing()                   { cat texaspoker_xiuxing ;}
function fn_emotion_management()        { cat texaspoker_emotion_management ;}
function fn_loser()                     { cat texaspoker_loser ;}
function fn_sng_master()                { cat texaspoker_sng_master ;}
function fn_discipline()                { cat texaspoker_discipline ;}
function fn_trader()                    { cat texaspoker_trader ;}
function fn_goldrules()                 { cat texaspoker_goldrules ;}
function fn_term()                      { cat texaspoker_term ;}
function fn_odds()                      { cat texaspoker_odds ;}
function fn_uncertainty()               { cat texaspoker_uncertainty ;}
function fn_Small_Stakes_Hold_em()      { cat texaspoker_Small_Stakes_Hold_em ;}
    local opts=(
        philosophy                      # 哲理
        xiuxing                         # 修行 意志力 如何稳定盈利？
        emotion_management              # 情绪管理
        loser
        sng_master
        discipline                      # 观察 纪律
        life                            # 生活
        goldrules
        trader                          # 交易员
        uncertainty                     # 不确定性
        term
        odds                            # 成败比 底池成败比
        Small_Stakes_Hold_em
    )
    fn_print $@
}

function fn_psychology() {
function fn_misc()                      { cat psychology_misc ;}
function fn_xiaoxiaoxinxin()            { cat psychology_xiaoxiaoxinxin ;}
function fn_Dongpoyeben()               { cat psychology_Dongpoyeben ;}
function fn_Freud()                     { cat psychology_Freud ;}
    local opts=(
        misc
        xiaoxiaoxinxin                  # 小小歆歆 断舍离 悟破习
        Dongpoyeben                     # 东坡夜奔
        Freud                           # Sigmund.西格蒙德·弗洛伊德
    )
    fn_print $@
}
function fn_guo() {                     # guo
function fn_term()                      { cat guo_term ;}
function fn_think()                     { cat guo_think ;}
function fn_compare()                   { cat guo_compare ;}
function fn_Question()                  { cat guo_Question ;}
function fn_lesson()                    { cat guo_lesson ;}
function fn_rhymeA()                    { cat guo_rhymeA ;}
function fn_rhyme3()                    { cat guo_rhyme3 ;}
function fn_rhyme10()                   { cat guo_rhyme10 ;}
function fn_rhyme30()                   { cat guo_rhyme30 ;}
function fn_rhyme50()                   { cat guo_rhyme50 ;}
function fn_rhyme200()                  { cat guo_rhyme200 ;}
    local opts=(
        rhymeA                          # 凡遇要处总诀
        rhyme3                          # 三字经
        rhyme10                         # 围棋十诀
        rhyme30                         # 入段须知格言三十条
        rhyme50                         # 围棋七字精选50 & 实战布局用语50条
        rhyme200                        # 围棋七字口诀200
        term
        compare                         # vs. 羽毛球.期货
        lesson
        Question
    )
    fn_print $@
}


function fn_writing() {
function fn_format_XiaoLai()            { cat writing_format_XiaoLai ;}
    local opts=(                        # writing
        format_XiaoLai
    )
}

function fn_betterExplained()           {
function fn_ADEPT()                     { cat betterExplained_ADEPT ;}
function fn_feelgood.list()             { cat betterExplained_feelgood.list ;}
function fn_ideas.list()                { cat betterExplained_ideas.list ;}
    local opts=(
        ADEPT
        feelgood.list
        ideas.list
    )

    return $?
}

function fn_game_theory()               { cat game_theory ;}
function fn_debate_competition()        { cat debate_competition ;}
function fn_super_speech()              { cat super_speech luoyonghao ;}
function fn_advertisement()             { cat advertisement ;}
function fn_architecture()              { cat architecture ;}
function fn_estate()                    { cat estate ;}
function fn_driver()                    { cat driver ;}
function fn_cold()                      { cat cold ;}
function fn_sport()                     { cat sport ;}
function fn_stupid_things()             { cat stupid_things ;}
function fn_subtitle()                  { cat subtitle ;}
function fn_kindle()                    { cat kindle ;}
function fn_literature()                { cat literature ;}


# 新教与天主教。信则得救，不信则下地狱 vs 助人行善
# 一花一世界，一木一浮生，一草一天堂，一叶一如来，
# 一砂一极乐，一方一净土，一笑一尘缘，一念一清静
function fn_main() {
    local opts=(
        interview                       # 想想自己的价值？
        01_囧_jiong                     # sleep
        cold                            # 感冒 牙痛 智齿 sick
        architecture                    # 建筑
        advertisement
        aesthetics                      # i:s`θetic 美学
        estate                          # 房地产
        phi                             # philosophy
        logic
        alibaba
        annual
        article
        book
        debate_competition
        super_speech
        dream
        driver
        english
        economic
        finance
        faith
        family                          # 难念的经 家国天下
        girl
        guang
        guo                             # 碁
        huawei
        humor                           # 幽默
        herb                            # 中医
        howto
        ideas
        idealism                        # 理想主义
        influence                       # 三十而立 影响力 30
        poet
        math                            # 数
        mng
        mindhacks
        ljsw                            # 罗辑思维
        sbfm                            # 上兵伐谋
        music
        personage
        problem                         # 问题
        prof                            # professionalism 专业主义 职业化
        stevejobs
        socrates                        # Socrates 苏格拉底 诘问
        sport                           # badmiton 羽毛球
        stk
        futures                         # futures trading 期货
        texaspoker                      # texas_hold_em
        tick
        value                           # 价值
        why
        rose                            #
        zhihu
        zhenhuan                        # 甄嬛体
        sanxing三省
        life_is_a_bus                   # 公交车
        game_theory
        redwine
        stupid_things                   # 哪些年做过的蠢事 habit
        subtitle
        psychology                      # 心理学
        kindle
        writing
        chaos
        literature                      # 文学

        betterExplained
        meditation_cept
        psychology_cept
        education_cept                  # 教育
        practice_cept                   # 直接成一个文本
        science_cept                    # 科学之哲学
        wangzeq_cept
        fertile_cept                    # 有繁殖能力的知识
        analogy_cept
        misc_cept
        Arts_cept
        meta_cept                       # 元认知
        TAO                             # 存在的属性
    )
    fn_print $@
}

fn_main $@
