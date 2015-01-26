    -- 原本欲计算`资金`流向，
    -- 但是，只有大资金才需要谋局，资金流向的累计阶段的升幅有限，
    -- 最大的成本还在于时间成本。 

    DECLARE v_pchng     DECIMAL(6,2) DEFAULT 0;     -- price chang
    DECLARE v_pchng_acc DECIMAL(6,2) DEFAULT 0;     -- 累计
    DECLARE v_achng     DECIMAL(6,2) DEFAULT 0;     -- avrg price chang
    DECLARE v_achng_acc DECIMAL(6,2) DEFAULT 0;     -- 累计
    DECLARE v_netv      DECIMAL(6,2) DEFAULT 0;     -- 净值
    DECLARE v_netv_acc  DECIMAL(6,2) DEFAULT 0;     -- 累计
    DECLARE v_RoNetv    DECIMAL(6,2) DEFAULT 0;     -- 每股累计净值
    DECLARE v_RoNP      DECIMAL(6,2) DEFAULT 0;     -- 每股累计净值/price
    DECLARE v_RoPA      DECIMAL(6,2) DEFAULT 0;     -- price / v_achng_acc

