sqlcmd -S .\SQLEXPRESS -E -Q "EXEC sp_BackupDatabases @backupLocation='C:\Microsoft SQL Server Backup\', @backupType='F'"

rem @echo off
Rem *** This will echo all the files in the directory
  SET directory="C:\Microsoft SQL Server Backup"
  FORFILES /P %directory% /M *.bak /C "cmd /c echo @path" 

Rem *** This will check if the file with the filter exists
SET directory="C:\Microsoft SQL Server Backup"

set myday= %date:~7,2%
set /a myday = %myday%-7
IF %myday% LSS 10 SET myday=0%myday%


 echo %myday% 
set mydate=%date:~4,2%%date:~7,2%%date:~10%
set datetodel=%date:~4,2%%myday%%date:~10%

SET filter=*%mydate%*
IF EXIST "C:\Microsoft SQL Server Backup\%filter%" CALL :removepastfiles

GOTO :eof


:removepastfiles
Rem *** This will delete all the files in the directory older then 7 days
  ECHO [Remove Rutine Started]
  SET directory="C:\Microsoft SQL Server Backup"
  SET filter=*.bak
  SET days=7
  FORFILES /P %directory% /M *.bak /C "CMD /c DEL @path && ECHO -- @path Deleted" /D -%days%