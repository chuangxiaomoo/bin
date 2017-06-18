D:
cd tools\VLC 
@echo off

:loop
    for /f "tokens=*" %%i in ('netcat -l -p 1234') do set hear=%%i
    echo %time:~0,-3% %hear%
    IF "wolf"=="%hear%" (
        \tools\qm9chs_xp510.com\QMScript\wolf.up.Q
    ) ELSE (
        IF "am925"=="%hear%" (
            \tools\qm9chs_xp510.com\QMScript\wolf.up.60.Q
        ) ELSE (
            IF "xRD"=="%hear%" (
                \同花顺软件\同花顺云计算\xRD.q
            ) ELSE (
                IF "ntp"=="%hear%" (
                    net start w32time
                    w32tm /resync
                ) ELSE (
                    \tools\VLC\vlc.exe %hear%
                )
            )
        )
    )
    echo listen...
    ::  netcat -l -p 1234 | xargs vlc.exe
goto loop

