--  kmysql <<< "source /root/bin/stk/sql/God.sql"
--  kmysql <<< "source /root/bin/stk/sql/xRD.sql"

delimiter //

DROP PROCEDURE IF EXISTS sp_cp_tbl //
CREATE PROCEDURE sp_cp_tbl(a_tbl_fr CHAR(32), a_tbl_to CHAR(32)) BEGIN
    -- CREATE TABLE newadmin LIKE admin;   
    -- INSERT INTO newadmin SELECT * FROM admin;  
    SET @sqls=concat('DROP TABLE IF EXISTS ', a_tbl_to);
    PREPARE stmt from @sqls; EXECUTE stmt;

    SET @sqls=concat('CREATE TABLE ', a_tbl_to, ' LIKE ', a_tbl_fr); 
    PREPARE stmt from @sqls; EXECUTE stmt;

    SET @sqls=concat('INSERT INTO ', a_tbl_to, ' SELECT * FROM ', a_tbl_fr);  
    PREPARE stmt from @sqls; EXECUTE stmt;
    -- SELECT @sqls;
END //

DROP PROCEDURE IF EXISTS sp_ema//
CREATE PROCEDURE sp_ema(a_tbl CHAR(32), a_x CHAR(20), 
                        a_ema CHAR(20), a_period INT) tag_ema:BEGIN
    DECLARE v_i         INT DEFAULT 1;
    DECLARE v_ema       DECIMAL(8,4) DEFAULT 0;
    DECLARE v_ema_prev  DECIMAL(8,4) DEFAULT 0;
    DECLARE v_k         DECIMAL(8,4) DEFAULT (2.0/(a_period+1));

    # EXECUTE @sqls中的INTO 子句中的变量必须是用户变量 @var
    # EXECUTE @sqls中的WHERE子句中的比较不可以两个都是变量
    # EXECUTE @sqls中的SET =子句中的赋值也是如此

    SET @v_x   = 0; 
    SET @v_len = 0;

    SET @sqls=concat('SELECT count(*) FROM ', a_tbl, ' INTO @v_len');
    PREPARE stmt from @sqls; EXECUTE stmt;

    loop_visit: REPEAT
        SET @sqls=concat('SELECT ', a_x, ' FROM ', a_tbl,' WHERE id=', v_i, ' INTO @v_x');
        PREPARE stmt from @sqls; EXECUTE stmt;

        SET v_ema = IF(v_i=1, @v_x, @v_x * v_k + v_ema_prev * (1-v_k));

        set @sqls=concat('UPDATE ', a_tbl, ' SET ', a_ema,' = ', v_ema, ' WHERE id=', v_i);
        PREPARE stmt from @sqls; EXECUTE stmt; -- DEALLOCATE PREPARE stmt;

        SET v_ema_prev = v_ema;
        SET v_i = v_i + 1;
    UNTIL v_i > @v_len END REPEAT;
END tag_ema//


DROP PROCEDURE IF EXISTS sp_macd//
CREATE PROCEDURE sp_macd(a_tbl CHAR(32), a_code INT(6) ZEROFILL) tag_macd:BEGIN
    DROP TABLE IF EXISTS macd;
    CREATE TABLE macd (
        id          INT(6) PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date        date NOT NULL,
        close       DECIMAL(6,2) NOT NULL DEFAULT 0,
        short_ema   DECIMAL(8,4) NOT NULL DEFAULT 0,
        long_ema    DECIMAL(8,4) NOT NULL DEFAULT 0,
        dif         DECIMAL(8,4) NOT NULL DEFAULT 0,
        dea         DECIMAL(8,4) NOT NULL DEFAULT 0,
        macd        DECIMAL(8,4) NOT NULL DEFAULT 0,
        INDEX(date)
    );

    SET @sqls=concat('INSERT INTO macd(code,date,close) SELECT code,date,close FROM ',
                        a_tbl, ' WHERE code = ', a_code);
    PREPARE stmt from @sqls; EXECUTE stmt;

    -- long short dea 26 12 9
    call sp_ema('macd', 'close', 'short_ema', 12);
    call sp_ema('macd', 'close', 'long_ema',  26);

    UPDATE  macd SET dif  = short_ema-long_ema;

    call sp_ema('macd', 'dif',   'dea',       9);

    UPDATE  macd SET macd = (dif -dea)*2 ;
END tag_macd//


/* 结果输出到表 kdj */
DROP PROCEDURE IF EXISTS sp_kdj//
CREATE PROCEDURE sp_kdj(a_tbl CHAR(32), a_code INT(6) ZEROFILL, a_N INT) 
tag_kdj:BEGIN
    DECLARE v_i         INT DEFAULT a_N;
    DECLARE v_rsv       DECIMAL(8,4) DEFAULT 0;
    DECLARE v_k         DECIMAL(8,4) DEFAULT 50;
    DECLARE v_d         DECIMAL(8,4) DEFAULT 50;
    DECLARE v_prev_k    DECIMAL(8,4) DEFAULT 50;
    DECLARE v_prev_d    DECIMAL(8,4) DEFAULT 50;
    DECLARE v_j         DECIMAL(8,4) DEFAULT 50;

    DECLARE v_close     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_llv       DECIMAL(6,2) DEFAULT 0;
    DECLARE v_hhv       DECIMAL(6,2) DEFAULT 0;
    DECLARE v_len       DECIMAL(6,2) DEFAULT 0;

    DROP   TEMPORARY TABLE IF EXISTS kdj;
    CREATE TEMPORARY TABLE kdj (
        id          INT(6) PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date        date NOT NULL,
        open        DECIMAL(6,2) NOT NULL DEFAULT 0,
        close       DECIMAL(6,2) NOT NULL DEFAULT 0,
        high        DECIMAL(6,2) NOT NULL DEFAULT 0,
        low         DECIMAL(6,2) NOT NULL DEFAULT 0,
        rsv         DECIMAL(8,4) NOT NULL DEFAULT 0,
        k           DECIMAL(8,4) NOT NULL DEFAULT 0,
        d           DECIMAL(8,4) NOT NULL DEFAULT 0,
        j           DECIMAL(8,4) NOT NULL DEFAULT 0,
        INDEX(date)
    );

    -- 只要传入参数a_tbl有列(code,date,close,high,low)，即可调用kdj
    SET @sqls=concat('INSERT INTO kdj(code,date,open,close,high,low) ',
                        'SELECT code,date,open,close,high,low FROM ', a_tbl,
                        ' WHERE code=', a_code, ' and date > "2012-11-11"');
    PREPARE stmt from @sqls; EXECUTE stmt;

    SELECT count(*) FROM kdj INTO v_len;
    -- SELECT * FROM kdj;

    loop_visit: REPEAT
        SELECT close FROM kdj where id = v_i INTO v_close;
        SELECT max(high) from kdj where v_i-a_N < id and id <= v_i INTO v_hhv;
        SELECT min(low ) from kdj where v_i-a_N < id and id <= v_i INTO v_llv;

        SET v_rsv = 100*(v_close-v_llv)/(v_hhv-v_llv);
        SET v_k = (2*v_prev_k + v_rsv)/3;
        SET v_d = (2*v_prev_d + v_k)/3;
        SET v_j = 3*v_k - 2*v_d;

        UPDATE kdj SET rsv =  v_rsv WHERE id = v_i;
        UPDATE kdj SET k   =  v_k   WHERE id = v_i;
        UPDATE kdj SET d   =  v_d   WHERE id = v_i;
        UPDATE kdj SET j   =  v_j   WHERE id = v_i;

        SET v_i = v_i + 1;
        SET v_prev_k = v_k;
        SET v_prev_d = v_d;
    UNTIL v_i > v_len END REPEAT;
END tag_kdj//

DROP PROCEDURE IF EXISTS sp_create_tbl_sink //
CREATE PROCEDURE sp_create_tbl_sink() tag_tbl_sink:BEGIN 
    DROP   TABLE IF EXISTS tbl_sink;
    CREATE TABLE tbl_sink (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        swing       DECIMAL(6,2) NOT NULL DEFAULT 0,        -- price swing
        rise        DECIMAL(6,2) NOT NULL DEFAULT 0,        -- rise turnover
        sink        DECIMAL(6,2) NOT NULL DEFAULT 0,        -- sink turnover
        sum         DECIMAL(6,2) NOT NULL DEFAULT 0,        -- sum = rise + sink
        net         DECIMAL(6,2) NOT NULL DEFAULT 0,        -- net = rise - sink
        low         DECIMAL(6,2) NOT NULL DEFAULT 0,        
        avrg        DECIMAL(6,2) NOT NULL DEFAULT 0,        
        trade       DECIMAL(6,2) NOT NULL DEFAULT 0,        
        date_low    date NOT NULL DEFAULT 0,
        date_high   date NOT NULL DEFAULT 0
    );
   #)engine memory;
END tag_tbl_sink //

DROP PROCEDURE IF EXISTS sp_create_tbl_9jian //
CREATE PROCEDURE sp_create_tbl_9jian() tag_tbl_9jian:BEGIN 
    DROP   TABLE IF EXISTS tbl_9jian;
    CREATE TABLE tbl_9jian (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date1       date NOT NULL DEFAULT 0,
        date2       date NOT NULL DEFAULT 0,
        off         INT  NOT NULL DEFAULT 0,
        open        DECIMAL(6,2) NOT NULL DEFAULT 0,
        low         DECIMAL(6,2) NOT NULL DEFAULT 0,    -- lchng = (low - avrg)/avrg
        close       DECIMAL(6,2) NOT NULL DEFAULT 0,
        volume      DECIMAL(12,2) NOT NULL DEFAULT 0,
        amount      DECIMAL(12,2) NOT NULL DEFAULT 0,
        turnov      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        avrg        DECIMAL(6,2) NOT NULL DEFAULT 0,    -- avrg = sum(amount) / sum(volume)
        chng        DECIMAL(6,2) NOT NULL DEFAULT 0     -- chng = (close-open)/open
    );
END tag_tbl_9jian //

DROP PROCEDURE IF EXISTS sp_create_tbl_6mai //
CREATE PROCEDURE sp_create_tbl_6mai() tag_tbl_6mai:BEGIN 
    DROP   TABLE IF EXISTS tbl_6mai;
    CREATE TABLE tbl_6mai (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date1       date NOT NULL DEFAULT 0,
        date2       date NOT NULL DEFAULT 0,
        off         INT  NOT NULL DEFAULT 0,
        open        DECIMAL(6,2) NOT NULL DEFAULT 0,
        low         DECIMAL(6,2) NOT NULL DEFAULT 0,    -- lchng = (low - avrg)/avrg
        close       DECIMAL(6,2) NOT NULL DEFAULT 0,
        volume      DECIMAL(12,2) NOT NULL DEFAULT 0,
        amount      DECIMAL(12,2) NOT NULL DEFAULT 0,
        turnov      DECIMAL(6,2) NOT NULL DEFAULT 0,    
        avrg        DECIMAL(6,2) NOT NULL DEFAULT 0,    -- avrg = sum(amount) / sum(volume)
        chng        DECIMAL(6,2) NOT NULL DEFAULT 0     -- chng = (close-open)/open
    );
END tag_tbl_6mai //

DROP PROCEDURE IF EXISTS sp_create_tbl_taox //
CREATE PROCEDURE sp_create_tbl_taox() tag_tbl_taox:BEGIN 
    DROP   TABLE IF EXISTS tbl_taox;
    CREATE TABLE tbl_taox (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date_p      date NOT NULL DEFAULT 0,
        date_c      date NOT NULL DEFAULT 0,
        off_p       INT  NOT NULL DEFAULT 0,
        off_c       INT  NOT NULL DEFAULT 0,
        turnov_p    DECIMAL(6,2) NOT NULL DEFAULT 0,    
        turnov_c    DECIMAL(6,2) NOT NULL DEFAULT 0,    
        avrg_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- previous 
        avrg_c      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- curr avrg = sum(amount) / sum(volume)
        ratio       DECIMAL(6,2) NOT NULL DEFAULT 0,
        wchng       DECIMAL(6,2) NOT NULL DEFAULT 0
    );
    CREATE TABLE IF NOT EXISTS tbl_rdiff (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date_p      date NOT NULL DEFAULT 0,
        date_c      date NOT NULL DEFAULT 0,
        off_p       INT  NOT NULL DEFAULT 0,
        off_c       INT  NOT NULL DEFAULT 0,
        turnov_p    DECIMAL(6,2) NOT NULL DEFAULT 0,    
        turnov_c    DECIMAL(6,2) NOT NULL DEFAULT 0,    
        avrg_p      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- previous 
        avrg_c      DECIMAL(6,2) NOT NULL DEFAULT 0,    -- curr avrg = sum(amount) / sum(volume)
        ratio       DECIMAL(6,2) NOT NULL DEFAULT 0,
        wchng       DECIMAL(6,2) NOT NULL DEFAULT 0,
        rdiff       DECIMAL(6,2) NOT NULL DEFAULT 0 
    );
    CREATE TABLE IF NOT EXISTS tbl_tao5 LIKE tbl_taox;
END tag_tbl_taox //

-- 使用TEMPORARY时效率提升5倍
-- ERROR 1137 (HY000): Can't reopen table: 'tempday', 因为使用了SELECT嵌套
-- SELECT close FROM tempday WHERE date=(SELECT max(date) FROM tempday);
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

DROP PROCEDURE IF EXISTS sp_create_ma513 //
CREATE PROCEDURE sp_create_ma513() tag_ma513:BEGIN 
    DROP TABLE IF EXISTS tbl_ma513; -- for visit output
    CREATE TABLE tbl_ma513(
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        close       DECIMAL(6,2)  NOT NULL DEFAULT 0,
        ma5         DECIMAL(6,2)  NOT NULL DEFAULT 0,        
        ma13        DECIMAL(6,2)  NOT NULL DEFAULT 0,
        vol         DECIMAL(12,2) NOT NULL DEFAULT 0,
        vol5        DECIMAL(12,2) NOT NULL DEFAULT 0,
        vol13       DECIMAL(12,2) NOT NULL DEFAULT 0,
        high        DECIMAL(6,2)  NOT NULL DEFAULT 0,
        low         DECIMAL(6,2)  NOT NULL DEFAULT 0
    );
END tag_ma513 //

DROP PROCEDURE IF EXISTS sp_create_ma144 //
CREATE PROCEDURE sp_create_ma144() tag_ma144:BEGIN 
    DROP TABLE IF EXISTS tbl_ma144; -- for visit output
    CREATE TABLE tbl_ma144(
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date        date NOT NULL,
        low         DECIMAL(6,2) NOT NULL DEFAULT 0,
        high        DECIMAL(6,2) NOT NULL DEFAULT 0,
        width       DECIMAL(6,2) NOT NULL DEFAULT 0,
        close       DECIMAL(6,2) NOT NULL DEFAULT 0,
        ma13        DECIMAL(6,2) NOT NULL DEFAULT 0,
        ma34        DECIMAL(6,2) NOT NULL DEFAULT 0,        
        ma144       DECIMAL(6,2) NOT NULL DEFAULT 0 
    );
END tag_ma144 //

DROP PROCEDURE IF EXISTS sp_create_ma240 //
CREATE PROCEDURE sp_create_ma240() tag_ma240:BEGIN 
    DROP TABLE IF EXISTS tbl_ma240; -- for visit output
    CREATE TABLE tbl_ma240(
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date        date NOT NULL,
        low         DECIMAL(6,2) NOT NULL DEFAULT 0,
        high        DECIMAL(6,2) NOT NULL DEFAULT 0,
        close       DECIMAL(6,2) NOT NULL DEFAULT 0,
        ma34        DECIMAL(6,2) NOT NULL DEFAULT 0,        
        ma60        DECIMAL(6,2) NOT NULL DEFAULT 0,
        ma120       DECIMAL(6,2) NOT NULL DEFAULT 0,
        ma240       DECIMAL(6,2) NOT NULL DEFAULT 0
    );
END tag_ma240 //

DROP PROCEDURE IF EXISTS sp_create_tempwek //
CREATE PROCEDURE sp_create_tempwek() tag_tempwek:BEGIN
    DROP TABLE IF EXISTS tempwek;
    CREATE TABLE tempwek (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date        date NOT NULL,
        open        DECIMAL(6,2) NOT NULL,
        high        DECIMAL(6,2) NOT NULL,
        low         DECIMAL(6,2) NOT NULL,
        close       DECIMAL(6,2) NOT NULL,
        INDEX(date)
    );
END tag_tempwek //

DROP PROCEDURE IF EXISTS sp_day //
CREATE PROCEDURE sp_day(a_tbl CHAR(32), a_code INT(6) ZEROFILL) tag_day:BEGIN
    call sp_create_tempday();
    INSERT INTO tempday(code,date,open,high,low,close) 
        SELECT code,date,open,high,low,close FROM day WHERE code=a_code;
END tag_day //

DROP PROCEDURE IF EXISTS sp_7day //
CREATE PROCEDURE sp_7day(a_tbl CHAR(32), a_code INT(6) ZEROFILL) tag_wk:BEGIN
    DECLARE v_today date DEFAULT CURDATE();
    DECLARE v_date0 date DEFAULT 0;  -- Monday
    DECLARE v_date7 date DEFAULT 0;  -- next Monday
    DECLARE v_weekbgn date DEFAULT 0;
    DECLARE v_weekend date DEFAULT 0;
    DECLARE v_open  DECIMAL(6,2) DEFAULT 0;
    DECLARE v_close DECIMAL(6,2) DEFAULT 0;
    DECLARE v_high  DECIMAL(6,2) DEFAULT 0;
    DECLARE v_low   DECIMAL(6,2) DEFAULT 0;
    DECLARE v_i     INT DEFAULT 0;

    call sp_create_tempwek();
    call sp_create_tempday();
    INSERT INTO tempday(code,date,open,high,low,close) 
        SELECT code,date,open,high,low,close FROM day WHERE code=a_code;

    SET v_date0 = SUBDATE(CURDATE(),WEEKDAY(CURDATE())+7*100); -- 100 weeks
    SET v_date7 = ADDDATE(v_date0, 7);
    -- SELECT v_date0;

    loop_visit: REPEAT
        SELECT min(date) FROM tempday WHERE  date >= v_date0 and date < v_date7 INTO v_weekbgn;
        SELECT max(date) FROM tempday WHERE  date >= v_date0 and date < v_date7 INTO v_weekend;

        SELECT  open FROM tempday where date = v_weekbgn into v_open;
        SELECT close FROM tempday where date = v_weekend into v_close;
        SELECT max(high) FROM tempday where date >= v_weekbgn and date <= v_weekend into v_high;
        SELECT min(low)  FROM tempday where date >= v_weekbgn and date <= v_weekend into v_low;

        IF v_weekbgn IS NOT NULL THEN
            IF v_high IS NULL THEN
                SELECT v_weekbgn, v_weekend;
                LEAVE tag_wk;
            END IF;

            INSERT INTO tempwek(code,date,open,high,low,close)
                    VALUES(a_code, v_weekend, v_open, v_high, v_low, v_close);
            -- ELSE SELECT v_weekend, " is market-closed";
        END IF;

        SET v_date0 = v_date7;
        SET v_date7 = ADDDATE(v_date0, 7);
        SET v_i = v_i + 1;
        --  IF (v_i > 81) THEN
        --      SELECT "leaveing with count 60"; LEAVE loop_visit; 
        --  END IF;
    UNTIL v_date0 >= v_today END REPEAT;
    -- SELECT v_date7, v_today;
END tag_wk //

DROP PROCEDURE IF EXISTS sp_kdj_wk//
CREATE PROCEDURE sp_kdj_wk(a_tbl CHAR(32), a_code INT(6) ZEROFILL, a_N INT) 
tag_kdj_wk:BEGIN
    call sp_7day(a_tbl, a_code);
    call sp_kdj('tempwek', a_code, 9);
END tag_kdj_wk //

DROP PROCEDURE IF EXISTS sp_flt_kdj_up//
CREATE PROCEDURE sp_flt_kdj_up(a_code INT(6) ZEROFILL) tag_flt_kdj_up:BEGIN
    DECLARE v_maxid     INT;
    DECLARE v_date      DATE;
    DECLARE v_k2    DECIMAL(8,4) DEFAULT 0;
    DECLARE v_k0    DECIMAL(8,4) DEFAULT 0;
    DECLARE v_d2    DECIMAL(8,4) DEFAULT 0;
    DECLARE v_d0    DECIMAL(8,4) DEFAULT 0;

    call sp_kdj('day', a_code, 9);
    SELECT max(id) FROM kdj INTO v_maxid;
    SELECT k,d      FROM kdj WHERE id=(v_maxid-2)  INTO v_k0,v_d0;
    SELECT k,d,date FROM kdj WHERE id=v_maxid      INTO v_k2,v_d2,v_date;

    -- K上穿D, d<30, and ALIVE
    IF v_k2 > v_d2 AND v_k0 < v_d0 AND v_d2 < 35 AND v_date = @v_maxdate THEN 
        SELECT "coming ", a_code;
        INSERT INTO tbl_visit(code) VALUES(a_code);
    END IF;
END tag_flt_kdj_up //

DROP PROCEDURE IF EXISTS sp_flt_13d_sink//
CREATE PROCEDURE sp_flt_13d_sink(a_code INT(6) ZEROFILL) tag_flt_13d_sink:BEGIN
    DECLARE v_high      DECIMAL(6,2) DEFAULT 0;
    DECLARE v_low       DECIMAL(6,2) DEFAULT 0;
    DECLARE v_close     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_sink      DECIMAL(6,2) DEFAULT 0;
    DECLARE v_date      DATE;
    DECLARE v_date_high DATE;
    DECLARE v_date_low  DATE;

    call sp_create_tempday();
    INSERT INTO tempday(code,date,open,high,low,close) 
                SELECT code,date,open,high,low,close FROM day 
                WHERE code=(a_code)               -- and date < @v_maxdate
                ORDER BY date DESC limit 8;         -- GOLDEN LAW 2 3 5 8 13

    call sp_xRD();
    SELECT date FROM tempday WHERE id=1 INTO v_date;
    SELECT date,high FROM tempday order by high DESC limit 1 INTO v_date_high,v_high;
    SELECT date,low  FROM tempday order by low  ASC  limit 1 INTO v_date_low ,v_low;
    SELECT close     FROM tempday WHERE date=@v_maxdate INTO v_close;
    SET v_sink = 100*(v_high-v_low)/v_high;

    # SELECT a_code,v_sink;

    IF v_date_low > v_date_high AND v_date = @v_maxdate AND v_sink > 20 THEN 
        SELECT a_code,v_sink, 100*(v_close-v_low)/v_low as bounce,v_date_low,v_low;
        INSERT INTO tbl_visit(code,sink,bounce,date_low,date_high) 
            VALUES(a_code,v_sink,100*(v_close-v_low)/v_low,v_date_low,v_date_high);
    END IF;
END tag_flt_13d_sink //

DROP PROCEDURE IF EXISTS sp_flt_n_day_change//
CREATE PROCEDURE sp_flt_n_day_change(a_code INT(6) ZEROFILL) tag_flt_n_day_change:BEGIN
    DECLARE v_high      DECIMAL(6,2) DEFAULT 0;
    DECLARE v_low       DECIMAL(6,2) DEFAULT 0;
    DECLARE v_close     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_change    DECIMAL(6,2) DEFAULT 0;
    DECLARE v_yesc_0    DECIMAL(6,2) DEFAULT 0;
    DECLARE v_close_n   DECIMAL(6,2) DEFAULT 0;
    DECLARE v_date      DATE;
    DECLARE v_date_max  DATE;
    DECLARE v_date_high DATE;
    DECLARE v_date_low  DATE;

-- LEAVE tag_flt_n_day_change; 

    call sp_create_tempday();
    INSERT INTO tempday(code,date,yesc,open,high,low,close) 
                SELECT code,date,yesc,open,high,low,close FROM day 
                WHERE code=(a_code) and date > @v_mindate
                ORDER BY date DESC;     -- GOLDEN LAW 2 3 5 8 13

    call sp_xRD();
    -- SELECT date FROM tempday WHERE id=1 INTO v_date;
    SELECT date,close FROM tempday WHERE id=1 INTO v_date_max,v_close_n;
    SELECT       yesc FROM tempday WHERE id=(SELECT max(id) FROM tempday) INTO v_yesc_0;

    SELECT close FROM tempday WHERE date=@v_maxdate INTO v_close;
    SET v_change = 100*(v_close_n-v_yesc_0)/v_yesc_0;

    # 增幅>@argv_change
    IF @argv_change > 0 AND @argv_change < v_change THEN -- AND v_date = @v_maxdate
        SELECT a_code,v_change;
        INSERT INTO tbl_visit(code,sink) VALUES(a_code,v_change);
    END IF;

    # 跌幅>@argv_change
    IF @argv_change < 0 AND @argv_change > v_change THEN -- AND v_date = @v_maxdate 
        SELECT a_code,v_change;
        INSERT INTO tbl_visit(code,sink) VALUES(a_code,v_change);
    END IF;
END tag_flt_n_day_change//


DROP PROCEDURE IF EXISTS sp_visit_tbl//
CREATE PROCEDURE sp_visit_tbl(a_tbl CHAR(32), a_type INT) tag_visit:BEGIN
    DECLARE v_code  INT(6) ZEROFILL;
    DECLARE v_id    INT DEFAULT 1; 
    DECLARE v_len   INT; /* CURSOR and HANDLER declare in end of declaration */
    
    DROP TABLE IF EXISTS codes;
    CREATE TABLE codes (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0
    );
    DROP TABLE IF EXISTS tbl_visit; -- for visit output
    CREATE TABLE tbl_visit(
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        swing       DECIMAL(6,2) NOT NULL DEFAULT 0,        -- price swing
        rise        DECIMAL(6,2) NOT NULL DEFAULT 0,
        sink        DECIMAL(6,2) NOT NULL DEFAULT 0,
        bounce      DECIMAL(6,2) NOT NULL DEFAULT 0,        -- net turnover
        amount      DECIMAL(12,2)NOT NULL DEFAULT 0,
        turnover    DECIMAL(6,2) NOT NULL DEFAULT 0,        -- sum turnover
        date_low    date NOT NULL DEFAULT 0,
        date_high   date NOT NULL DEFAULT 0
    );

    SET @cond=' ORDER by code';
    SET @sqls=concat('INSERT INTO codes(code) SELECT code FROM ', a_tbl, @cond);
    PREPARE stmt from @sqls; EXECUTE stmt;
    SELECT max(id)   FROM codes INTO v_len;
    SELECT max(date) FROM day WHERE code=900001 INTO @v_maxdate;

    SET @sqls=concat(
    'SELECT date FROM day WHERE code = 900001 ORDER by date DESC limit ',
    @argv_n,
    ',1 INTO @v_mindate;'
    );
    PREPARE stmt from @sqls; EXECUTE stmt;

    -- prepare
    IF a_type = @fn_get_ma513       THEN call sp_create_ma513();    END IF;
    IF a_type = @fn_up_ma240_all    THEN call sp_create_ma240();    END IF;
    IF a_type = @fn_get_down_turnov THEN call sp_create_tbl_sink(); END IF;
    IF a_type = @fn_dugu9jian       THEN call sp_create_tbl_9jian();END IF;
    IF a_type = @fn_6maishenjian    THEN call sp_create_tbl_6mai(); END IF;
    IF a_type = @fn_taox_ratio      THEN call sp_create_tbl_taox(); END IF;
    IF a_type = @fn_up_ma144_all    THEN call sp_create_ma144();    END IF;

    -- visit all codes
    WHILE v_id <= v_len DO
        SELECT code FROM codes WHERE id=(v_id) INTO v_code;
        CASE a_type
            WHEN @fn_flt_kdj_up        THEN call sp_flt_kdj_up(v_code);
            WHEN @fn_flt_13d_sink      THEN call sp_flt_13d_sink(v_code);
            WHEN @fn_flt_n_day_change  THEN call sp_flt_n_day_change(v_code);
            WHEN @fn_get_down_turnov   THEN call sp_get_down_turnov(v_code);
            WHEN @fn_dugu9jian         THEN call sp_dugu9jian(v_code);
            WHEN @fn_get_ma513         THEN call sp_get_ma513(v_code);
            WHEN @fn_up_ma240_all      THEN call sp_get_ma240(v_code);
            WHEN @fn_up_ma240_34       THEN call sp_up_ma34(v_code);
            WHEN @fn_6maishenjian      THEN call sp_6maishenjian(v_code);
            WHEN @fn_taox_ratio        THEN call sp_taox(v_code);
            WHEN @fn_up_ma144_all      THEN call sp_get_ma144(v_code);
            ELSE SELECT "no a_type match";
        END CASE;

        SET v_id = v_id + 1;
    END WHILE;
END tag_visit //

DROP PROCEDURE IF EXISTS sp_xRD//
CREATE PROCEDURE sp_xRD() tag_xRD:BEGIN
    DECLARE v_code      INT(6) ZEROFILL DEFAULT 0;
    DECLARE v_xRD_date  date DEFAULT 0;
    DECLARE v_min_date  date DEFAULT 0;
    DECLARE v_yesclose  DECIMAL(6,2) DEFAULT 0;
    DECLARE v_xRD_open  DECIMAL(6,2) DEFAULT 0;
    DECLARE v_facttor   DECIMAL(8,4) DEFAULT 0;

    DECLARE v_unit_xRD   DECIMAL(8,5) DEFAULT 0;
    DECLARE v_price_chg  DECIMAL(8,5) DEFAULT 0;

 -- SELECT v_code,v_min_date,v_xRD_date;
 -- SELECT song_ratio,pei_ratio,pei_price,div_ratio FROM xRD WHERE code = v_code ;
    SELECT code,date FROM tempday WHERE id=1 INTO v_code,v_min_date;
    SELECT date FROM xRD WHERE code=(v_code) INTO v_xRD_date;

    IF  v_xRD_date < '2013-01-01' OR v_xRD_date < v_min_date OR 
        v_xRD_date > CURDATE() THEN 
        LEAVE tag_xRD; 
    END IF;

    -- begin to UPDATE, 对每个close进行相应公式处理。
    SELECT close FROM tempday 
        WHERE id=(SELECT id FROM tempday WHERE date=v_xRD_date)-1 INTO v_yesclose;

    SELECT (1+song_ratio+pei_ratio),(pei_price*pei_ratio-div_ratio) 
        FROM xRD WHERE code = v_code INTO v_unit_xRD,v_price_chg;

--  SELECT date,close,(close+v_price_chg)/v_unit_xRD
--      FROM tempday WHERE date < v_xRD_date and date > '2013-10-30';

    UPDATE tempday SET 
        close=(close+v_price_chg)/v_unit_xRD,
         open=(open +v_price_chg)/v_unit_xRD,
         high=(high +v_price_chg)/v_unit_xRD,
          low=(low  +v_price_chg)/v_unit_xRD 
        WHERE date < v_xRD_date;
    -- SELECT date,close FROM tempday;

END tag_xRD //

# 统计历史涨跌停家数
DROP PROCEDURE IF EXISTS sp_count_swing10//
CREATE PROCEDURE sp_count_swing10() tag_swing10:BEGIN
    DECLARE v_sink      INT DEFAULT 0; 
    DECLARE v_rise      INT DEFAULT 0; 
    DECLARE v_len       INT DEFAULT 0; 
    DECLARE v_start     date DEFAULT 0;
    DECLARE v_tmpdate   date DEFAULT 0;

    CREATE TABLE IF NOT EXISTS swing10 (
        id          INT(6) PRIMARY key AUTO_INCREMENT NOT NULL,
        date        date NOT NULL,
        rise        INT NOT NULL DEFAULT 0,
        sink        INT NOT NULL DEFAULT 0
    );

    -- 之前的数据不删除，只做增量统计
    SELECT count(*) FROM swing10 INTO v_len;
    IF v_len <> 0 THEN
        SELECT max(date) FROM swing10 INTO v_start;
    ELSE
        SET v_start='2013-07-18';
    END IF;

    SELECT max(date) FROM day WHERE code=900001 INTO @v_maxdate;
    SELECT v_start, @v_maxdate;

    WHILE v_start <> @v_maxdate DO
        SELECT date FROM day WHERE code=900001 and date>v_start limit 1 INTO v_start;
        -- SELECT v_tmpdate;
        SELECT count(code) FROM day WHERE date=v_start and 100*(close-yesc)/yesc>6.1 INTO v_rise;
        SELECT count(code) FROM day WHERE date=v_start and 100*(close-yesc)/yesc<-6.1 INTO v_sink;
        -- SELECT v_start,v_rise,v_sink;
        INSERT INTO swing10(date,rise, sink) VALUES(v_start, v_rise, v_sink);
        -- LEAVE tag_swing10;
    END WHILE;

END tag_swing10 //

DROP PROCEDURE IF EXISTS sp_stat_change //
CREATE PROCEDURE sp_stat_change() tag_stat_change:BEGIN
    DECLARE v_sink      INT DEFAULT 0; 
    DECLARE v_rise      INT DEFAULT 0; 
    DECLARE v_len       INT DEFAULT 0; 
    DECLARE v_start     date DEFAULT 0;
    DECLARE v_tmpdate   date DEFAULT 0;

    DECLARE v_inc       INT DEFAULT 0; 
    DECLARE v_dec0      INT DEFAULT 0; 

    DECLARE v_inc8      INT DEFAULT 0; 
    DECLARE v_inc5      INT DEFAULT 0; 
    DECLARE v_inc2      INT DEFAULT 0; 
    DECLARE v_inc1      INT DEFAULT 0; 

    DECLARE v_dec2      INT DEFAULT 0; 
    DECLARE v_dec5      INT DEFAULT 0; 
    DECLARE v_dec8      INT DEFAULT 0; 
    DECLARE v_dec1      INT DEFAULT 0; 

    DROP TABLE IF EXISTS tbl_change;
    CREATE TABLE IF NOT EXISTS tbl_change (
        id          INT(6) PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date        date NOT NULL,
        chng        DECIMAL(6,2) NOT NULL DEFAULT 0
    );

    DROP TABLE IF EXISTS tbl_stat_change;
    CREATE TABLE IF NOT EXISTS tbl_stat_change (
        id          INT(6) PRIMARY key AUTO_INCREMENT NOT NULL,
        date        date NOT NULL,

        inc         INT(6) NOT NULL DEFAULT 0,
        dec0        INT(6) NOT NULL DEFAULT 0,

        inc8        INT(6) NOT NULL DEFAULT 0,
        inc5        INT(6) NOT NULL DEFAULT 0,
        inc2        INT(6) NOT NULL DEFAULT 0,
        inc1        INT(6) NOT NULL DEFAULT 0,

        dec1        INT(6) NOT NULL DEFAULT 0,
        dec2        INT(6) NOT NULL DEFAULT 0,
        dec5        INT(6) NOT NULL DEFAULT 0,
        dec8        INT(6) NOT NULL DEFAULT 0
    );

    INSERT INTO tbl_change(code,date,chng) SELECT 
           code,date,100*(close-yesc)/yesc FROM day 
            WHERE date>=@START and date<=@END; # and code>300000 and code<400000;

    SET v_start=@START;

    -- @START 这天没有进入统计
    WHILE v_start <> @END DO
        SELECT date FROM day WHERE code=900001 and date>v_start limit 1 INTO v_start;
        -- SELECT v_start;

        SELECT count(code) FROM tbl_change WHERE date=v_start and chng>=0              INTO v_inc;
        SELECT count(code) FROM tbl_change WHERE date=v_start and chng<0               INTO v_dec0;
        SELECT count(code) FROM tbl_change WHERE date=v_start and chng>=8              INTO v_inc8;
        SELECT count(code) FROM tbl_change WHERE date=v_start and chng<8 and chng>=5   INTO v_inc5;
        SELECT count(code) FROM tbl_change WHERE date=v_start and chng<5 and chng>=2   INTO v_inc2;
        SELECT count(code) FROM tbl_change WHERE date=v_start and chng<2 and chng>=0   INTO v_inc1;
        SELECT count(code) FROM tbl_change WHERE date=v_start and chng<0  and chng>=-2 INTO v_dec1;
        SELECT count(code) FROM tbl_change WHERE date=v_start and chng<-2 and chng>=-5 INTO v_dec2;
        SELECT count(code) FROM tbl_change WHERE date=v_start and chng<-5 and chng>=-8 INTO v_dec5;
        SELECT count(code) FROM tbl_change WHERE date=v_start and chng<-8              INTO v_dec8;

        INSERT INTO tbl_stat_change(date, inc, dec0, 
                inc8 ,inc5 ,inc2 ,inc1 ,dec1 ,dec2 ,dec5 ,dec8 )
        VALUES(v_start, v_inc, v_dec0, 
                v_inc8 ,v_inc5 ,v_inc2 ,v_inc1 ,v_dec1 ,v_dec2 ,v_dec5 ,v_dec8 );
        -- LEAVE tag_stat_change;
    END WHILE;

END tag_stat_change //

DROP PROCEDURE IF EXISTS sp_stat_turnov//
CREATE PROCEDURE sp_stat_turnov(a_code INT(6) ZEROFILL) tag_turnov:BEGIN
    DECLARE v_close     DECIMAL(8,2) DEFAULT 0;
    DECLARE v_sink      DECIMAL(12,2) DEFAULT 0;
    DECLARE v_rise      DECIMAL(12,2) DEFAULT 0;
    DECLARE v_nmc       DECIMAL(12,2) DEFAULT 0;

    -- for output
    DECLARE net         DECIMAL(8,2) DEFAULT 0;
    DECLARE sum         DECIMAL(8,2) DEFAULT 0;
    DECLARE sink        DECIMAL(8,2) DEFAULT 0;
    DECLARE rise        DECIMAL(8,2) DEFAULT 0;

    call sp_create_tempday();

    INSERT INTO tempday(code,date,yesc,open,high,low,close,volume)
        SELECT code,date,yesc,open,high,low,close,volume FROM day 
        WHERE code=a_code and date>=@START and date<=@END;

    -- SELECT * FROM tempday;
    call sp_cp_tbl('tempday', 'forever');

    SELECT SUM(volume) FROM tempday WHERE (close-yesc)/yesc > 0 INTO v_rise;
    SELECT SUM(volume) FROM tempday WHERE (close-yesc)/yesc <=0 INTO v_sink;
    SELECT close,nmc   FROM cap     WHERE code=a_code           INTO v_close,v_nmc;

    -- SELECT date, volume FROM tempday WHERE (close-yesc)/yesc > 0;
    -- SELECT date, volume FROM tempday WHERE (close-yesc)/yesc <=0;
    -- SELECT v_rise, v_sink, v_close, v_nmc;

    -- 时段内全跌时v_rise将为NULL;
    IF v_rise IS NULL THEN SET v_rise = 0; END IF;
    IF v_sink IS NULL THEN SET v_sink = 0; END IF;

    SET rise = 100 * v_rise * v_close / v_nmc;
    SET sink = 100 * v_sink * v_close / v_nmc;
    SET sum  = rise + sink;
    SET net  = rise - sink;
    SELECT code, @START, @END, rise, sink, net, sum, nmc, name FROM cap WHERE code=a_code;
END tag_turnov //

-- 暂时不进行除权处理
DROP PROCEDURE IF EXISTS sp_get_down_turnov//
CREATE PROCEDURE sp_get_down_turnov(a_code INT(6) ZEROFILL) tag_100d_turnov:BEGIN
    DECLARE v_high      DECIMAL(6,2) DEFAULT 0;
    DECLARE v_low       DECIMAL(6,2) DEFAULT 0;
    DECLARE v_date_high DATE DEFAULT NULL;
    DECLARE v_date_low  DATE DEFAULT NULL;

    -- 双日顶修正 _h0为最高日前一日
    DECLARE v_yesdate   DATE DEFAULT NULL;
    DECLARE v_yesclose  DECIMAL(6,2) DEFAULT 0;

    DECLARE v_trade     DECIMAL(8,2) DEFAULT 0;
    DECLARE v_close     DECIMAL(8,2) DEFAULT 0;
    DECLARE v_sink      DECIMAL(12,2) DEFAULT 0;
    DECLARE v_rise      DECIMAL(12,2) DEFAULT 0;
    DECLARE v_nmc       DECIMAL(12,2) DEFAULT 0;

    -- SUM(volume)修正
    DECLARE v_chng0     DECIMAL(12,2) DEFAULT 0;
    DECLARE v_rise0     DECIMAL(12,2) DEFAULT 0;
    DECLARE v_rise1     DECIMAL(12,2) DEFAULT 0;
    
    -- for output
    DECLARE net         DECIMAL(8,2) DEFAULT 0;
    DECLARE sum         DECIMAL(8,2) DEFAULT 0;
    DECLARE sink        DECIMAL(8,2) DEFAULT 0;
    DECLARE rise        DECIMAL(8,2) DEFAULT 0;
    DECLARE avrg        DECIMAL(8,2) DEFAULT 0;

    -- 价格变化振幅
    DECLARE swing       DECIMAL(8,2) DEFAULT 0;

    call sp_create_tempday();

    -- INSERT INTO tempday(code,date,yesc,open,high,low,close,volume)
    --     SELECT code,date,yesc,open,high,low,close,volume FROM day 
    --     WHERE code=a_code and date<=@END order by date DESC LIMIT 30;

    SET @sqls=concat('
        INSERT INTO tempday(code,date,yesc,open,high,low,close,volume,amount)
        SELECT code,date,yesc,open,high,low,close,volume,amount FROM day WHERE code=', 
        a_code, " and date<= '", @END, "' order by date DESC LIMIT ", @NUM);
    PREPARE stmt from @sqls; EXECUTE stmt;

    -- 新股首日yesc设为open
    UPDATE tempday SET yesc=open WHERE id=1;

    -- 在trim前选出trade值，不能用 SELECT 嵌套 来操作临时表
    SELECT close FROM tempday ORDER by date DESC LIMIT 1 INTO v_trade;

    IF @DOWNSLOPE = 1 THEN
        -- 取下降段，概率性会有相同的high和low. v_low 取最低的 close 会是如何？
        SELECT date,close FROM tempday order by high DESC limit 1 INTO v_date_high,v_close;
        SELECT date,low   FROM tempday 
               WHERE date>=v_date_high order by low  ASC  limit 1 INTO v_date_low ,v_low;

        -- 在阶段之顶
        IF v_date_low = v_date_high THEN 
            -- SELECT 'MYGOD', a_code, v_date_low , v_date_high;
            LEAVE tag_100d_turnov; 
        END IF;

        -- 考虑双日顶，high日跌，边界前移一日. （v_date_high won't be ture high date）
        SELECT date,close      FROM tempday 
               WHERE date<v_date_high order by date DESC limit 1 INTO v_yesdate,v_yesclose;
        -- swing将作为一个重要指标，此处high日的均价为v_high，数据更准确
        SELECT (amount/volume) FROM tempday WHERE date = v_date_high INTO v_high;
        IF v_close < v_yesclose THEN 
            SET v_date_high=v_yesdate;
        END IF;

        DELETE FROM tempday WHERE date<v_date_high OR date>v_date_low; 
        -- 为拉大swing的权重，使用 v_low作为被除数 20 25 ---> 1/8=0.125
        -- 因为上面的date>=v_date_high，不必再次取high和low
        SET swing= 100 * (v_low-v_high) / v_low;

        -- v_chng0 < 0 为正常情况
        SELECT (close-yesc), volume FROM tempday WHERE date=v_date_high INTO v_chng0, v_rise0;
        IF v_chng0 < 0 THEN SET v_rise0 = 0; END IF; 
        SELECT (close-yesc), volume FROM tempday WHERE date=v_date_low  INTO v_chng0, v_rise1;
        IF v_chng0 < 0 THEN SET v_rise1 = 0; END IF; 
    ELSE
        -- 取上升段
        SELECT date,low  FROM tempday order by low  ASC  limit 1 INTO v_date_low ,v_low;
        SELECT date,high FROM tempday 
               WHERE date>v_date_low  order by high ASC  limit 1 INTO v_date_high,v_high;
        DELETE FROM tempday WHERE date<v_date_low OR date>v_date_high; 
        SET swing= 100 * (v_high-v_low) / v_low;
    END IF;

    -- 指定日期，股票可能停市
    IF v_date_low IS NULL OR v_date_high IS NULL THEN
    --  SELECT "pause", a_code, v_date_low, v_date_high;
        LEAVE tag_100d_turnov;
    END IF;
    
    -- SELECT * FROM tempday;
    -- call sp_cp_tbl('tempday', 'forever');

    SELECT SUM(amount)/SUM(volume) FROM tempday                 INTO avrg;
    SELECT SUM(volume) FROM tempday WHERE (close-yesc)/yesc > 0 INTO v_rise;
    SELECT SUM(volume) FROM tempday WHERE (close-yesc)/yesc <=0 INTO v_sink;
    SELECT close,nmc   FROM cap     WHERE code=a_code  LIMIT 1  INTO v_close,v_nmc;

    -- 时段内全跌时v_rise将为NULL;
    IF v_rise IS NULL THEN SET v_rise = 0; END IF;
    IF v_sink IS NULL THEN SET v_sink = 0; END IF;

    -- 最高价日为红，则70%计入下跌换手; 为绿，全为下跌换手
    SET v_rise = v_rise - v_rise0;
    SET v_sink = v_sink + v_rise0*0.7;

    -- 最低价日为红，不计入上升换手; 为绿，全为下跌换手
    SET v_rise = v_rise - v_rise1;

    SET rise = 100 * v_rise * v_close / v_nmc;
    SET sink = 100 * v_sink * v_close / v_nmc;
    SET sum  = rise + sink;
    SET net  = rise - sink;

    -- SELECT a_code, v_date_high, v_date_low, v_high, v_low, net, rally;
    INSERT INTO tbl_sink(code,date_high,   date_low,swing, rise, sink, net, sum,   low, avrg,  trade)
             VALUES(a_code, v_date_high, v_date_low,swing, rise, sink, net, sum, v_low, avrg,v_trade);

END tag_100d_turnov //

DROP PROCEDURE IF EXISTS sp_dugu9jian//
CREATE PROCEDURE sp_dugu9jian(a_code INT(6) ZEROFILL) tag_9jian:BEGIN
    -- 9jian
    DECLARE v_id        INT DEFAULT 1; 
    DECLARE v_open      DECIMAL(6,2) DEFAULT 0;
    DECLARE v_close     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_chng      DECIMAL(8,2) DEFAULT 0;
    DECLARE v_low       DECIMAL(8,2) DEFAULT 0;
    DECLARE v_avrg      DECIMAL(8,2) DEFAULT 0;
    DECLARE v_date1     DATE DEFAULT NULL;
    DECLARE v_date2     DATE DEFAULT NULL;
    DECLARE v_shares    INT DEFAULT 0;
    DECLARE v_shares0   INT DEFAULT 0;
    DECLARE v_volume    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_amount    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_sumvolume DECIMAL(12,2) DEFAULT 0;
    DECLARE v_sumamount DECIMAL(12,2) DEFAULT 0;
    DECLARE v_turnov    DECIMAL(12,2) DEFAULT 0;

    call sp_create_tempday();
    SELECT nmc/close FROM cap WHERE code=a_code LIMIT 1 INTO v_shares;
    SET v_shares0 = v_shares * @NMC_RATIO;
    -- 可以通过 turnover = latest(volume/shares); 来计算相应日期数 @NUM
    SET @sqls=concat('
        INSERT INTO tempday(code,date,yesc,open,high,low,close,volume,amount)
        SELECT code,date,yesc,open,high,low,close,volume,amount FROM day WHERE code=', 
        a_code, " and date<= '", @END, "' order by date DESC LIMIT ", @NUM);
    PREPARE stmt from @sqls; EXECUTE stmt;

    SELECT count(*)   FROM tempday INTO @v_len;
    SELECT date,close,low FROM tempday WHERE id=1 INTO v_date2,v_close,v_low;

    -- 过滤停牌很久的个股
    IF DATE_ADD(v_date2, INTERVAL 5 DAY) < @END THEN 
        # SELECT a_code, "a stop one";
        LEAVE tag_9jian; 
    END IF;

    lbl_upto_100: WHILE v_id <= @v_len DO
        SELECT volume,amount FROM tempday WHERE id=(v_id) INTO v_volume,v_amount;

        SET v_sumvolume = v_sumvolume + v_volume;
        SET v_sumamount = v_sumamount + v_amount;

        -- upto 100% turnover or 双周浮盈计算
        IF  v_sumvolume >= v_shares0 OR ((@NUM < 10) AND (v_id = @v_len)) THEN 
            SELECT date,yesc FROM tempday WHERE id=(v_id) INTO v_date1,v_open;
            SET v_avrg = (v_sumamount/v_sumvolume);
            SET v_chng = 100*(v_close-v_open)/v_open;
            SET v_turnov = 100*v_sumvolume/v_shares;
            -- SET v_wchng = 100*(v_close-v_avrg)/v_avrg;
            -- SELECT * FROM tempday;
            -- SELECT v_id;
            INSERT INTO tbl_9jian(code,date1,date2,off,open,low,close,
                            amount,volume,turnov,avrg,chng)
                     VALUES(a_code,v_date1,v_date2,v_id,v_open,v_low,v_close,
                            v_sumamount,v_sumvolume,v_turnov, v_avrg, v_chng);
            LEAVE lbl_upto_100; 
        END IF;

        SET v_id = v_id + 1;
    END WHILE lbl_upto_100;
END tag_9jian //

DROP PROCEDURE IF EXISTS sp_taox//
CREATE PROCEDURE sp_taox(a_code INT(6) ZEROFILL) tag_taox:BEGIN
    -- taox
    DECLARE v_cnt100    INT DEFAULT 0; 
    DECLARE v_id        INT DEFAULT 1; 
    DECLARE v_off_c     INT DEFAULT 1; 
    DECLARE v_off_p     INT DEFAULT 1; 

    DECLARE v_close     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ratio     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_wchng     DECIMAL(6,2) DEFAULT 0;

    DECLARE v_avrg      DECIMAL(8,2) DEFAULT 0;
    DECLARE v_avrg_c    DECIMAL(8,2) DEFAULT 0;
    DECLARE v_avrg_p    DECIMAL(8,2) DEFAULT 0;

    DECLARE v_date      DATE DEFAULT NULL;
    DECLARE v_date_c    DATE DEFAULT NULL;
    DECLARE v_date_p    DATE DEFAULT NULL;

    DECLARE v_turnov    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_turnov_c  DECIMAL(12,2) DEFAULT 0;
    DECLARE v_turnov_p  DECIMAL(12,2) DEFAULT 0;

    DECLARE v_shares    INT DEFAULT 0;
    DECLARE v_shares0   INT DEFAULT 0;
    DECLARE v_volume    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_amount    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_sumvolume DECIMAL(12,2) DEFAULT 0;
    DECLARE v_sumamount DECIMAL(12,2) DEFAULT 0;


    call sp_create_tempday();
    SELECT nmc/close FROM cap WHERE code=a_code LIMIT 1 INTO v_shares;
    SET v_shares0 = v_shares * @NMC_RATIO;
    -- 可以通过 turnover = latest(volume/shares); 来计算相应日期数 @NUM
    SET @sqls=concat('
        INSERT INTO tempday(code,date,yesc,open,high,low,close,volume,amount)
        SELECT code,date,yesc,open,high,low,close,volume,amount FROM day WHERE code=', 
        a_code, " and date<= '", @END, "' order by date DESC LIMIT ", @NUM);
    PREPARE stmt from @sqls; EXECUTE stmt;

    SELECT count(*)   FROM tempday INTO @v_len;
    SELECT date,close FROM tempday WHERE id=1 INTO v_date,v_close;

    -- 过滤停牌很久的个股
    IF DATE_ADD(v_date, INTERVAL 5 DAY) < @END and @FORCE <> 1 THEN 
        SELECT a_code, @END, "a stop one";
        LEAVE tag_taox; 
    END IF;

    -- SELECT  v_shares0;

    lbl_upto_100: WHILE v_id <= @v_len DO
        SELECT volume,amount FROM tempday WHERE id=(v_id) INTO v_volume,v_amount;

        SET v_sumvolume = v_sumvolume + v_volume;
        SET v_sumamount = v_sumamount + v_amount;

        -- SELECT  v_sumvolume,v_sumamount;

        -- upto 100% turnover
        IF  v_sumvolume >= v_shares0 THEN 
            SET v_avrg = (v_sumamount/v_sumvolume);
            SET v_turnov = 100*v_sumvolume/v_shares;
            SET v_sumvolume = 0;
            SET v_sumamount = 0;

            IF  v_cnt100 = 0 THEN 
                -- SELECT v_id;
                SET v_cnt100 = 1;
                SET v_avrg_c    = v_avrg;
                SET v_turnov_c  = v_turnov;
                set v_off_c     = v_id;
                set v_date_c    = v_date;
                SET v_wchng     = 100 * (v_close-v_avrg_c)/v_avrg_c;
            ELSE
                SELECT date FROM tempday WHERE id=(v_off_c+1) INTO v_date;
                SET v_cnt100 = 2;
                SET v_avrg_p    = v_avrg;
                SET v_turnov_p  = v_turnov;
                SET v_off_p     = v_id - v_off_c;
                set v_date_p    = v_date;

                SET v_ratio     = 100 * (v_avrg_c-v_avrg_p) / v_avrg_c;
                INSERT INTO tbl_taox(code,  date_p,off_p,avrg_p,turnov_p, 
                                            date_c,off_c,avrg_c,turnov_c,ratio,wchng)
                         VALUES(a_code,   v_date_p,v_off_p,v_avrg_p,v_turnov_p, 
                                          v_date_c,v_off_c,v_avrg_c,v_turnov_c,v_ratio,v_wchng);

                INSERT INTO tbl_tao5(code,  date_p,off_p,avrg_p,turnov_p, 
                                            date_c,off_c,avrg_c,turnov_c,ratio,wchng)
                         VALUES(a_code,   v_date_p,v_off_p,v_avrg_p,v_turnov_p, 
                                          v_date_c,v_off_c,v_avrg_c,v_turnov_c,v_ratio,v_wchng);
                LEAVE lbl_upto_100;
            END IF;

        END IF;

        SET v_id = v_id + 1;
    END WHILE lbl_upto_100;

    IF v_cnt100 < 2 THEN
        -- 使用数据库文件实现EXIT_CODE
        -- SELECT a_code, "so_little_taox_data";
        INSERT INTO exitcode VALUES (1);
    END IF;
    -- SELECT v_cnt100;
END tag_taox //

DROP PROCEDURE IF EXISTS sp_6maishenjian//
CREATE PROCEDURE sp_6maishenjian(a_code INT(6) ZEROFILL) tag_6mai:BEGIN
    -- 6mai
    DECLARE v_id        INT DEFAULT 1; 
    DECLARE v_open      DECIMAL(6,2) DEFAULT 0;
    DECLARE v_close     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_chng      DECIMAL(8,2) DEFAULT 0;
    DECLARE v_low       DECIMAL(8,2) DEFAULT 0;
    DECLARE v_avrg      DECIMAL(8,2) DEFAULT 0;
    DECLARE v_date1     DATE DEFAULT NULL;
    DECLARE v_date2     DATE DEFAULT NULL;
    DECLARE v_datemax   DATE DEFAULT NULL;
    DECLARE v_shares    INT DEFAULT 0;
    DECLARE v_shares0   INT DEFAULT 0;
    DECLARE v_volume    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_amount    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_sumvolume DECIMAL(12,2) DEFAULT 0;
    DECLARE v_sumamount DECIMAL(12,2) DEFAULT 0;
    DECLARE v_turnov    DECIMAL(12,2) DEFAULT 0;

    call sp_create_tempday();
    SELECT nmc/close FROM cap WHERE code=a_code LIMIT 1 INTO v_shares;
    SET v_shares0 = v_shares * @NMC_RATIO;

    -- 可以通过 turnover = latest(volume/shares); 来计算相应日期数 @NUM
    SET @sqls=concat('
        INSERT INTO tempday(code,date,yesc,open,high,low,close,volume,amount)
        SELECT code,date,yesc,open,high,low,close,volume,amount FROM day WHERE code=', 
        a_code, " and date<= '", @END, "' order by date DESC LIMIT ", @NUM);
    PREPARE stmt from @sqls; EXECUTE stmt;

    SELECT count(*) FROM tempday INTO @v_len;
    SELECT date     FROM tempday WHERE id=1 INTO v_datemax;

    -- 13日内最低价日
    SELECT id,date,close,low FROM tempday WHERE id<=13 order by low asc LIMIT 1 
                                 INTO v_id,v_date2,v_close,v_low;

    -- 过滤停牌很久的个股
    IF DATE_ADD(v_datemax, INTERVAL 5 DAY) < @END THEN LEAVE tag_6mai; END IF;

    lbl_upto_100: WHILE v_id <= @v_len DO
        SELECT volume,amount FROM tempday WHERE id=(v_id) INTO v_volume,v_amount;

        SET v_sumvolume = v_sumvolume + v_volume;
        SET v_sumamount = v_sumamount + v_amount;

        -- upto 100% turnover
        IF  v_sumvolume >= v_shares0 THEN 
            SELECT date,yesc FROM tempday WHERE id=(v_id) INTO v_date1,v_open;
            SET v_avrg = (v_sumamount/v_sumvolume);
            SET v_chng = 100*(v_close-v_open)/v_open;
            SET v_turnov = 100*v_sumvolume/v_shares;
            -- SET v_wchng = 100*(v_close-v_avrg)/v_avrg;
            -- SELECT * FROM tempday;
            -- SELECT v_id;
            INSERT INTO tbl_6mai(code,date1,date2,off,open,low,close,
                            amount,volume,turnov,avrg,chng)
                     VALUES(a_code,v_date1,v_date2,v_id,v_open,v_low,v_close,
                            v_sumamount,v_sumvolume,v_turnov, v_avrg, v_chng);
            LEAVE lbl_upto_100; 
        END IF;

        SET v_id = v_id + 1;
    END WHILE lbl_upto_100;
END tag_6mai //

DROP PROCEDURE IF EXISTS sp_get_ma513//
CREATE PROCEDURE sp_get_ma513(a_code INT(6) ZEROFILL) tag_get_ma513:BEGIN
    DECLARE v_ma5      DECIMAL(6,2)  DEFAULT 0;
    DECLARE v_ma13     DECIMAL(6,2)  DEFAULT 0;
    DECLARE v_vol      DECIMAL(12,2) DEFAULT 0;
    DECLARE v_vol5     DECIMAL(12,2) DEFAULT 0;
    DECLARE v_vol13    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_close    DECIMAL(6,2)  DEFAULT 0;
    DECLARE v_high     DECIMAL(6,2)  DEFAULT .1;
    DECLARE v_low      DECIMAL(6,2)  DEFAULT .1;

    call sp_create_tempday();

    -- 14th
    SELECT date FROM day WHERE code=a_code and date<=@END ORDER by 
           date DESC limit 13,1 INTO @START;

    INSERT INTO tempday(code,date,close,volume) SELECT 
           code,date,close,volume FROM day WHERE code=a_code and date>@START and date<=@END;

    -- 13 34 55 100
    SELECT count(*) FROM tempday INTO @v_len;
    SELECT close,volume FROM tempday WHERE id=@v_len INTO v_close,v_vol;

    IF @v_len < 13 THEN LEAVE tag_get_ma513; END IF;

    -- ma 即有平均的意义，但vol没有
    SELECT SUM(close)/5,  SUM(volume) FROM tempday WHERE id>(@v_len-5) INTO v_ma5, v_vol5;
    SELECT SUM(close)/13, SUM(volume), MAX(close), MIN(close)
                                      FROM tempday INTO v_ma13, v_vol13, v_high, v_low;

    INSERT INTO tbl_ma513 (  code,   close,   ma5,   ma13,   vol,   vol5,   vol13,  high,   low)
                    VALUES(a_code, v_close, v_ma5, v_ma13, v_vol, v_vol5, v_vol13,v_high, v_low);
END tag_get_ma513 //

-- 考虑使用ma34代替ma34
DROP PROCEDURE IF EXISTS sp_up_ma34//
CREATE PROCEDURE sp_up_ma34(a_code INT(6) ZEROFILL) tag_up_ma34:BEGIN
    DECLARE v_date     DATE;
    DECLARE v_count    INT(6) DEFAULT 0;
    DECLARE v_close    DECIMAL(6,2) DEFAULT 0;
    DECLARE v_low      DECIMAL(6,2) DEFAULT 0;
    DECLARE v_high     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ma34     DECIMAL(6,2) DEFAULT 0;

    call sp_create_tempday();

    -- 240 cycle
    SELECT date FROM day WHERE code=a_code and date<=@END ORDER by 
           date DESC limit 240,1 INTO @START;

    INSERT INTO tempday(code,date,close) SELECT 
           code,date,close FROM day WHERE code=a_code and date>=@START and date<=@END;

    -- via high, induct is a long-cycle invaste one
    SELECT count(*)   FROM tempday INTO @v_len;
    SELECT date,close FROM tempday WHERE id=@v_len INTO v_date,v_close;

    IF @v_len < 240 THEN LEAVE tag_up_ma34; END IF;

    SELECT min(close),max(close) 
                           FROM tempday WHERE id>(@v_len-@NUM) INTO v_low,v_high;
    SELECT SUM(close)/34   FROM tempday WHERE id>(@v_len-34)    INTO v_ma34 ;

    UPDATE tbl_ma240 SET date=v_date,close=v_close,
                         ma34=v_ma34,low=v_low,high=v_high WHERE code = a_code;
END tag_up_ma34 //

DROP PROCEDURE IF EXISTS sp_get_ma240//
CREATE PROCEDURE sp_get_ma240(a_code INT(6) ZEROFILL) tag_get_ma240:BEGIN
    DECLARE v_date     DATE;
    DECLARE v_low      DECIMAL(6,2) DEFAULT 0;
    DECLARE v_high     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_close    DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ma34     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ma60     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ma120    DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ma240    DECIMAL(6,2) DEFAULT 0;

    call sp_create_tempday();

    -- 240
    SELECT date FROM day WHERE code=a_code and date<=@END ORDER by 
           date DESC limit 240,1 INTO @START;

    INSERT INTO tempday(code,date,close) SELECT 
           code,date,close FROM day WHERE code=a_code and date>=@START and date<=@END;

    -- via high, induct is a long-cycle invaste one
    SELECT count(*)   FROM tempday INTO @v_len;
    SELECT date,close FROM tempday WHERE id=@v_len INTO v_date,v_close;

    IF @v_len < 240 THEN LEAVE tag_get_ma240; END IF;

    SELECT min(close),max(close)
                           FROM tempday WHERE id>(@v_len-@NUM) INTO v_low,v_high;
    SELECT SUM(close)/34   FROM tempday WHERE id>(@v_len-34)    INTO v_ma34 ;
    SELECT SUM(close)/60   FROM tempday WHERE id>(@v_len-60)    INTO v_ma60 ;
    SELECT SUM(close)/120  FROM tempday WHERE id>(@v_len-120)   INTO v_ma120;
    SELECT SUM(close)/240  FROM tempday WHERE id>(@v_len-240)   INTO v_ma240;

    -- SELECT v_ma34, v_ma60, v_ma120, v_ma240;

    INSERT INTO tbl_ma240 (code,     date,  low,  high,  close,  ma34,  ma60,   ma120,   ma240)
                    VALUES(a_code, v_date,v_low,v_high,v_close,v_ma34,v_ma60, v_ma120, v_ma240);
END tag_get_ma240 //

DROP PROCEDURE IF EXISTS sp_get_ma144//
CREATE PROCEDURE sp_get_ma144(a_code INT(6) ZEROFILL) tag_get_ma144:BEGIN
    DECLARE v_date     DATE;
    DECLARE v_low      DECIMAL(6,2) DEFAULT 0;
    DECLARE v_width    DECIMAL(6,2) DEFAULT 0;
    DECLARE v_high     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_close    DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ma13     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ma34     DECIMAL(6,2) DEFAULT 0;
    DECLARE v_ma144    DECIMAL(6,2) DEFAULT 0;

    call sp_create_tempday();

    SELECT date FROM day WHERE code=a_code and date<=@END ORDER by 
           date DESC limit 144,1 INTO @START;

    INSERT INTO tempday(code,date,close) SELECT 
           code,date,close FROM day WHERE code=a_code and date>=@START and date<=@END;

    -- via high, induct is a long-cycle invaste one
    SELECT count(*)   FROM tempday INTO @v_len;
    SELECT date,close FROM tempday WHERE id=@v_len INTO v_date,v_close;

    IF @v_len < 144 THEN LEAVE tag_get_ma144; END IF;

    SELECT min(close),max(close) 
                           FROM tempday WHERE id>(@v_len-@NUM) INTO v_low,v_high;
    SELECT SUM(close)/13   FROM tempday WHERE id>(@v_len-13)    INTO v_ma13 ;
    SELECT SUM(close)/34   FROM tempday WHERE id>(@v_len-34)    INTO v_ma34 ;
    SELECT SUM(close)/144  FROM tempday WHERE id>(@v_len-144)   INTO v_ma144;

    SET v_width = 2*(v_high-v_low)/(v_high+v_low);      -- .2之内为比较好的值
    INSERT INTO tbl_ma144 (code,     date,  low,  width,  high,  close,  ma13,  ma34,  ma144)
                    VALUES(a_code, v_date,v_low,v_width,v_high,v_close,v_ma13,v_ma34,v_ma144);
END tag_get_ma144 //

DROP PROCEDURE IF EXISTS sp_stat_linqi//
CREATE PROCEDURE sp_stat_linqi() tag_stat_linqi:BEGIN
    DECLARE v_membs INT; 
    DECLARE v_len   INT; /* CURSOR and HANDLER declare in end of declaration */
    DECLARE v_id    INT DEFAULT 1; 
    DECLARE v_date  date DEFAULT 0; 
    DECLARE v_yesc  DECIMAL(6,2) DEFAULT 1000;
    DECLARE v_open  DECIMAL(6,2) DEFAULT 0;
    DECLARE v_close DECIMAL(6,2) DEFAULT 0;
    DECLARE v_high  DECIMAL(6,2) DEFAULT 0;
    DECLARE v_low   DECIMAL(6,2) DEFAULT 0;

    DROP TABLE IF EXISTS dlinqi;                /* open days */
    CREATE TABLE dlinqi (
        id          INT(6) PRIMARY key AUTO_INCREMENT NOT NULL,
        date        date NOT NULL,
        INDEX(date)
    );

    DROP   TABLE IF EXISTS ilinqi;    /* index of linqi */
    CREATE TABLE ilinqi (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        date        date NOT NULL,
        yesc        DECIMAL(6,2) NOT NULL,
        open        DECIMAL(6,2) NOT NULL,
        high        DECIMAL(6,2) NOT NULL,
        low         DECIMAL(6,2) NOT NULL,
        close       DECIMAL(6,2) NOT NULL,
        INDEX(date)
    );

    SET @start_linqi = '2014-08-01';
    call sp_create_tempday();
    INSERT INTO tempday(code,date,yesc,open,high,low,close,volume)
        SELECT d.code,d.date,yesc,open,high,low,close,volume FROM day as d,linqi as l 
        WHERE d.date >= @start_linqi and d.code = l.code;
    INSERT INTO dlinqi (date) SELECT date from day WHERE code = 900001 and date>=@start_linqi;

    SELECT max(id)   FROM dlinqi INTO v_len;
    SELECT count(*)  FROM linqi  INTO v_membs;

    SELECT v_len;
    # SELECT * from tempday;

    WHILE v_id <= v_len DO
        SELECT date FROM dlinqi WHERE id=(v_id) INTO v_date;
        SELECT (sum( open/yesc)+(v_membs-count(*)))/v_membs*v_yesc FROM tempday WHERE date=v_date INTO v_open;
        SELECT (sum(close/yesc)+(v_membs-count(*)))/v_membs*v_yesc FROM tempday WHERE date=v_date INTO v_close;
        SELECT (sum( high/yesc)+(v_membs-count(*)))/v_membs*v_yesc FROM tempday WHERE date=v_date INTO v_high;
        SELECT (sum( low /yesc)+(v_membs-count(*)))/v_membs*v_yesc FROM tempday WHERE date=v_date INTO v_low;
        INSERT INTO ilinqi (date,  yesc, open,  high, low, close)
                    VALUES(v_date,v_yesc, v_open, v_high,v_low,v_close);
        SET v_yesc = v_close;
        SET v_id = v_id + 1;
    END WHILE;

END tag_stat_linqi //

-- 一些需要与shell通信的系统变量

    SET @fn_flt_kdj_up          = 1;   
    SET @fn_flt_13d_sink        = 2;
    SET @fn_flt_n_day_change    = 3;
    SET @fn_get_down_turnov     = 4;
    SET @fn_get_ma513           = 5;
    SET @fn_up_ma240_34         = 7;
    SET @fn_up_ma144_all        = 8;
    SET @fn_up_ma240_all        = 9;
    SET @fn_dugu9jian           = 10;
    SET @fn_6maishenjian        = 11;
    SET @fn_taox_ratio          = 12;
    SET @FORCE                  = 0;    -- 1时强制计算过滤停牌很久的个股
    SET @START      = '2013-12-6';
    SET @END        = '2014-11-26';
    SET @NUM        = 240;
    SET @NMC_RATIO  = 1;
    
-- 若要计算3日，argv_n为3

    SET @argv_change = 12;
    SET @argv_n = 3;

-- 每个SP中创建一个指定的私用表，如此，则只要在SP开头使用一次EXECUTE语句就可以了
-- 每个SP都有两个参数，一个表作为输入，一个code做为另一个输入

--  THIS EXECUTE DELIMITER

--  call sp_macd('day', 2);
--  call sp_kdj('day', 2, 9);
--  call sp_filter_kdj('cap');
--  call sp_flt_13d_sink(2);
--  call sp_kdj_wk('day', 750, 9);
--  call sp_7day('day', 750);

--  call sp_day('day', 750);
--  call sp_xRD();

--  call sp_visit_tbl('cap', @fn_flt_13d_sink); 
--  call sp_visit_tbl('cap', @fn_flt_n_day_change);
    
--  call sp_stat_linqi();
--  call sp_count_swing10();
--  call sp_stat_turnov(2);
--  call sp_get_down_turnov(2);
--  call sp_visit_tbl('cap', @fn_dugu9jian);
--  call sp_visit_tbl('cap', @fn_6maishenjian);
    call sp_visit_tbl('zxg', @fn_taox_ratio);
