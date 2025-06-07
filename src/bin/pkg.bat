@echo off

setlocal enabledelayedexpansion

rem pkg.bat
rem    * Package manager for the Kali in Batch project.
rem    * Manages packages.
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

goto start

:start

rem Check if the command line arguments are empty
if "%*"=="" (
    goto noargs
) else (
    goto parse
)

:noargs

echo Usage: pkg ^(install/remove/upgrade/search/list^)
exit

:parse

rem Check the first argument
if "%1"=="install" (
    goto install
) else if "%1"=="remove" (
    goto remove
) else if "%1"=="upgrade" (
    goto upgrade
) else if "%1"=="search" (
    goto search
) else if "%1"=="list" (
    goto list
) else (
    echo Invalid argument.
    exit /b
)

:install

rem Check if the package is already installed
rem C:\Users\%USERNAME%\kali is the Kali in Batch root filesystem path.

if exist "C:\Users\%USERNAME%\kali\usr\bin\%2.sh" (
    echo Package %2 is already installed.
    exit /b
)

rem Save package contents to C:\Users\%USERNAME%\kali\tmp\contents.txt

echo Fetching package contents...
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/%2.sh >"C:\Users\%USERNAME%\kali\tmp\contents.txt"

rem Check if the contents are "404: Not Found"

set /p contents=<C:\Users\%USERNAME%\kali\tmp\contents.txt

if "%contents%"=="404: Not Found" (
    echo Package %2 is not available.
    exit /b
)

if %errorlevel%==1 (
    echo Package %2 is not available.
    exit /b
) else (
    echo Package %2 is available.
)

rem Save package contents to C:\Users\%USERNAME%\kali\usr\bin\%2.sh
echo Installing package %2...
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/%2.sh >"C:\Users\%USERNAME%\kali\usr\bin\%2.sh"
echo Package %2 installed successfully.
del "C:\Users\%USERNAME%\kali\tmp\contents.txt"
exit

:remove

rem Check if the package is installed
if not exist "C:\Users\%USERNAME%\kali\usr\bin\%2.sh" (
    echo Package %2 is not installed.
    exit /b
)

rem Remove the package
del "C:\Users\%USERNAME%\kali\usr\bin\%2.sh"
echo Package %2 removed successfully.
exit

:upgrade

rem Check if the package is installed
if not exist "C:\Users\%USERNAME%\kali\usr\bin\%2.sh" (
    echo Package %2 is not installed. Install it by running: pkg install %2
    exit /b
)

rem Compare the package contents
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/%2.sh >"C:\Users\%USERNAME%\kali\tmp\contents.txt"
set /p contents=<C:\Users\%USERNAME%\kali\tmp\contents.txt
set /p oldcontents=<C:\Users\%USERNAME%\kali\usr\bin\%2.sh

rem Check if the contents are "404: Not Found"

if "!contents!"=="404: Not Found" (
    echo Package %2 is not available anymore. Sorry!
    exit /b
)


if %errorlevel%==1 (
    echo Package %2 is not available anymore. Sorry!
    exit /b
) else (
    echo Package %2 is available.
)

rem Upgrade the package

echo Upgrading package %2...
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/%2.sh >"C:\Users\%USERNAME%\kali\usr\bin\%2.sh"
echo Package %2 upgraded successfully.

del "C:\Users\%USERNAME%\kali\tmp\contents.txt"
exit

:search

rem Open package database in browser

echo Opening package database in browser...
start https://codeberg.org/Kali-in-Batch/pkg/src/branch/main/packages/

exit

:list

rem List all packages
setlocal enabledelayedexpansion
set /i count=0
for /f "delims=" %%a in ('dir /b "C:\Users\%USERNAME%\kali\usr\bin\*.sh"') do (
    set /a count+=1
    rem Remove .sh from noextension
    set noextension=%%a
    set noextension=!noextension:.sh=!
    if !count!==1 (
        rem Hide the error message at the top
        <nul set /p=[1A[2K
    )
    echo Package !count! [1;37m- [3;36m!noextension![0m
)
endlocal
exit
