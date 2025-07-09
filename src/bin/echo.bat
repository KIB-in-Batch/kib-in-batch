@echo off
chcp 65001 >nul

rem echo.bat
rem    * echo command for the Kali in Batch project.
rem    * Echoes the command line arguments.
rem    * Licensed under the Apache-2.0.

goto check

:check

rem Check if the command line arguments are empty
if "%*"=="" (
    goto noargs
) else (
    goto start
)

:noargs

echo.
exit

:start

rem Echo the command line arguments
echo %*
