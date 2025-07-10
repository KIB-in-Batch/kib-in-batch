@echo off

setlocal enabledelayedexpansion

rem uname.bat
rem    * Uname reimplementation for the Kali in Batch project.
rem    * Displays basic system information.
rem    * Licensed under the Apache-2.0.

goto check

:check

if "%1"=="" (
    call :kernel
    goto :eof
) else (
    goto check_again
)

:kernel

echo KALI-IN-BATCH_!OS!
goto :eof

:all

call :kernel
call :nodename
call :release
call :machine
call :processor
call :os
goto :eof

:nodename

hostname
goto :eof

:release

echo 6.2
goto :eof

:machine

echo %PROCESSOR_ARCHITECTURE%
goto :eof

:processor

echo unknown
goto :eof

:os

echo Kali in Batch
goto :eof

:version

echo Uname for Kali in Batch 6.2
echo This is Apache-2.0 licensed free software. There is NO WARRANTY.
goto :eof

:help

echo Usage: uname ^[OPTION^]...
echo Print certain system information. With no option, it is same as -s.
echo.
echo -a --all                   print all information, in the following order
echo -s --kernel-name           print the kernel name
echo -n --nodename              print the network node hostname
echo -r --kernel-release        print the kernel release
echo -m --machine               print the machine hardware name
echo -p --processor             print the processor type
echo -o --operating-system      print the operating system
echo.
echo The following options are not printed in --all:
echo.
echo --help                     display this help and exit
echo --version                  output version

:check_again
for %%A in (%*) do (
    if "%%A"=="-a" (
        call :all
    )
    if "%%A"=="--all" (
        call :all
    )
    if "%%A"=="-s" (
        call :kernel
    )
    if "%%A"=="--kernel-name" (
        call :kernel
    )
    if "%%A"=="-n" (
        call :nodename
    )
    if "%%A"=="--nodename" (
        call :nodename
    )
    if "%%A"=="-r" (
        call :release
    )
    if "%%A"=="--kernel-release" (
        call :release
    )
    if "%%A"=="-m" (
        call :machine
    )
    if "%%A"=="--machine" (
        call :machine
    )
    if "%%A"=="-p" (
        call :processor
    )
    if "%%A"=="--processor" (
        call :processor
    )
    if "%%A"=="-o" (
        call :os
    )
    if "%%A"=="--operating-system" (
        call :os
    )
    if "%%A"=="--version" (
        call :version
    )
    if "%%A"=="--help" (
        call :help
    )
)
exit /b 0
