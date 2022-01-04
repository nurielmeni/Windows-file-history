@echo off
setlocal enableDelayedExpansion 

rem set directory="E:\Backup"
rem sqlcmd -S .\SQLEXPRESS -E -Q "EXEC sp_BackupDatabases @backupLocation='C:\Microsoft SQL Server Backup\', @backupType='F'"


rem Temp directory (for development only)
set directory="C:\Users\Meni Nuriel\Dev\rozentech\Windows-file-history\backups"

echo ---------------- Database backup batch ----------------------
echo --- Backup Directory:  %directory%
echo -------------------------------------------------------------

echo -
echo - Loop through files in: Backup Directory


for %%F in (%directory%\*) do (

  for /f "tokens=1 delims=_" %%A in ("%%~nF") do (
    set currentdir="%directory:"=%\%%A"
    set filterdir="%directory:"=%\%%A\*.BAK"
    call :loopproject "%%A", %directory%, !currentdir!
  )

  echo -
  echo --- Removing old files - when more then 7 ---
  echo - 

  set /A count=0 & for %%x in (!filterdir!) do @(set /A count+=1 >nul) 
  echo Num Files: !count!
  set /A filestodelete = !count! - 7

  echo DELETING: !filestodelete! Files
  echo FROM: !currentdir!
  echo ----------------------------------
  call :removeoldestfile !currentdir!, !filestodelete!
  echo ----------------------------------

  rem FOR /L %%d IN (1,1,!filestodelete!) DO call :removeoldestfile !currentdir!
)
GOTO :eof

rem Functions

:countfiles 
    set /A numfiles = 0
    for %%i in ("%~1") do set /A numfiles = numfiles + 1
EXIT /B 0

:loopproject
  setlocal
    if not exist "%~3" (
      echo - Creating Directory: "%~3"
      md "%~3" 2>nul
    )
    echo Current Dir: !currentdir!

    for %%i in ("%~2\%~1*.BAK") do (
      echo --- Moving File: "%%i"
      move "%%i" "%~3" 1>nul
    )
  endlocal
EXIT /B 0

:removeoldestfile
  set /A _count = %~2
  for /f "delims=" %%f in ('dir /B /OD "%~1\*.BAK"') do (
    if !_count! LEQ 0 EXIT /B 0
    del "%~1\%%f"
    echo -deleted- "%~1\%%f"
    set /A _count-=1
  ) 
EXIT /B 0

