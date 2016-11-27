
delimiter //
DROP PROCEDURE IF EXISTS sp_diz //
CREATE PROCEDURE sp_diz() tag_proc:BEGIN
    SET @id = 30*12;
    SELECT max(id) FROM futures_dif INTO @len; 
#   SET @len = 1000;

    tag_loop: WHILE @id <= @len DO
        SELECT count(*) FROM futures_posi INTO @len_posi;
        IF @len_posi>1 THEN
            SELECT 'error len_posi:', @len_posi; LEAVE tag_proc;
        END IF;

        SELECT time%1000000,dif,mid,top,bot,std FROM futures_dif WHERE id=@id 
        INTO    @hms,@_dif,@mid,@top,@bot,@std;

        IF @len_posi=0 THEN     # open
            # 白场&夜场，开场前5分钟&闭场前5分钟，不开单
            IF ( @hms>=090000 && @hms<=090500) || ( @hms>=145500 && @hms<=150000) ||
               ( @hms>=210000 && @hms<=210500) || ( @hms>=225500 && @hms<=230000) THEN
                SET @id = @id + 1; ITERATE tag_loop;
            END IF;

            # 中值休息 
            IF (              @mid<=8   ) THEN SET @id=@id+1; ITERATE tag_loop;  END IF;
            # 安全边界
            IF (              @std<=1.50) THEN SET @id=@id+1; ITERATE tag_loop;  END IF;
            IF ( @std>1.50 && @std<=1.75) THEN SET @off=2;                       END IF;
            IF ( @std>1.75 && @std<=2.50) THEN SET @off=1;                       END IF;
            IF ( @std>2.5               ) THEN SET @off=floor(1+2*(@std-2));     END IF;

            IF ( @top<0                 ) THEN SET @off=-@off;                   END IF;

            # 开单
            IF ( abs(@_dif)>=round(abs(@top+@off)) ) THEN
               SELECT count(*) FROM futures_open INTO @len_open;
               INSERT INTO futures_posi(type,SNR,tid,time,posi,high,low,dif,std)
                   SELECT 'O',@len_open+1,@id,time,1,GREATEST(close,close2),LEAST(close,close2),abs(dif),std FROM futures_dif WHERE id=@id;

               INSERT INTO futures_open(type,SNR,tid,time,posi,high,low,dif,std)
                   SELECT 'O',@len_open+1,@id,time,1,GREATEST(close,close2),LEAST(close,close2),abs(dif),std FROM futures_dif WHERE id=@id;
            END IF;
        ELSE                    # shut
            # 前2.5分钟不平仓
            IF ( @hms>=090000 && @hms<=090230) ||
               ( @hms>=210000 && @hms<=210230) THEN
                SET @id = @id + 1; ITERATE tag_loop;
            END IF;
            # 自适应卖价
            SELECT tid,SNR,dif FROM futures_open ORDER by SNR DESC LIMIT 1 INTO @tid,@SNR,@open;
            IF (@id-@tid)/12<=45 THEN
                SET @off=1;
            ELSE
                SET @off=-floor( ((@id-@tid)/12-45) /15);
            END IF;

            IF ( @bot<0                ) THEN SET @off=-@off;               END IF;

            # 平单
            IF abs(@_dif)<=(@bot-@off) || abs(@_dif)<=abs(@open)-16 THEN
               INSERT INTO futures_shut(type,SNR,tid,time,posi,high,low,dif,std)
                   SELECT 'S',@SNR,@id,time,1,GREATEST(close,close2),LEAST(close,close2),abs(dif),std FROM futures_dif WHERE id=@id;
               DELETE FROM futures_posi;
            END IF;
        END IF;

        SET @id = @id + 1;
    END WHILE tag_loop;
END tag_proc //

call sp_diz();
    
