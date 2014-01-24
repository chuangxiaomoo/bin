
-- 最大id的记录

SELECT min.*, cap.name FROM min,cap where   
    min.date = (SELECT date FROM stamp_min order by id DESC limit 1) and
    min.time = (SELECT time FROM stamp_min order by id DESC limit 1) and
    min.code = cap.code order by amount DESC limit 20;


-- 最大id的记录
SELECT * FROM stamp_min order by id DESC limit 1;
SELECT * FROM stamp_min where id = (SELECT max(id) FROM stamp_min);



