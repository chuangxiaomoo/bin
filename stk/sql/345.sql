-- ma 13 34 55

delimiter //

DROP PROCEDURE IF EXISTS sp_avrg//
CREATE PROCEDURE sp_avrg(a_tbl CHAR(20), a_x CHAR(20), a_period INT) tag_avrg:BEGIN
    DECLARE v_i         INT DEFAULT 0;
    DECLARE v_psub1     INT DEFAULT (a_period-1);
    DECLARE v_avrg      DECIMAL(6,3) DEFAULT 0;     -- prev
    DECLARE v_avrg0     DECIMAL(6,3) DEFAULT 0;     -- prev
    DECLARE v_avrg1     DECIMAL(6,3) DEFAULT 0;
    DECLARE v_close     DECIMAL(6,3) DEFAULT 0;

    -- method 1
    IF v_i+a_period > @v_masize THEN LEAVE tag_avrg; END IF;

    loop_visit: REPEAT
        SELECT SUM(close)/a_period FROM tbl_ma WHERE id > v_i and id <=(a_period+v_i) INTO v_avrg;
        SET @sqls=concat('UPDATE ', a_tbl, ' SET ', a_x,' = ', v_avrg, ' WHERE id=', a_period+v_i);
        PREPARE stmt from @sqls; EXECUTE stmt;

        SET v_i = v_i + 1;
    UNTIL v_i+a_period > @v_masize END REPEAT;
END tag_avrg//

DROP PROCEDURE IF EXISTS sp_ma//
CREATE PROCEDURE sp_ma(a_code INT(6) ZEROFILL) tag_ma:BEGIN
    DROP TABLE IF EXISTS tbl_ma;
    CREATE TABLE tbl_ma (
        id          INT(6) PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date        date NOT NULL,
        close       DECIMAL(6,2) NOT NULL DEFAULT 0,
        ma1         DECIMAL(6,3) NOT NULL DEFAULT 0,
        ma2         DECIMAL(6,3) NOT NULL DEFAULT 0,
        ma3         DECIMAL(6,3) NOT NULL DEFAULT 0,
        ma4         DECIMAL(6,3) NOT NULL DEFAULT 0,
        ma5         DECIMAL(6,3) NOT NULL DEFAULT 0,
        ma6         DECIMAL(6,3) NOT NULL DEFAULT 0,
        INDEX(date)
    );

    INSERT INTO tbl_ma(code,date,close)
        SELECT code,date,close FROM day WHERE code=a_code and date<=@END;

    SELECT count(id) FROM tbl_ma INTO @v_masize;        -- don't use max(id), it will be null
    IF @v_masize = 0 THEN LEAVE tag_ma; END IF;

    -- long short dea 26 12 9
    call sp_avrg('tbl_ma', 'ma1', 5);
    call sp_avrg('tbl_ma', 'ma2', 13);
    call sp_avrg('tbl_ma', 'ma3', 34);
    call sp_avrg('tbl_ma', 'ma4', 55);
 -- call sp_avrg('ma', 'ma5', 100);
 -- call sp_avrg('ma', 'ma6', 144);
END tag_ma//

-- 将最后30天记录INSERT到表 tbl_ma_recent 以做快速索引

DROP PROCEDURE IF EXISTS sp_visit_tbl//
CREATE PROCEDURE sp_visit_tbl(a_tbl CHAR(20)) tag_visit:BEGIN
    DECLARE v_code  INT(6) ZEROFILL;
    DECLARE v_id    INT DEFAULT 1; 
    DECLARE v_len   INT; /* CURSOR and HANDLER declare in end of declaration */
    
    DROP TABLE IF EXISTS codes;
    CREATE TABLE codes (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0
    );
    DROP TABLE IF EXISTS tbl_x20pool; -- for visit output
    CREATE TABLE tbl_x20pool(
        id          INT(6) PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        date        date NOT NULL,
        close       DECIMAL(6,2) NOT NULL DEFAULT 0,
        ma1         DECIMAL(6,3) NOT NULL DEFAULT 0,
        ma2         DECIMAL(6,3) NOT NULL DEFAULT 0,
        ma3         DECIMAL(6,3) NOT NULL DEFAULT 0,
        ma4         DECIMAL(6,3) NOT NULL DEFAULT 0,
        ma5         DECIMAL(6,3) NOT NULL DEFAULT 0,
        ma6         DECIMAL(6,3) NOT NULL DEFAULT 0,
        INDEX(code,date)
    );

    SET @cond=' ORDER by code';
    SET @sqls=concat('INSERT INTO codes(code) SELECT code FROM ', a_tbl, @cond);
    PREPARE stmt from @sqls; EXECUTE stmt;
    SELECT max(id)   FROM codes INTO v_len;
    SELECT max(date) FROM day WHERE code=900001 INTO @v_maxdate;

    WHILE v_id <= v_len DO
        SELECT code FROM codes WHERE id=(v_id) INTO v_code;
        call sp_ma(v_code);
        -- 读取后20条记录
        INSERT INTO tbl_x20pool (code,date,close,ma1,ma2,ma3,ma4,ma5)
            SELECT code,date,close,ma1,ma2,ma3,ma4,ma5 FROM tbl_ma WHERE id>(@v_masize-20) ;
        SET v_id = v_id + 1;
    END WHILE;
END tag_visit //

-- -------------------- Analyze functions begin ------------------------------

DROP PROCEDURE IF EXISTS sp_cross //
CREATE PROCEDURE sp_cross(a_code INT(6) ZEROFILL, a_maxid INT(6)) tag_cross:BEGIN
    DECLARE id_s    INT DEFAULT 0; 
    DECLARE id_e    INT DEFAULT 0; 
    DECLARE date_s  DATE;
    DECLARE date_e  DATE;

    -- start end maxid
    DECLARE v_s1    DECIMAL(6,3) DEFAULT 0; 
    DECLARE v_s2    DECIMAL(6,3) DEFAULT 0; 
    DECLARE v_s3    DECIMAL(6,3) DEFAULT 0; 

    DECLARE v_e1    DECIMAL(6,3) DEFAULT 0; 
    DECLARE v_e2    DECIMAL(6,3) DEFAULT 0; 
    DECLARE v_e3    DECIMAL(6,3) DEFAULT 0; 

    SET id_s = a_maxid - @AHEAD - @STEPS;
    SET id_e = id_s + @STEPS;

    SELECT ma1,ma2,ma3,date FROM tbl_x20pool WHERE id=id_s INTO v_s1,v_s2,v_s3,date_s;
    SELECT ma1,ma2,ma3,date FROM tbl_x20pool WHERE id=id_e INTO v_e1,v_e2,v_e3,date_e;

    SELECT v_e1 , v_e2 , v_s1 , v_s2, date_s,date_e; 
    -- ma5 up cross ma13
    IF v_e1 > v_e2 AND v_s1 < v_s2 THEN 
        SELECT "mygod", a_code;
        INSERT INTO tbl_analyz (code) VALUES(a_code);
    END IF;
END tag_cross //

DROP PROCEDURE IF EXISTS sp_ana//
CREATE PROCEDURE sp_ana(a_tbl CHAR(20)) tag_ana:BEGIN
    DECLARE v_code  INT(6) ZEROFILL;
    DECLARE v_id    INT DEFAULT 1; 
    DECLARE v_len   INT; /* CURSOR and HANDLER declare in end of declaration */

    DECLARE v_maxid INT DEFAULT 0; 
    
    DROP TABLE IF EXISTS codes;
    CREATE TABLE codes (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0
    );
    DROP TABLE IF EXISTS tbl_analyz;
    CREATE TABLE tbl_analyz (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0
    );

    SET @cond=' ORDER by code';
    SET @sqls=concat('INSERT INTO codes(code) SELECT code FROM ', a_tbl, @cond);
    PREPARE stmt from @sqls; EXECUTE stmt;
    SELECT max(id)   FROM codes INTO v_len;
    SELECT max(date) FROM day WHERE code=900001 INTO @v_maxdate;

    WHILE v_id <= v_len DO
        SELECT code FROM codes WHERE id=(v_id) INTO v_code;
        SELECT max(id) FROM tbl_x20pool WHERE code=v_code INTO v_maxid;
        call sp_cross(v_code, v_maxid);

     -- INSERT INTO tbl_x20pool (code,date,close,ma1,ma2,ma3,ma4,ma5)
     --     SELECT code,date,close,ma1,ma2,ma3,ma4,ma5 FROM tbl_ma WHERE id>(@v_masize-20) ;
        SET v_id = v_id + 1;
    END WHILE;
END tag_ana //

-- SET @END = '2014-3-10';
-- call sp_ma(002708);
-- @AHEAD=0 代表 date_e 是今天
SET @AHEAD=4;
SET @STEPS=1;
SET @END = '2014-3-13';
-- call sp_visit_tbl('cap');
call sp_ana('zxg');
