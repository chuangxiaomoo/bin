#! /bin/bash

ubt=192.168.2.41
ARCHIVE=~/bin/.m2doc/
 . ${ARCHIVE}.pri.bashrc
cd ${ARCHIVE}

function fn_herb()                      {
function fn_5邪()                       { cat herb_5邪 ;}
    local opts=(
        5邪
        case                            # 叶天士 临症指南
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
function fn_2012_report()               { cat annual_2012_report ;}
function fn_2012_seminar()              { cat annual_2012_seminar ;}
function fn_2013_seminar()              { cat annual_2013_seminar ;}
function fn_2013_report()               { cat annual_2013_report ;}
function fn_2013_life()                 { cat annual_2013_life ;}
function fn_2014_plan()                 { cat annual_2014_plan ;}
function fn_2014_spring_festival()      { cat annual_2014_spring_festival ;}
function fn_2014_jco()                  { cat annual_2014_jco ;}
    local opts=(
        plan_what                       # 基于`以终为始`的理念
        report_what
        seminar_what
        2011_investment_report
        2012_report
        2012_seminar
        2013_seminar
        2013_plan
        2013_report
        2013_life                       # 财务报表
        2014_plan                       # `多算胜，少算不胜`
        2014_spring_festival
        2014_jco
    )
    fn_print $@
}

#
# Just like brain sort knowledge always, we need sort contineuously!
# a book can append with a reflect
#
function fn_book()                      { 
function fn_base()                      { cat book_base ;}
function fn_wanna()                     { cat book_wanna ;}
function fn_01_商君书()                 { cat book_01_商君书 ;}
function fn_02_韩非子()                 { cat book_02_韩非子 ;}
function fn_aq_如何提问()               { cat book_aq_如何提问 ;}
function fn_dt_暗时间()                 { cat book_dt_暗时间 ;}
function fn_tf_把时间当作朋友()         { cat book_tf_把时间当作朋友;
                                          cat TIME
                                          cat read_tf_把时间当作朋友 ;}
function fn_yl_你的灯亮着吗()           { cat book_yl_你的灯亮着吗 
                                          cat read_yl_你的灯亮着吗 ;}
function fn_lf_雷锋日记()               { cat book_lf_雷锋日记 ;}
function fn_py_金字塔原理()             { cat book_py_金字塔原理 ;}
function fn_economic_naturalist()       { cat book_economic_naturalist 
                                          cat read_economic_naturalist ;}
function fn_10years()                   { cat book_10years ;}
function fn_conservatism()              { cat book_conservatism ;
                                          cat read_conservatism ;} 
function fn_f1_富同学穷同学()           { cat book_f1_富同学穷同学 ;}
    local opts=(
        base       
        wanna                   # 想读的书
        01_商君书
        02_韩非子
        aq_如何提问             # reading
        dt_暗时间               # darktime
        lf_雷锋日记
        tf_把时间当作朋友       # make time a friend
        yl_你的灯亮着吗         # light question
        py_金字塔原理           # reading
        PPT演示之道             # to read
        economic_naturalist     # 牛奶可乐
        10years                 # 我的职场十年：修炼
        conservatism            # 保守主义

        f1_富同学穷同学
    )
    fn_print $@

}

function fn_mindhacks()                 { cat mindhacks ;}
function fn_guang()    	                { cat guang ;}
function fn_words()    	                { cat words ;}
function fn_music()    	                { cat music ;}
function fn_poet()    	                { cat poet ;}
function fn_english()                   { cat english ;}
function fn_personage()                 { cat personage ;}
function fn_meeting()                   { cat meeting ;}
function fn_01_囧_jiong()               { cat 01_囧_jiong ;}
function fn_02_如何解题()               { cat 02_如何解题 ;}

function fn_howto()                     { 
function fn_01_提高逻辑思维能力()       { cat howto_01_提高逻辑思维能力 ;}
function fn_02_训练思维的深度和缜密度() { cat howto_02_训练思维的深度和缜密度 ;}
function fn_03_沟通_communication()     { cat howto_03_沟通_communication ;}
function fn_04_屌丝如何逆袭()           { cat howto_04_屌丝如何逆袭 ;}

    local opts=(
        01_提高逻辑思维能力
        02_训练思维的深度和缜密度
        03_沟通_communication
        04_屌丝如何逆袭
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

function fn_artical()                   { 
function fn_01_高铁陆权战略()           { cat artical_01_高铁陆权战略 ;}
function fn_03_教育的意义()             { cat artical_03_教育的意义 ;}
function fn_04_周国平：交往的质量()     { cat artical_04_周国平：交往的质量 ;}
    local opts=(
        01_高铁陆权战略
        02_铁道部取消
        03_教育的意义
        04_周国平：交往的质量
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
function fn_ipo_base()                  { cat stk_ipo_base ;}
function fn_ipo_rules()                 { cat stk_ipo_rules ;}
function fn_urls()                      { cat stk_urls ;}
function fn_todo()                      { cat stk_todo ;}
function fn_icase()                     { cat stk_icase ;}
function fn_base()                      { cat stk_base ;}
function fn_tougu()                     { cat stk_tougu ;}
function fn_xuxiaoming()                { cat stk_xuxiaoming ;}
function fn_caorenchao()                { cat stk_caorenchao ;}
function fn_screener()                  { cat stk_screener ;}
function fn_00_战略()                   { cat stk_00_战略 ;}
function fn_01_战术()                   { cat stk_01_战术 ;}
function fn_02_小数据()                 { cat stk_02_小数据 ;}
function fn_03_大数据()                 { cat stk_03_大数据 ;}
function fn_04_马云启示录()             { cat stk_04_马云启示录 ;}
function fn_06_决策心理学()             { cat stk_06_决策心理学 ;}
function fn_07_牛眼投资法()             { cat stk_07_牛眼投资法 ;}
function fn_09_银江()                   { cat stk_09_银江 ;}
function fn_10_dazhihui()               { cat stk_10_dazhihui ;}
function fn_11_N_XD_XR_DR()             { cat stk_11_N_XD_XR_DR ;}
function fn_12_手续费()                 { cat stk_12_手续费 ;}
function fn_13_除权后的股票难以上涨()   { cat stk_13_除权后的股票难以上涨 ;}
function fn_14_公告()                   { cat stk_14_公告 ;}
function fn_15_逐笔_分笔_分时_逐单()    { cat stk_15_逐笔_分笔_分时_逐单 ;}

function fn_20_fenbi()                  { cat stk_20_fenbi ;}

function fn_jc_行为金融学()             { cat stk_jc_行为金融学 ;}
function fn_jc_人皆患失()               { cat stk_jc_人皆患失 ;}
function fn_jc_这不是独家买卖()         { cat stk_jc_这不是独家买卖 ;}
function fn_jc_Golf智慧_快就是慢()      { cat stk_jc_Golf智慧_快就是慢 ;}

function fn_rzrq()                      { cat stk_rzrq ;}

    local opts=(
        ipo_base                        # 新股
        ipo_rules

        urls
        todo
        icase
        base                            # 交易规则
        rzrq                            # 融资融券
        tougu                           # 投顾大赛
        caorenchao                      # 曹仁超
        xuxiaoming                      # 徐小明
        screener                        # 筛选器设计

        00_战略                         # strategy
        01_战术                         # tactics
        02_小数据                       # 个股 data 
        03_大数据                       # macro data
        04_马云启示录                   # 还是大数据 
        06_决策心理学                   # decide
        07_牛眼投资法                   # bulleye

        09_银江
        10_dazhihui                     # dzh 大智慧
        11_N_XD_XR_DR                   # 除权除息
        12_手续费                       # cost
        13_除权后的股票难以上涨
        14_公告                         # 利润分配
        15_逐笔_分笔_分时_逐单          # DDX 大单

        20_fenbi

        jc_行为金融学                   # behavioral finance
        jc_人皆患失                     # 决策小分队
        jc_这不是独家买卖
        jc_Golf智慧_快就是慢            # 把目标放在心中；严谨，但不能太认真
    )
    fn_print $@
}

function fn_futures()                   {  
function fn_base()                      { cat futures_base ;}

    local opts=(
        base
    )
    fn_print $@
}

function fn_math()                      { 
function fn_e_n_log()                   { cat math_e_n_log ;}
function fn_11_magical_70()             { cat math_11_magical_70 ;}
function fn_12_fibonacci_sequence()     { cat math_12_fibonacci_sequence ;}
    local opts=(
        base       
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

function fn_movie()                     { 
function fn_01_Akkila与拼字大赛()       { cat movie_01_Akkila与拼字大赛 ;}
    local opts=(
        01_Akkila与拼字大赛
    )
    fn_print $@
}

function fn_phi()                       { 
function fn_flowers12()                 { cat phi_flowers12 ;}
function fn_01_马克思()                 { cat phi_01_马克思 ;}
function fn_02_康德()                   { cat phi_02_康德 ;}
function fn_03_波普尔()                 { cat phi_03_波普尔 ;}
function fn_freudian()                  { cat phi_freudian ;}
function fn_emotion()                   { cat phi_emotion ;}
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
function fn_epistemology()              { cat phi_epistemology ;}
    local opts=(
        01_马克思
        02_康德
        03_波普尔                       # 证伪主义
        freudian                        # 自我 本我 超我
        emotion                         # Anger 七情六欲

        epistemology                    # 知识论

        flowers12                       # 哲学12钗

        wdf_00                          # 王德峰
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
    local opts=(
        cultural
        misc                            # 一些哲学 
        to_sort                         # 未整理的 ruby python valgrind 等
        account_临行                    # 最后一次上传到csdn评论的账号 cu.h
        forum                           # 论坛里的小伙伴
        C语言的限定词

        Oracle
        OSMU                            # 张义强团队

        Du_DIY与戴明                    # Master Du
        Du_提升C代码质量                # 壁垒，根本不在于是否采用OO 
        Du_模块中慎用vmalloc            # 多用__get_free_pages
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

function fn_humor()                     { cat humor ;}

function fn_girl()                      {
function fn_base()                      { cat girl_base ;}
function fn_lovewords()                 { cat girl_lovewords ;}
function fn_00_jiebao()                 { cat girl_00_jiebao ;}
function fn_01_tingbao()                { cat girl_01_tingbao ;}
function fn_11_2013相亲记()             { cat girl_11_2013相亲记 ;}
function fn_12_wife()                   { cat girl_12_wife ;}
    local opts=(
        base       
        lovewords
        00_jiebao
        01_tingbao
        11_2013相亲记
        12_wife                         # 贤良12妻
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
function fn_01_教育()                   { cat ljsw_01_教育 ;}
function fn_02_傻帽悲观派()             { cat ljsw_02_傻帽悲观派 ;}
function fn_04_民主政治()               { cat ljsw_04_民主政治 ;}
function fn_06_胡适()                   { cat ljsw_06_胡适 ;}
function fn_07_大数据()                 { cat ljsw_07_大数据 ;}
function fn_08_大家都有拖延症()         { cat ljsw_08_大家都有拖延症 ;}

function fn_210_右派为什么这么横()      { cat ljsw_210_右派为什么这么横 ;}
function fn_215_发现你的太平洋()        { cat ljsw_215_发现你的太平洋 ;}

function fn_x1_你的阅读造就了你()       { cat ljsw_x1_你的阅读造就了你 ;}
    local opts=(
        voice
        01_教育
        02_傻帽悲观派
        03_成功人士的3个品质            # 优越感、不安全感、自控力
        04_民主政治
        05_格局                         # 琐屑在大小格局中的`避错`与`无能`
        06_胡适                         # 少谈些主义
        07_大数据                       # 大国不可不识数
        08_大家都有拖延症
        51_右派为什么那么横             # 保守派的3个特性
        x1_你的阅读造就了你             # you are what u read

        210_右派为什么这么横
        215_发现你的太平洋              # 创业
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
function fn_01_王海滨()                 { cat family_01_王海滨 ;}
    local opts=(
        01_王海滨                       # 男人的责任与爱
    )
    fn_print $@
}

function fn_ideas()                     { cat ideas ;}
function fn_idealism()                  { cat idealism ;}
function fn_sanxing三省()               { cat sanxing三省 ;}
function fn_yufen()                     { cat yufen ;}
function fn_50_interview_faq()          { cat 50_interview_faq ;}
function fn_traffic()                   { cat traffic ;}

function fn_influence()                 {
function fn_base()                      { cat influence_base ;}
function fn_agile()                     { cat influence_agile ;}
function fn_sxmm()                      { cat influence_sxmm ;}
function fn_stock()                     { cat influence_stock ;}
    local opts=(
        base
        agile
        sxmm
        stock                           # 
    )
    fn_print $@
}

function fn_finance()                   {
function fn_base()                      { cat finance_base ;}
function fn_leverage()                  { cat finance_leverage ;}
function fn_fortune()                   { cat finance_fortune ;}
    local opts=(
        base                            # 利率 汇率 基础概念
        leverage                        # 杠杆
        fortune                         # 财富
    )
    fn_print $@
}

# 新教与天主教。信则得救，不信则下地狱 vs 助人行善
# 一花一世界，一木一浮生，一草一天堂，一叶一如来，
# 一砂一极乐，一方一净土，一笑一尘缘，一念一清静
function fn_main() {
    local opts=(
        50_interview_faq                # 想想自己的价值？
        01_囧_jiong
        02_如何解题                     # how to solve it, problem_solving
        aesthetics                      # i:s`θetic 美学
        phi                             # philosophy
        annual
        artical
        book
        english
        finance                         # economic
        faith
        family                          # 难念的经
        girl
        guang
        huawei
        humor                           # 幽默
        herb                            # 中医
        howto
        ideas
        idealism                        # 理想主义
        influence                       # 三十而立 影响力 30 
        poet
        math                            # 数
        meeting
        mng
        mindhacks
        ljsw                            # 罗辑思维
        sbfm                            # 上兵伐谋 
        movie
        music
        personage
        prof                            # professionalism 专业主义 职业化
        stevejobs
        socrates                        # Socrates 苏格拉底 诘问
        stk
        futures                         # futures trading 期货
        tick
        traffic
        value                           # 价值
        why
        words
        yufen
        zhihu
        zhenhuan        # 甄嬛体
        sanxing三省
    )
    fn_print $@
}

fn_main $@
