@echo off
rem Type is literally a direct 1 to 1 copy of the cat command, so we will just type the first argument.
if "%~1"=="" (
    echo Usage: cat ^<file^>
    exit /b
)
if not exist "%~1" (
    echo File "%~1" does not exist.
    exit /b
)

rem Bug fix: Replace / with \
set "file=%~1"
set "file=%file:/=\%"

type "%file%"
