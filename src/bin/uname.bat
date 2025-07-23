@echo off

setlocal enabledelayedexpansion

rem uname.bat
rem    * Uname reimplementation for the Kali in Batch project.
rem    * Displays basic system information.
rem    * Licensed under the GPL-2.0-only.
rem Copyright (C) 2025 benja2998
rem
rem This program is free software; you can redistribute it and/or modify
rem it under the terms of the GNU General Public License as published by
rem the Free Software Foundation; ONLY version 2 of the License.
rem
rem This program is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem GNU General Public License for more details.
rem
rem You should have received a copy of the GNU General Public License
rem along with this program; if not, write to the Free Software
rem Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

for /f "tokens=4 delims=.[]" %%A in ('ver') do set vernum=%%A

goto check

:check

if "%1"=="" (
    call :kernel
    echo.
    goto :eof
) else (
    goto check_again
)

:kernel

<nul set /p "=KALI-IN-BATCH_!OS! "
goto :eof

:all

call :kernel
call :nodename
call :release
call :kernelversion
call :machine
call :os
goto :eof

:kernelversion

<nul set /p "=!vernum! "
goto :eof

:nodename

<nul set /p "=%COMPUTERNAME% "
goto :eof

:release

<nul set /p "=9.0 "
goto :eof

:machine

<nul set /p "=%PROCESSOR_ARCHITECTURE% "
goto :eof

:hardwareplatform

<nul set /p "=unknown "
goto :eof

:processor

<nul set /p "=unknown "
goto :eof

:os

<nul set /p "=Kali in Batch "
goto :eof

:version

echo Uname for Kali in Batch 9.0
echo This is GPL-2.0-only licensed free software. There is NO WARRANTY.
goto :eof

:help

echo Usage: uname ^[OPTION^]...
echo Print certain system information. With no OPTION, same as -s.
echo.
echo -a --all                   print all information, in the following order,
echo                            except omit -p and -i if unknown:
echo -s --kernel-name           print the kernel name
echo -n --nodename              print the network node hostname
echo -r --kernel-release        print the kernel release
echo -v --kernel-version        print the kernel version
echo -m --machine               print the machine hardware name
echo -p --processor             print the processor type
echo -i --hardware-platform     print the hardware platform
echo -o --operating-system      print the operating system
echo.
echo The following options are not printed in --all:
echo.
echo --help                     display this help and exit
echo --version                  output version

:check_again
set "flag_s=0"
set "flag_n=0"
set "flag_r=0"
set "flag_v=0"
set "flag_m=0"
set "flag_p=0"
set "flag_i=0"
set "flag_o=0"
set "flag_a=0"
set "flag_version=0"
set "flag_help=0"

rem Parse arguments
:parse_args
if "%~1"=="" goto print_flags

set arg=%~1

rem Check for long options
if "%arg:~0,2%"=="--" (
    if "%arg%"=="--all" set flag_a=1
    if "%arg%"=="--kernel-name" set flag_s=1
    if "%arg%"=="--nodename" set flag_n=1
    if "%arg%"=="--kernel-release" set flag_r=1
    if "%arg%"=="--kernel-version" set flag_v=1
    if "%arg%"=="--machine" set flag_m=1
    if "%arg%"=="--processor" set flag_p=1
    if "%arg%"=="--hardware-platform" set flag_i=1
    if "%arg%"=="--operating-system" set flag_o=1
    if "%arg%"=="--version" set flag_version=1
    if "%arg%"=="--help" set flag_help=1
) else (
    rem Check for short options combined
    if "%arg:~0,1%"=="-" (
        setlocal enabledelayedexpansion
        set "opts=!arg:~1!"
        for /l %%i in (0,1,4096) do (
            if "!opts:~%%i,1!"=="" goto end_opts_loop
            set "opt=!opts:~%%i,1!"
            if "!opt!"=="a" set flag_a=1
            if "!opt!"=="s" set flag_s=1
            if "!opt!"=="n" set flag_n=1
            if "!opt!"=="r" set flag_r=1
            if "!opt!"=="v" set flag_v=1
            if "!opt!"=="m" set flag_m=1
            if "!opt!"=="p" set flag_p=1
            if "!opt!"=="i" set flag_i=1
            if "!opt!"=="o" set flag_o=1
            if "!opt!"=="-" (
                rem ignore double dash here
            )
        )
        :end_opts_loop
        endlocal & set "flag_a=%flag_a%" & set "flag_s=%flag_s%" & set "flag_n=%flag_n%" & set "flag_r=%flag_r%" & set "flag_v=%flag_v%" & set "flag_m=%flag_m%" & set "flag_p=%flag_p%" & set "flag_i=%flag_i%" & set "flag_o=%flag_o%" & set "flag_version=%flag_version%" & set "flag_help=%flag_help%"
    )
)

shift
goto parse_args

:print_flags

if %flag_help%==1 (
    call :help
    goto :eof
)

if %flag_version%==1 (
    call :version
    goto :eof
)

if %flag_a%==1 (
    call :all
    echo.
    goto :eof
)

rem Print requested info on one line
setlocal enabledelayedexpansion
if !flag_s! equ 1 call :kernel
if !flag_n! equ 1 call :nodename
if !flag_r! equ 1 call :release
if !flag_v! equ 1 call :kernelversion
if !flag_m! equ 1 call :machine
if !flag_p! equ 1 call :processor
if !flag_i! equ 1 call :hardwareplatform
if !flag_o! equ 1 call :os
echo.
endlocal

exit /b 0
