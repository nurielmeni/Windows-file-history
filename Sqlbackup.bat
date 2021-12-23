@echo off
set _msg = ""
set _string=%~1
rem set directory="C:\Microsoft SQL Server Backup"
rem sqlcmd -S .\SQLEXPRESS -E -Q "EXEC sp_BackupDatabases @backupLocation='C:\Microsoft SQL Server Backup\', @backupType='F'"


rem Temp directory (for development only)
set directory="C:\Users\Meni\Dev\rozentech\Windows file history\backups"

echo ---------------- Database backup batch ----------------------
echo --- Backup Directory:  %directory%
echo -------------------------------------------------------------

echo -
echo - Loop through files in: Backup Directory

setlocal enabledelayedexpansion
for %%F in (%directory%\*) do (
  for /f "delims=_" %%A in ("%%~nF") do (
    set currentdir="%directory:"=%\%%A"
    if not exist !currentdir! (
      echo - Creating Directory: !currentdir!
      md !currentdir! 2>nul
    )

    echo --- Moving File: "%%F"
    move "%%F" !currentdir! 1>nul
  )

  set _msg="--- Removing old files (keep at least 7)  ---"
  echo %_msg:"=%
  rem !currentdir! the bkup directory for the project

  rem Count the number of files in the directory
  set filstocount=!currentdir:"=%!\*.BAK
  set cnt=0
  for %%A in (%filstocount%) do set /a cnt+=1
  echo - File count in the directory = %filstocount%
  echo - File count in the directory = %cnt%


)

GOTO :eof

:removepastfiles
Rem *** This will delete all the files in the directory older then 7 days
  echo [Remove Rutine Started]
  set filter=*.bak
  set days=7
  FORFILES /P !currentdir! /M *.bak /C "CMD /c DEL @path && ECHO -- @path Deleted" /D -%days%
GOTO :eof

