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
