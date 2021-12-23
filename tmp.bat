GOTO :eof
FOR %%F IN (%directory%/*) DO FOR /f "delims=_" %%A IN ("%%~nF") DO (
  md "%directory%/%%A" 2>nul
  move "%%F" "%directory%/%%A"
)
Rem *** This will check if the file with the filter exists
Rem SET directory="C:\Microsoft SQL Server Backup"
GOTO :eof


set myday= %date:~7,2%
set /a myday = %myday%-7

if %myday% LSS 10 set myday=0%myday%
echo %myday% 

set mydate=%date:~4,2%%date:~7,2%%date:~10%
set datetodel=%date:~4,2%%myday%%date:~10%

set filter=*%mydate%*
IF EXIST "C:\Microsoft SQL Server Backup\%filter%" CALL :removepastfiles

GOTO :eof


:removepastfiles
Rem *** This will delete all the files in the directory older then 7 days
  ECHO [Remove Rutine Started]
  SET directory="C:\Microsoft SQL Server Backup"
  SET filter=*.bak
  SET days=7
  FORFILES /P %directory% /M *.bak /C "CMD /c DEL @path && ECHO -- @path Deleted" /D -%days%








    if %cnt% > 7 (
    echo --- More then max files removing ---
    set myday= %date:~7,2%
    set /a myday = %myday%-7
    IF %myday% LSS 10 SET myday=0%myday%

    echo %myday% 
    set mydate=%date:~4,2%%date:~7,2%%date:~10%
    set datetodel=%date:~4,2%%myday%%date:~10%

    SET filter=*%mydate%*

    echo filter: "%directory:"=%\%filter%"
    IF EXIST "%directory:"=%\%filter%" CALL :removepastfiles  
  ) else (
    echo --- Less then max files skipping ---
  )