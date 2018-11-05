# SYNOPSIS

iptables -t 表名 <-A/I/D/R> 规则链名 [规则号] 
         <-i/o 网卡名> -p 协议名 
         <-s 源IP/源子网> --sport 源端口 
         <-d 目标IP/目标子网> --dport 目标端口 -j 动作

规则链名(rule-specification) = [matches...] [target]
match                        = -m matchname [per-match-options]
target                       = -j targetname [per-target-options]

# LIST

iptables -L -n --line-numbers       # --line also OK

# CHAIN

iptables -t nat -N SHADOWSOCKS      # nat表中新增
iptables -t nat -X SHADOWSOCKS      # nat表中删除，必须无reference
iptables -t nat -F SHADOWSOCKS      # nat表清空rule
iptables -t nat -E SHADOWSOCKS ss   # 重命名
iptables -t nat -S SHADOWSOCKS      # printed like iptables-save

# RULE

iptables [-t tbl] -I chain [rulenum] rule-specification # 插入
iptables [-t tbl] -R chain rulenum   rule-specification # 替换
iptables [-t tbl] {-A|-C}    chain   rule-specification # APPEND|CHECK
iptables -t nat   -D SHADOWSOCKS     1                  # 链SHADOWSOCKS中删除rule.1

