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

DROP PROCEDURE IF EXISTS sp_create_tbl_acc //
CREATE PROCEDURE sp_create_tbl_acc() tag_tbl_acc:BEGIN
    DROP   TABLE IF EXISTS tbl_acc;
    CREATE TABLE tbl_acc (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date_p      date NOT NULL DEFAULT 0,
        date_c      date NOT NULL DEFAULT 0,
        off_p       INT  NOT NULL DEFAULT 0,
        off_c       INT  NOT NULL DEFAULT 0,
        tnov_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        tnov_c      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        avrg_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- previous 
        avrg_c      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- curr avrg = sum(amount) / sum(volume)
        ratio       DECIMAL(6,2) NOT NULL DEFAULT 0,
        wchng       DECIMAL(6,2) NOT NULL DEFAULT 0
    );
    DROP   TABLE IF EXISTS tbl_adiff;
    CREATE TABLE IF NOT EXISTS tbl_adiff (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date_p      date NOT NULL DEFAULT 0,
        date_c      date NOT NULL DEFAULT 0,
        off_p       INT  NOT NULL DEFAULT 0,
        off_c       INT  NOT NULL DEFAULT 0,
        tnov_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        tnov_c      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        avrg_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- previous 
        avrg_c      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- curr avrg = sum(amount) / sum(volume)
        ratio       DECIMAL(6,2) NOT NULL DEFAULT 0,
        wchng       DECIMAL(6,2) NOT NULL DEFAULT 0,
        rdiff       DECIMAL(6,2) NOT NULL DEFAULT 0,
        dbrat       DECIMAL(6,2) NOT NULL DEFAULT 0 
    );
END tag_tbl_acc //

DROP PROCEDURE IF EXISTS sp_acc//
CREATE PROCEDURE sp_acc(a_code INT(6) ZEROFILL) tag_acc:BEGIN
    -- acc
    DECLARE v_id        INT DEFAULT 1; 
    DECLARE v_num_unit  INT DEFAULT 0; 
    DECLARE v_nextid    INT DEFAULT 1; 
    DECLARE v_got_next  INT DEFAULT 1; 
    DECLARE v_part      INT DEFAULT 1; 
    DECLARE v_off_c     INT DEFAULT 1; 
    DECLARE v_off_p     INT DEFAULT 1; 

    DECLARE v_close     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ratio     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_wchng     DECIMAL(6,2) DEFAULT 0;

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
    -- 可以通过 turnover = latest(volume/shares); 来计算相应日期数 @NUM
    SET @sqls=concat('
        INSERT INTO tempday(code,date,yesc,open,high,low,close,volume,amount)
        SELECT code,date,yesc,open,high,low,close,volume,amount FROM day WHERE code=', 
        a_code, " and date<= '", @END, "' order by date DESC"); --  LIMIT ", @NUM);
    PREPARE stmt from @sqls; EXECUTE stmt;

    SELECT count(*), sum(volume) FROM tempday INTO @v_len, @v_volumes;

    -- 换手不足的个股
    IF @v_volumes < v_shares0*(2+@PPLUS/@PARTS) THEN 
        SELECT  @v_volumes, 
                round(v_shares0*(2+@PPLUS/@PARTS),2) as volNeed, 
                TRUNCATE((@v_volumes/v_shares0-2)*@PARTS, 0) as maxPPLUS;
        -- SELECT a_code, @END, @NUM, "so_little_acc_data";
        INSERT INTO exitcode VALUES (1);
        LEAVE tag_acc; 
    END IF;


  lbl_upto_parts: WHILE v_part <= (@PARTS+@PPLUS) DO
    SET v_got_next = 0;
    SELECT date,close,volume,amount FROM tempday WHERE id=(v_id)
            INTO v_date,v_close,v_volume,v_amount;

    -- SELECT v_id,v_date,v_volume,v_vol_unit,v_amount;

    IF v_volume > v_vol_unit THEN  -- 大换手数据
        SET v_got_next = 1;
        SET v_avrg0 = (v_amount/v_volume);
        SET v_volume = v_volume - (v_vol_unit * v_num_unit);
        SET v_amount = v_avrg0*v_volume;
        -- SELECT "IN branch", v_volume,v_amount,v_num_unit;
        IF v_volume <= v_vol_unit THEN                            -- 最后一部分
            SET v_num_unit = 0;
            SET v_nextid = v_id+1;
        ELSE
            SET v_num_unit = v_num_unit+1;
        END IF;
    END IF;

    SET v_sumvolume = v_volume;
    SET v_sumamount = v_amount;
    SET @v_got_100 = 0;

    lbl_upto_100: WHILE v_id <= @v_len DO
        -- SELECT  v_sumvolume,v_sumamount;
        -- upto 100% turnover
        IF  v_sumvolume >= v_shares0 THEN 

            SET v_avrg0 = (v_amount/v_volume);
            SET v_vol_more = v_sumvolume - v_shares0;
            SET v_amt_more = v_vol_more * v_avrg0;

            SET v_avrg = (v_sumamount-v_amt_more)/v_shares0;
            SET v_turnov = 100*v_sumvolume/v_shares;

            SET v_sumvolume = v_vol_more;
            SET v_sumamount = v_amt_more;

            -- SELECT "got v_got_100",v_id, v_num_unit,v_date,v_turnov;

            IF  @v_got_100 = 0 THEN 
                SET @v_got_100 = 1;
                SET v_avrg_c    = v_avrg;
                SET v_tnov_c    = v_turnov;
                set v_off_c     = v_id;
                set v_date_c    = v_date;
                SET v_wchng     = 100 * (v_close-v_avrg_c)/v_avrg_c;
            ELSE
                SELECT date FROM tempday WHERE id=(v_off_c+1) INTO v_date;
                SET @v_got_100 = 2;
                SET v_avrg_p    = v_avrg;
                SET v_tnov_p    = v_turnov;
                SET v_off_p     = v_id - v_off_c;
                set v_date_p    = v_date;

                SET v_ratio     = 100 * (v_avrg_c-v_avrg_p) / v_avrg_c;
                INSERT INTO tbl_acc(code,  date_p,off_p,avrg_p,tnov_p, 
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

    SET v_id = v_nextid;
    SET v_part = v_part+1;
  END WHILE lbl_upto_parts;
  --  SELECT * FROM tempday LIMIT 100;
  --  SELECT v_part;

    INSERT INTO tbl_adiff(
               code,date_p,date_c,off_p,off_c,tnov_p,tnov_c,avrg_p,avrg_c,ratio,wchng,rdiff,dbrat)
        SELECT A.code,A.date_p,A.date_c,A.off_p,A.off_c,A.tnov_p,A.tnov_c,A.avrg_p,A.avrg_c,A.ratio,A.wchng,
            (A.ratio-B.ratio) as rdiff, 
            (A.ratio+A.wchng) as dbrat FROM tbl_acc A 
        INNER JOIN tbl_acc B on(A.id<B.id) GROUP BY A.id;

END tag_acc //

DROP PROCEDURE IF EXISTS sp_visit_code//
CREATE PROCEDURE sp_visit_code(a_code INT(6) ZEROFILL) tag_vcode:BEGIN
    -- prepare
    call sp_create_tbl_acc();
    -- do
    call sp_acc(a_code);
END tag_vcode //

SET @END='2015-01-16';
SET @NUM=300;
SET @PARTS=20;
SET @NMC_RATIO=1;
# call sp_visit_code(300104);
