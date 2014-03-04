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
        SELECT SUM(close)/a_period FROM ma WHERE id > v_i and id <=(a_period+v_i) INTO v_avrg;
        SET @sqls=concat('UPDATE ', a_tbl, ' SET ', a_x,' = ', v_avrg, ' WHERE id=', a_period+v_i);
        PREPARE stmt from @sqls; EXECUTE stmt;

        SET v_i = v_i + 1;
    UNTIL v_i+a_period > @v_masize END REPEAT;
END tag_avrg//

DROP PROCEDURE IF EXISTS sp_ma//
CREATE PROCEDURE sp_ma(a_tbl CHAR(20), a_code INT(6) ZEROFILL) tag_ma:BEGIN
    DROP TABLE IF EXISTS ma;
    CREATE TABLE ma (
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

    -- SET @sqls=concat('INSERT INTO ma(code,date,close) SELECT code,date,close FROM ',
    --     a_tbl, ' WHERE code=', a_code);
    -- PREPARE stmt from @sqls; EXECUTE stmt;

    INSERT INTO ma(code,date,close)
        SELECT code,date,close FROM day WHERE code=a_code and date<=@END;

    SELECT count(id) FROM ma INTO @v_masize;        -- don't use max(id), it will be null
    IF @v_masize = 0 THEN LEAVE tag_ma; END IF;

    -- long short dea 26 12 9
    call sp_avrg('ma', 'ma1', 5);
    call sp_avrg('ma', 'ma2', 13);
    call sp_avrg('ma', 'ma3', 34);
    call sp_avrg('ma', 'ma4', 55);
    call sp_avrg('ma', 'ma5', 100);
    call sp_avrg('ma', 'ma6', 144);
END tag_ma//

SET @END    = '2014-1-10';
call sp_ma('day', 002708);

-- 将最后30天记录INSERT到表 tbl_ma_recent 以做快速索引

