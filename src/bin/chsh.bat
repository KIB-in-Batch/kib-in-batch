@echo off

setlocal enabledelayedexpansion

rem chsh.bat
rem    * Chsh reimplementation for the KIB in Batch project.
rem    * Changes the default shell.
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

set /p kaliroot=<"%APPDATA%\kali_in_batch\kaliroot.txt"

if "%~1"=="" goto usage

goto :test

:usage

echo Usage: chsh [shell]
echo.
echo Change the default shell.

goto :eof

:test

echo WARNING: Changing the default shell is unrecommended and may cause issues.

choice /c YN /n /m "Proceed? (Y/N): "

if "%errorlevel%"=="2" goto :eof

echo.
echo ------------------------
echo STARTING CRTIICAL CHECKS
echo ------------------------
echo.

rem Check if last three characters of %~1 are .bat
if "%~x1"==".bat" (
    set "callornot=call "
) else if "%~x1"==".cmd" (
    set "callornot=call "
)

set "shell_exist=0"
set "shell_has_c=0"
set "shell_can_run_extern=0"
set "shell_can_run_extern_with_args=0"

<nul set /p "=Checking if shell exists... "

if exist "%~1" (
    echo yes
    set "shell_exist=1"
    set "shell_name=%~1"
) else if exist "%~1".exe (
    echo yes
    set "shell_exist=1"
    set "shell_name=%~1.exe"
) else if exist "%~1".com (
    echo yes
    set "shell_exist=1"
    set "shell_name=%~1.com"
) else if exist "%~1".bat (
    echo yes
    set "shell_exist=1"
    set "callornot=call "
    set "shell_name=%~1.bat"
) else if exist "%~1".cmd (
    echo yes
    set "shell_exist=1"
    set "callornot=call "
    set "shell_name=%~1.cmd"
) else (
    echo no
    exit /b 1
)

<nul set /p "=Checking if shell has -c option... "

%callornot%"%~1" -c "" >nul 2>&1

if !errorlevel!==0 (
    echo yes
    set "shell_has_c=1"
) else (
    echo no
)

<nul set /p "=Checking if shell can run external commands... "

%callornot%"%~1" -c "busybox" >nul 2>&1

if !errorlevel!==0 (
    echo yes
    set "shell_can_run_extern=1"
) else (
    echo no
)

echo.
echo --------------------
echo CRITICAL CHECKS DONE
echo --------------------

set "has_rcfile=0"
set "supports_env=0"
set "supports_bash_env=0"

rem Check if all critical variables equal 1

if "!shell_exist!"=="1" if "!shell_has_c!"=="1" if "!shell_can_run_extern!"=="1" (
    goto success
)

exit /b 1

:success

rem Write the shell start command to a file

set "shell.bat=!kaliroot!\etc\shell.bat"

echo.
echo ----------------------------
echo STARTING NON-CRITICAL CHECKS
echo ----------------------------
echo.

rem Check if the shell supports the --rcfile option
<nul set /p "=Checking if shell supports --rcfile option... "

%callornot%"%~1" --rcfile "!kaliroot!/etc/.kibenv" -c "echo Hello" >nul 2>&1

if !errorlevel! equ 0 (
    echo yes
    set "has_rcfile=1"
) else (
    echo no
)

echo.
echo ------------------------
echo NON-CRITICAL CHECKS DONE
echo ------------------------

rem Normalize backslashes to slashes in shell name

set "shell_name=!shell_name:\=/!"

rem Check if first character of shell name is a slash

if "!shell_name:~0,1!"=="/" (
    rem Set shell name
    set "shell_name=!kaliroot!!shell_name!"
)

rem Check if second character of shell name is not a :

if not "!shell_name:~1,1!"==":" (
    echo !shell_name! is not an absolute path
    exit /b 1
)

del /s /q "!kaliroot!\tmp\*" >nul 2>nul & rem Nothing there is important since it is the tmp dir

echo.
echo ---------------------------------------
echo STARTING GENERATION OF '/etc/shell.bat'
echo ---------------------------------------
echo.

echo @echo off > "%shell.bat%"
echo setlocal enabledelayedexpansion >> "%shell.bat%"
echo set "ENV=!kaliroot!/etc/.kibenv" >> "%shell.bat%"
echo set "BASH_ENV=!kaliroot!/etc/.kibenv" >> "%shell.bat%"
if "!has_rcfile!"=="0" (
    echo has_rcfile = false
    echo %callornot%!shell_name! >> "%shell.bat%"
) else if "!has_rcfile!"=="1" (
    echo has_rcfile = true
    echo %callornot%!shell_name! --rcfile "!kaliroot!/etc/.kibenv" >> "%shell.bat%"
) else (
    echo has_rcfile = false
    echo %callornot%!shell_name! >> "%shell.bat%"
)

echo.
echo --------------------------
echo GENERATED '/etc/shell.bat'
echo --------------------------
echo.

type "%shell.bat%"

rem Comment this deletion out once shell.bat is handled
::del /s /q "%shell.bat%" >nul 2>nul

exit /b 0
