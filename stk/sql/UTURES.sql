delimiter //

DROP PROCEDURE IF EXISTS sp_q5//
CREATE PROCEDURE sp_q5(a_code CHAR(6)) tag_q5:BEGIN
--  DROP   TEMPORARY TABLE IF EXISTS tempq5;
--  CREATE TEMPORARY TABLE tempq5 LIKE futures_q5;
    DROP             TABLE IF EXISTS tempq5;
    CREATE           TABLE tempq5 LIKE futures_q5;


    SET @sqls=concat("
        INSERT INTO tempq5(code,date,time,open,high,low,close,rise,chng,shou,amount)
        SELECT             code,date,time,open,high,low,close,rise,chng,shou,amount  FROM futures_q5 WHERE code='",
        a_code, "' and date> '", @END, "' ORDER by date DESC,time DESC LIMIT 256"
    ); 
--  SELECT @sqls;
    PREPARE stmt from @sqls; EXECUTE stmt;

    SET @sqls=concat("
       INSERT INTO tempq5(code,date,time,open,high,low,close,rise,chng,shou,amount)
        SELECT            code,date,time,open,high,low,close,rise,chng,shou,amount  FROM futures_f5 WHERE code='",
        a_code,                        "' ORDER by date DESC,time DESC LIMIT 256"
    ); PREPARE stmt from @sqls; EXECUTE stmt;

    DELETE FROM tempq5 WHERE id>256;
    UPDATE tempq5 SET close=(open+high+low+close)/4;
    SELECT count(*)  FROM tempq5 INTO @v_len;
    SELECT date,time,close FROM tempq5 WHERE id=1 INTO @v_date,@v_time,@v_close;
    IF @v_len < 80 THEN SELECT @v_len,"Not enough of", a_code; LEAVE tag_q5;END IF;

    SELECT AVG(close)               FROM tempq5 WHERE id<=4   INTO @ma4  ;
    SELECT AVG(close)               FROM tempq5 WHERE id<=16  INTO @ma16 ;
    SELECT AVG(close)               FROM tempq5 WHERE id<=64  INTO @ma64 ;
    SELECT AVG(close)               FROM tempq5 WHERE id<=256 INTO @ma256;
    SELECT max(close),min(close)    FROM tempq5 WHERE id<=64  INTO @max64,@min64;
    SELECT max(close),min(close)    FROM tempq5 WHERE id<=128 INTO @max128,@min128;
    SELECT STD(close)/@ma64     *100 FROM tempq5 WHERE id<=64  INTO @sd_d1 ;
    SELECT STD(close)/AVG(close)*100 FROM tempq5 WHERE id<=128 INTO @sd_d2;

    SELECT 100*LEAST(abs(@v_close/@max64-1) ,abs(@v_close/@min64-1))  INTO @pk_d1;
    SELECT 100*LEAST(abs(@v_close/@max128-1),abs(@v_close/@min128-1)) INTO @pk_d2;

    SET @a1 = (@v_close+@ma4+@ma16)/3;
    SET @a2 = (@ma4+@ma16+@ma64)/3;
    SET @a3 = (@ma16+@ma64+@ma256)/3;

    INSERT INTO pro_q5(code,  date,   time,   close, ma4, ma16, ma64, ma256, a1, a2, a3, sd_d1, sd_d2, pk_d1, pk_d2)
             VALUES(a_code,@v_date,@v_time,@v_close,@ma4,@ma16,@ma64,@ma256,@a1,@a2,@a3,@sd_d1,@sd_d2,@pk_d1,@pk_d2);
END tag_q5 //

DROP PROCEDURE IF EXISTS sp_visit_tbl//
CREATE PROCEDURE sp_visit_tbl() tag_visit:BEGIN
    DECLARE v_code  CHAR(8);
    DECLARE v_id    INT DEFAULT 1; 
    DECLARE v_len   INT;                                    /* CURSOR and HANDLER declare in end of declaration */
    
    DROP TABLE IF EXISTS ucodes;
    CREATE TABLE ucodes (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        CHAR(8)
        ,INDEX(code)
    );
    DROP TABLE IF EXISTS pro_q5; -- pro_q5
    CREATE TABLE pro_q5(
        id          int(6) ZEROFILL PRIMARY key AUTO_INCREMENT NOT NULL,
        code        CHAR(8),
        date        DATE,
        time        INT(4),
        close       DECIMAL(8,2) NOT NULL DEFAULT 0,
        ma4         DECIMAL(8,2) NOT NULL DEFAULT 0,
        ma16        DECIMAL(8,2) NOT NULL DEFAULT 0,
        ma64        DECIMAL(8,2) NOT NULL DEFAULT 0,
        ma256       DECIMAL(8,2) NOT NULL DEFAULT 0,
        a1          DECIMAL(8,2) NOT NULL DEFAULT 0,
        a2          DECIMAL(8,2) NOT NULL DEFAULT 0,
        a3          DECIMAL(8,2) NOT NULL DEFAULT 0,
        sd_d1       DECIMAL(8,2) NOT NULL DEFAULT 0,
        sd_d2       DECIMAL(8,2) NOT NULL DEFAULT 0,
        pk_d1       DECIMAL(8,2) NOT NULL DEFAULT 0,
        pk_d2       DECIMAL(8,2) NOT NULL DEFAULT 0,
        INDEX(code,date)
    );

    INSERT INTO ucodes(code) SELECT DISTINCT code FROM futures_q5 ORDER by code;
    SELECT max(id)   FROM ucodes INTO v_len;
    SELECT max(date) FROM futures_f5 INTO @END;

    -- pre-process
    -- visit all ucodes
    WHILE v_id <= v_len DO
        SELECT code FROM ucodes WHERE id=(v_id) INTO v_code;
        call sp_q5(v_code);
        SET v_id = v_id + 1;
    END WHILE;

    -- post-process
END tag_visit //

call sp_visit_tbl();
