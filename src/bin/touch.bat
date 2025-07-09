@echo off

rem touch.bat
rem    * touch reimplementation for the Kali in Batch project.
rem    * Creates an empty file.
rem    * Licensed under the Apache-2.0.

if "%*"=="" (
    echo Usage: touch ^<file^>
    exit /b 64
)

if not exist "%~1" (
    echo. > "%~1"
)
