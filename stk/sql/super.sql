delimiter //

DROP PROCEDURE IF EXISTS sp_create_tempday //
CREATE PROCEDURE sp_create_tempday() tag_tempday:BEGIN 
    DROP   TEMPORARY TABLE IF EXISTS tempday;
    CREATE TEMPORARY TABLE tempday (
 -- DROP   TABLE IF EXISTS tempday;
 -- CREATE TABLE tempday (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date        date NOT NULL,
        yesc        DECIMAL(6,2) NOT NULL,
        open        DECIMAL(6,2) NOT NULL,
        high        DECIMAL(6,2) NOT NULL,
        low         DECIMAL(6,2) NOT NULL,
        close       DECIMAL(6,2) NOT NULL,
        volume      DECIMAL(12,2)NOT NULL,
        amount      DECIMAL(12,2)NOT NULL DEFAULT 0,
        INDEX(date)
    );
   #)engine memory;
END tag_tempday //

DROP PROCEDURE IF EXISTS sp_create_tbl_super //
CREATE PROCEDURE sp_create_tbl_super() tag_tbl_super:BEGIN
    DROP   TABLE IF EXISTS tbl_super;
    CREATE TABLE tbl_super (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date        date NOT NULL DEFAULT 0,
        off_p       INT  NOT NULL DEFAULT 0,
        tnov_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        avrg_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- previous 
        ratio       DECIMAL(6,2) NOT NULL DEFAULT 0,
        wchng       DECIMAL(6,2) NOT NULL DEFAULT 0
    );
END tag_tbl_super //

DROP PROCEDURE IF EXISTS sp_super//
CREATE PROCEDURE sp_super(a_code INT(6) ZEROFILL) tag_super:BEGIN
    -- super
    DECLARE v_id        INT DEFAULT 1; 
    DECLARE v_num_unit  INT DEFAULT 0; 
    DECLARE v_nextid    INT DEFAULT 1; 
    DECLARE v_got_next  INT DEFAULT 1; 
    DECLARE v_part      INT DEFAULT 1; 
    DECLARE v_off_c     INT DEFAULT 1; 
    DECLARE v_off_p     INT DEFAULT 1; 

    DECLARE v_close     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_yesc      DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ratio     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_wchng     DECIMAL(6,2) DEFAULT 0;

    DECLARE v_pchng     DECIMAL(6,2) DEFAULT 0;     -- price chang
    DECLARE v_pchng_acc DECIMAL(6,2) DEFAULT 0;     -- 累计
    DECLARE v_achng     DECIMAL(6,2) DEFAULT 0;     -- avrg price chang
    DECLARE v_achng_acc DECIMAL(6,2) DEFAULT 0;     -- 累计
    DECLARE v_netv      DECIMAL(6,2) DEFAULT 0;     -- 净值
    DECLARE v_netv_acc  DECIMAL(6,2) DEFAULT 0;     -- 累计
    DECLARE v_RoNetv    DECIMAL(6,2) DEFAULT 0;     -- 每股累计净值
    DECLARE v_RoNP      DECIMAL(6,2) DEFAULT 0;     -- 每股累计净值/price
    DECLARE v_RoPA      DECIMAL(6,2) DEFAULT 0;     -- price / v_achng_acc

    DECLARE v_avrg      DECIMAL(8,2) DEFAULT 0;
    DECLARE v_avrg0     DECIMAL(8,2) DEFAULT 0;
    DECLARE v_avrg_c    DECIMAL(8,2) DEFAULT 0;
    DECLARE v_avrg_p    DECIMAL(8,2) DEFAULT 0;

    DECLARE v_date      DATE DEFAULT NULL;
    DECLARE v_date_c    DATE DEFAULT NULL;
    DECLARE v_date_p    DATE DEFAULT NULL;

    DECLARE v_turnov    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_tnov_c    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_tnov_p    DECIMAL(12,2) DEFAULT 0;

    DECLARE v_shares    INT DEFAULT 0;
    DECLARE v_shares0   INT DEFAULT 0;
    DECLARE v_volume    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_vol_unit  DECIMAL(12,2) DEFAULT 0;
    DECLARE v_amount    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_sumvolume DECIMAL(12,2) DEFAULT 0;
    DECLARE v_sumamount DECIMAL(12,2) DEFAULT 0;

    DECLARE v_vol_more  DECIMAL(12,2) DEFAULT 0;
    DECLARE v_amt_more  DECIMAL(12,2) DEFAULT 0;

    call sp_create_tempday();
    SELECT nmc/close FROM cap WHERE code=a_code LIMIT 1 INTO v_shares;
    SET v_shares0 = v_shares * @NMC_RATIO;
    SET v_vol_unit = v_shares0/@PARTS;
    SET @sqls=concat('
        INSERT INTO tempday(code,date,yesc,open,high,low,close,volume,amount)
        SELECT code,date,yesc,open,high,low,close,volume,amount FROM day WHERE code=', 
        a_code, " and date>= '", @START, "' order by date ASC"); --  LIMIT ", @NUM);
    PREPARE stmt from @sqls; EXECUTE stmt;

    SELECT count(*), sum(volume) FROM tempday INTO @v_len, @v_volumes;

    -- 换手不足的个股


    -- SELECT v_id,v_date,v_volume,v_vol_unit,v_amount;

    lbl_upto_100: WHILE v_id <= @v_len DO
        SELECT date,yesc,close,volume,amount FROM tempday WHERE id=(v_id)
            INTO v_date,v_yesc,v_close,v_volume,v_amount;
        SET v_sumvolume = v_sumvolume + v_volume;
        SET v_sumamount = v_sumamount + v_amount;
        -- SELECT  v_sumvolume,v_sumamount;
        -- upto 100% turnover
        IF  v_sumvolume >= v_shares0 THEN 

            SET v_avrg0 = (v_amount/v_volume);
            SET v_vol_more = v_sumvolume - v_shares0;
            SET v_amt_more = v_vol_more * v_avrg0;

            -- 每个upto_100%的部分都被减掉
            SET v_avrg = (v_sumamount-v_amt_more)/v_shares0;
            SET v_turnov = 100*v_sumvolume/v_shares;

            -- 将周期curr多余的量存入周期prev
            SET v_sumvolume = v_vol_more;
            SET v_sumamount = v_amt_more;

            IF  @v_got_100 = 0 THEN 
                SET @v_got_100 = 1;
                SET v_avrg_c    = v_avrg;
                SET v_tnov_c    = v_turnov;
                SET v_off_c     = v_id;
                SET v_date_c    = v_date;
                SET v_wchng     = 100 * (v_close-v_avrg_c)/v_avrg_c;
            ELSE
                SELECT date FROM tempday WHERE id=(v_off_c+1) INTO v_date;
                SET @v_got_100 = 2;
                SET v_avrg_p    = v_avrg;
                SET v_tnov_p    = v_turnov;
                SET v_off_p     = v_id - v_off_c;
                SET v_date_p    = v_date;

                SET v_ratio     = 100 * (v_avrg_c-v_avrg_p) / v_avrg_c;
                INSERT INTO tbl_super(code,  date_p,off_p,avrg_p,tnov_p, 
                                            date_c,off_c,avrg_c,tnov_c,ratio,wchng)
                         VALUES(a_code,   v_date_p,v_off_p,v_avrg_p,v_tnov_p, 
                                          v_date_c,v_off_c,v_avrg_c,v_tnov_c,v_ratio,v_wchng);

                LEAVE lbl_upto_100;
            END IF;
        END IF;

        SET v_id = v_id+1;
        SELECT volume,amount FROM tempday WHERE id=(v_id) INTO v_volume,v_amount;
        SET v_sumvolume = v_sumvolume + v_volume;
        SET v_sumamount = v_sumamount + v_amount;
        IF  v_got_next = 0 AND v_sumvolume >= v_vol_unit THEN 
            SET v_nextid = v_id+1;
            SET v_got_next = 1;
        END IF;

    END WHILE lbl_upto_100;

  --  SELECT * FROM tempday LIMIT 100;
  --  SELECT v_part;

END tag_super //

DROP PROCEDURE IF EXISTS sp_visit_code//
CREATE PROCEDURE sp_visit_code(a_code INT(6) ZEROFILL) tag_vcode:BEGIN
    -- prepare
    call sp_create_tbl_super();
    -- do
    call sp_super(a_code);
END tag_vcode //

SET @END='2015-01-16';
SET @NUM=300;
SET @PARTS=20;
SET @PPLUS=5;
SET @NMC_RATIO=1;

# call sp_visit_code(300104);
