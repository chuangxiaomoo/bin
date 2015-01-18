delimiter //

DROP PROCEDURE IF EXISTS sp_create_tbl_acf //
CREATE PROCEDURE sp_create_tbl_acf() tag_tbl_acf:BEGIN 

    DROP   TEMPORARY TABLE IF EXISTS tempfb;
    CREATE TEMPORARY TABLE tempfb (
        id          int(6)          PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6)          ZEROFILL NOT NULL, 
        datetime    bigint(14)      NOT NULL DEFAULT 0, 
        trade       DECIMAL(6,2)    NOT NULL,
        volume      DECIMAL(10,2)   NOT NULL,
        amount      DECIMAL(12,2)   NOT NULL,
        INDEX(code,datetime)
    );

    DROP   TABLE IF EXISTS tbl_acf;
    CREATE TABLE IF NOT EXISTS tbl_acf (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        datetime_p  bigint(14)      NOT NULL DEFAULT 0,
        datetime_c  bigint(14)      NOT NULL DEFAULT 0,
        off_p       INT  NOT NULL DEFAULT 0,
        off_c       INT  NOT NULL DEFAULT 0,
        tnov_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        tnov_c      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        avrg_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- previous 
        avrg_c      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- curr avrg = sum(amount) / sum(volume)
        ratio       DECIMAL(6,2) NOT NULL DEFAULT 0,
        wchng       DECIMAL(6,2) NOT NULL DEFAULT 0
    );

    DROP   TABLE IF EXISTS tbl_acfdiff;
    CREATE TABLE IF NOT EXISTS tbl_acfdiff (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        datetime_p  bigint(14)      NOT NULL DEFAULT 0,
        datetime_c  bigint(14)      NOT NULL DEFAULT 0,
        off_p       INT  NOT NULL DEFAULT 0,
        off_c       INT  NOT NULL DEFAULT 0,
        tnov_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        tnov_c      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        avrg_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- previous 
        avrg_c      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- curr avrg = sum(amount) / sum(volume)
        ratio       DECIMAL(6,2) NOT NULL DEFAULT 0,
        wchng       DECIMAL(6,2) NOT NULL DEFAULT 0,
        rdiff       DECIMAL(6,2) NOT NULL DEFAULT 0,
        dbrat        DECIMAL(6,2) NOT NULL DEFAULT 0 
    );
END tag_tbl_acf //

DROP PROCEDURE IF EXISTS sp_acf//
CREATE PROCEDURE sp_acf(a_code INT(6) ZEROFILL) tag_acf:BEGIN
    -- acf
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

    DECLARE v_datetime   bigint(14) DEFAULT 0; 
    DECLARE v_datetime_c bigint(14) DEFAULT 0;
    DECLARE v_datetime_p bigint(14) DEFAULT 0;

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

--  call sp_create_tempday(); -- tempfb 已包含在 sp_create_tbl_acf()
    SELECT nmc/close FROM cap WHERE code=a_code LIMIT 1 INTO v_shares;
    SET v_shares0  = 100 * v_shares * @NMC_RATIO;   -- fb以手为单位，cap中以万股为单位
    SET v_vol_unit = v_shares0/@PARTS;
    SET @sqls=concat('
        INSERT INTO tempfb(code,datetime,trade,volume,amount)
        SELECT code,datetime,trade,volume,amount FROM fenbi WHERE code=', 
        a_code, " and datetime<= ", @DT, " order by datetime DESC");
    PREPARE stmt from @sqls; EXECUTE stmt;

    SELECT count(*), sum(volume) FROM tempfb INTO @v_len, @v_volumes;

    -- 换手不足的个股
    IF @v_volumes < v_shares0*(2+@PPLUS/@PARTS) THEN 
        SELECT  @v_volumes,
                round(v_shares0*(2+@PPLUS/@PARTS),2) as volNeed, 
                TRUNCATE((@v_volumes/v_shares0-2)*@PARTS, 0) as maxPPLUS;
        -- SELECT a_code, @END, @NUM, "so_little_acf_data";
        INSERT INTO exitcode VALUES (1);
        LEAVE tag_acf; 
    END IF;

  lbl_upto_parts: WHILE v_part <= (@PARTS+@PPLUS) DO
    SET v_got_next = 0;
    SELECT datetime,trade,volume,amount FROM tempfb WHERE id=(v_id)
            INTO v_datetime,v_close,v_volume,v_amount;

    -- SELECT v_id,v_datetime,v_volume,v_vol_unit,v_amount;

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

            -- 每个upto_100%的部分都被减掉
            SET v_avrg = (v_sumamount-v_amt_more)/v_shares0;
            SET v_turnov = v_sumvolume/v_shares;

            -- 将周期curr多余的量存入周期prev
            SET v_sumvolume = v_vol_more;
            SET v_sumamount = v_amt_more;

            -- SELECT "got v_got_100",v_id, v_num_unit,v_datetime,v_turnov;

            IF  @v_got_100 = 0 THEN 
                SET @v_got_100 = 1;
                SET v_avrg_c    = v_avrg;
                SET v_tnov_c    = v_turnov;
                SET v_off_c     = v_id;
                SET v_datetime_c= v_datetime;
                SET v_wchng     = 100 * (v_close-v_avrg_c)/v_avrg_c;
            ELSE
                SELECT datetime FROM tempfb WHERE id=(v_off_c+1) INTO v_datetime;
                SET @v_got_100 = 2;
                SET v_avrg_p    = v_avrg;
                SET v_tnov_p    = v_turnov;
                SET v_off_p     = v_id - v_off_c;
                SET v_datetime_p= v_datetime;

                SET v_ratio     = 100 * (v_avrg_c-v_avrg_p) / v_avrg_c;
                INSERT INTO tbl_acf(code,  datetime_p,off_p,avrg_p,tnov_p, 
                                            datetime_c,off_c,avrg_c,tnov_c,ratio,wchng)
                         VALUES(a_code,   v_datetime_p,v_off_p,v_avrg_p,v_tnov_p, 
                                          v_datetime_c,v_off_c,v_avrg_c,v_tnov_c,v_ratio,v_wchng);

                LEAVE lbl_upto_100;
            END IF;
        END IF;

        SET v_id = v_id+1;
        SELECT volume,amount FROM tempfb WHERE id=(v_id) INTO v_volume,v_amount;
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

    INSERT INTO tbl_acfdiff(
               code,datetime_p,datetime_c,off_p,off_c,tnov_p,tnov_c,avrg_p,avrg_c,ratio,wchng,rdiff,dbrat)
        SELECT A.code,A.datetime_p,A.datetime_c,A.off_p,A.off_c,A.tnov_p,A.tnov_c,A.avrg_p,A.avrg_c,A.ratio,A.wchng,
            (A.ratio-B.ratio) as rdiff, 
            (A.ratio+A.wchng) as dbrat FROM tbl_acf A 
        INNER JOIN tbl_acf B on(A.id<B.id) GROUP BY A.id;

END tag_acf //

DROP PROCEDURE IF EXISTS sp_visit_code//
CREATE PROCEDURE sp_visit_code(a_code INT(6) ZEROFILL) tag_vcode:BEGIN
    -- prepare
    call sp_create_tbl_acf();
    -- do
    call sp_acf(a_code);
END tag_vcode //

SET @DT='20150116150000';
SET @PARTS=20;
SET @PPLUS=5;
SET @NMC_RATIO=.20;

# call sp_visit_code(300104);
