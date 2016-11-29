
delimiter //
DROP PROCEDURE IF EXISTS sp_diz //
CREATE PROCEDURE sp_diz() tag_proc:BEGIN
    SET @id = 480*12; # +80000;
    SELECT max(id) FROM futures_dif INTO @len; 
    SET @len = 10000;
    SET @ymd_now = 0;

    tag_loop: WHILE @id <= @len DO
        SELECT count(*) FROM futures_posi INTO @len_posi;
        IF @len_posi>1 THEN
            SELECT 'error len_posi:', @len_posi; LEAVE tag_proc;
        END IF;

        SELECT 2016*10000+ROUND(time/1000000),
               time%1000000,dif,mid,m480,top,bot,std FROM futures_dif WHERE id=@id 
        INTO    @ymd,@hms,@_dif,@mid,@m480,@top,@bot,@std;

        IF @ymd!=@ymd_now THEN     # open
            SELECT settle FROM futures_d1 WHERE code='rb1701' and date=@ymd INTO @settle;
            IF @settle is NULL THEN SELECT 'NULL ymd';LEAVE tag_proc; END IF;
        END IF;

        IF @len_posi=0 THEN     # open
            # 白场&夜场，开场前5分钟&闭场前5分钟，不开单
            IF ( @hms>=090000 && @hms<=090500) || ( @hms>=145500 && @hms<=150000) ||
               ( @hms>=210000 && @hms<=210500) || ( @hms>=225500 && @hms<=230000) THEN
                SET @id = @id + 1; ITERATE tag_loop;
            END IF;

            # 安全边界
            IF (              @std<=1.50) THEN SET @id=@id+1; ITERATE tag_loop;  END IF;
            IF ( @std>1.50 && @std<=1.75) THEN SET @off=1.5;                     END IF;
            IF ( @std>1.75 && @std<=2.50) THEN SET @off=1;                       END IF;
            IF ( @std>2.5  && @std<=2.75) THEN SET @off=.5;                      END IF;
            IF ( @std>2.75 && @std<=3)    THEN SET @off=0;                       END IF;    # 一次只赚12个点上限
            IF ( @std>3    && @std<=3.5 ) THEN SET @off=-1;                      END IF;
            IF ( @std>3.5               ) THEN SET @off=-1.5;                    END IF;

            # 开单
            SELECT count(*) FROM futures_open INTO @len_open;
            IF ( @mid>=@m480  ) THEN        # 做多
                IF @_dif<=ROUND(@bot-@off-.2) THEN
                   INSERT INTO futures_posi(type,SNR,tid,time,posi,high,low,dif,std)
                       SELECT 1,@len_open+1,@id,time,1,GREATEST(close,close2),LEAST(close,close2),dif,std FROM futures_dif WHERE id=@id;

                   INSERT INTO futures_open(type,SNR,tid,time,posi,high,low,dif,std)
                       SELECT 1,@len_open+1,@id,time,1,GREATEST(close,close2),LEAST(close,close2),dif,std FROM futures_dif WHERE id=@id;
                END IF;
            ELSE                            # 做空
                IF @_dif>=ROUND(@top+@off) THEN
                   INSERT INTO futures_posi(type,SNR,tid,time,posi,high,low,dif,std)
                       SELECT -1,@len_open+1,@id,time,1,GREATEST(close,close2),LEAST(close,close2),dif,std FROM futures_dif WHERE id=@id;

                   INSERT INTO futures_open(type,SNR,tid,time,posi,high,low,dif,std)
                       SELECT -1,@len_open+1,@id,time,1,GREATEST(close,close2),LEAST(close,close2),dif,std FROM futures_dif WHERE id=@id;
                END IF;
            END IF;
        ELSE                    # shut
            # 前2.5分钟不平仓
            IF ( @hms>=090000 && @hms<=090230) ||
               ( @hms>=210000 && @hms<=210230) THEN
                SET @id = @id + 1; ITERATE tag_loop;
            END IF;

            # 自适应卖价
            SELECT type,tid,SNR,dif FROM futures_open ORDER by SNR DESC LIMIT 1 INTO @type,@tid,@SNR,@open;
            IF (@id-@tid)/12<=45 THEN
                SET @off=1;
                SET @revert=0;
            ELSE
                SET @off=floor( ((@id-@tid)/12-45) /15);
                SET @revert=1;      # 超时开头
            END IF;


            IF ( @type=1 ) THEN     # 平多
                IF @mid<@m480 THEN SET @revert=@revert*@std*2; ELSE SET @revert=0; END IF;
                IF @_dif>=ROUND(@top+@off-@revert) || @_dif-@open>=16 THEN
                   INSERT INTO futures_shut(type,SNR,tid,time,posi,high,low,dif,std)
                       SELECT 1,@SNR,@id,time,1,GREATEST(close,close2),LEAST(close,close2),dif,std FROM futures_dif WHERE id=@id;
                       DELETE FROM futures_posi;
                END IF;
            ELSE                    # 平空
                IF @mid>@m480 THEN SET @revert=@revert*@std*2; ELSE SET @revert=0; END If;
                IF @_dif<=ROUND(@bot-@off+@revert-.2) || @open-@_dif>=16 THEN
                   INSERT INTO futures_shut(type,SNR,tid,time,posi,high,low,dif,std)
                       SELECT -1,@SNR,@id,time,1,GREATEST(close,close2),LEAST(close,close2),dif,std FROM futures_dif WHERE id=@id;
                       DELETE FROM futures_posi;
                END IF;
            END IF;
        END IF;

        SET @id = @id + 1;
    END WHILE tag_loop;
END tag_proc //

call sp_diz();
    
