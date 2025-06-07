@echo off

setlocal enabledelayedexpansion

rem uname.bat
rem    * Uname reimplementation for the Kali in Batch project.
rem    * Displays basic system information.
rem    * License:
rem
rem ======================================================================================
rem MIT License
rem
rem Copyright (c) 2025 benja2998
rem
rem Permission is hereby granted, free of charge, to any person obtaining a copy
rem of this software and associated documentation files (the "Software"), to deal
rem in the Software without restriction, including without limitation the rights
rem to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
rem copies of the Software, and to permit persons to whom the Software is
rem furnished to do so, subject to the following conditions:
rem
rem The above copyright notice and this permission notice shall be included in all
rem copies or substantial portions of the Software.
rem
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
rem SOFTWARE.
rem =======================================================================================

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

echo 4.0.6
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

echo Uname for Kali in Batch 4.0.6
echo This is MIT licensed free software. There is NO WARRANTY.
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
echo.
goto version

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
