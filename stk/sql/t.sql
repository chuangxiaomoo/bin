--  kmysql <<< "source /root/bin/stk/sql/t.sql"

delimiter //

DROP PROCEDURE IF EXISTS sp_cp_tbl2 //
CREATE PROCEDURE sp_cp_tbl2(arg_tbl_fr INT(6) ZEROFILL) BEGIN
    DECLARE v_i  INT(6) ZEROFILL DEFAULT 123;
    SELECT v_i, arg_tbl_fr;
END //

DROP PROCEDURE IF EXISTS sp_cp_tbl //
CREATE PROCEDURE sp_cp_tbl(arg_tbl_fr INT(6)) BEGIN
    DECLARE v_i  INT(6) ZEROFILL DEFAULT 456;
    call sp_cp_tbl2(v_i);
END //



call sp_cp_tbl(34);

-- 

    CREATE TABLE IF NOT EXISTS mat_dde (
        id          INT PRIMARY key AUTO_INCREMENT NOT NULL,
        date        date NOT NULL DEFAULT 0,
        time        time NOT NULL, 
        code        INT(6) ZEROFILL NOT NULL DEFAULT 0,
        name        CHAR(16),
        pcnt        DECIMAL(6,2) NOT NULL DEFAULT 0, -- dec(p-n)/sum(p+n)
        pbuy        DECIMAL(6,2) NOT NULL DEFAULT 0,
        nbuy        DECIMAL(6,2) NOT NULL DEFAULT 0,
        psell       DECIMAL(6,2) NOT NULL DEFAULT 0,
        nsell       DECIMAL(6,2) NOT NULL DEFAULT 0,
        rise        DECIMAL(6,2) NOT NULL DEFAULT 0,
        trade       DECIMAL(6,2) NOT NULL DEFAULT 0,
        speed       DECIMAL(6,2) NOT NULL DEFAULT 0,
        shou        DECIMAL(8,2) NOT NULL DEFAULT 0,
        tov         DECIMAL(8,2) NOT NULL DEFAULT 0,
        amount      DECIMAL(8,2) NOT NULL DEFAULT 0,
        nmc         DECIMAL(8,2) NOT NULL DEFAULT 0,
        INDEX(date,time,code)
    );

