-- source /root/bin/stk/sql/test.sql

delimiter //
DROP PROCEDURE IF EXISTS sp_test//
CREATE PROCEDURE sp_test(arg_tbl CHAR(20), arg_code INT) BEGIN
    -- DECLARE arg_change INT DEFAULT 3;
    -- SELECT * from day where code=arg_code limit 3;

--    SET @argv_n = 3;
    SET @argv_n = @argv_n - 1;
    SET @sqls=concat(
    'SELECT date FROM day WHERE code = 900001 ORDER by date DESC limit ',
    @argv_n,
    ',1 INTO @v_mindate;'
    );

    SELECT @sqls;
    PREPARE stmt from @sqls; EXECUTE stmt;
    
    -- SELECT date FROM day WHERE code = 900001 ORDER by date DESC limit 2,1;

END //

call sp_test('day', 2);
