@echo off

setlocal enabledelayedexpansion

rem pkg.bat
rem    * Package manager for the Kali in Batch project.
rem    * Manages packages.
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

goto start

:start

rem Check if ROOT is set to 0
if "%ROOT%" == "0" (
    echo Please log in as the root user to run pkg, or you can:
    echo 1. Run pkg with sudo ^(e.g. sudo pkg %*^)
    echo 2. Use the su command to become root, then run unsu after you don't need root anymore.
    exit /b 1
)

rem Check if the command line arguments are empty
if "%*"=="" (
    goto noargs
) else (
    goto parse
)

:noargs

echo Usage: pkg ^(install/remove/upgrade/search/list/help^)
exit

:help

echo Usage: pkg ^(install/remove/upgrade/search/list/help^)
echo.
echo Commands:
echo   install  - Install a package by name.
echo   remove   - Remove an installed package by name.
echo   upgrade  - Upgrade an installed package to the latest version.
echo   search   - Open the package database in a browser.
echo   list     - List all installed packages.
echo   help     - Display this help message.
exit

:parse

rem Check the first argument
if "%1"=="install" (
    if "%2"=="" (
        echo Package name is required.
        exit /b 1
    )
    goto install
) else if "%1"=="remove" (
    if "%2"=="" (
        echo Package name is required.
        exit /b 1
    )
    goto remove
) else if "%1"=="upgrade" (
    if "%2"=="" (
        echo Package name is required.
        exit /b 1
    )
    goto upgrade
) else if "%1"=="help" (
    goto help
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
rem %USERPROFILE%\kali is the Kali in Batch root filesystem path.

if exist "%USERPROFILE%\kali\usr\bin\%2" (
    echo Package %2 is already installed.
    exit /b
)

rem Save package contents to %USERPROFILE%\kali\tmp\contents.txt

echo Fetching package contents...
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/bin/%2 >"%USERPROFILE%\kali\tmp\contents.txt"

rem Check if the contents are "404: Not Found"

set /p contents=<%USERPROFILE%\kali\tmp\contents.txt

if "!contents!"=="404: Not Found" (
    echo Package %2 is not available.
    exit /b
)

if %errorlevel%==1 (
    echo Package %2 is not available.
    exit /b
) else (
    echo Package %2 is available.
)

rem Save package contents to %USERPROFILE%\kali\usr\bin\%2
echo Installing package %2...
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/bin/%2 >"%USERPROFILE%\kali\usr\bin\%2"
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/lib/%2.lib >"%USERPROFILE%\kali\usr\lib\%2.lib"
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/libexec/%2.libexec >"%USERPROFILE%\kali\usr\libexec\%2.libexec
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/share/%2.share >"%USERPROFILE%\kali\usr\share\%2.share"
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/local/%2.local >"%USERPROFILE%\kali\usr\local\%2.local"
echo. >"%USERPROFILE%\kali\usr\bin\%2.sh"
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/PREINSTALL >"%USERPROFILE%\kali\tmp\%2_preinstall"
set /p preinstaller_contents=<%USERPROFILE%\kali\tmp\%2_preinstall
if "!contents!"=="404: Not Found" (
    echo Package %2 has no preinstall script
) else (
    echo Running preinstall script for package %2...
    "%USERPROFILE%\kali\usr\bin\busybox.exe" bash -c "C:/Users/%USERNAME%/kali/tmp/%2_preinstall"
)
echo Package %2 installed successfully.
del "%USERPROFILE%\kali\tmp\contents.txt"
exit

:remove

rem Check if the package is installed
if not exist "%USERPROFILE%\kali\usr\bin\%2" (
    echo Package %2 is not installed. Install it by running: pkg install %2
    exit /b
)

rem Remove the package
del "%USERPROFILE%\kali\usr\bin\%2"
del "%USERPROFILE%\kali\usr\bin\%2.sh"
del "%USERPROFILE%\kali\usr\lib\%2.lib"
del "%USERPROFILE%\kali\usr\libexec\%2.libexec"
del "%USERPROFILE%\kali\usr\share\%2.share"
del "%USERPROFILE%\kali\usr\local\%2.local"
echo Package %2 removed successfully.
exit

:upgrade

rem Check if the package is installed
if not exist "%USERPROFILE%\kali\usr\bin\%2" (
    echo Package %2 is not installed. Install it by running: pkg install %2
    exit /b
)

rem Save package contents to %USERPROFILE%\kali\tmp\contents.txt

echo Fetching package contents for upgrade...
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/bin/%2 >"%USERPROFILE%\kali\tmp\contents.txt"

rem Check if the contents are "404: Not Found"

set /p contents=<%USERPROFILE%\kali\tmp\contents.txt

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
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/bin/%2 >"%USERPROFILE%\kali\usr\bin\%2"
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/lib/%2.lib >"%USERPROFILE%\kali\usr\lib\%2.lib"
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/libexec/%2.libexec >"%USERPROFILE%\kali\usr\libexec\%2.libexec"
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/share/%2.share >"%USERPROFILE%\kali\usr\share\%2.share"
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/rootfs/usr/local/%2.local >"%USERPROFILE%\kali\usr\local\%2.local"
echo. >"%USERPROFILE%\kali\usr\bin\%2.sh"
curl -# https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/PREINSTALL >"%USERPROFILE%\kali\tmp\%2_preinstall"
set /p preinstaller_contents=<%USERPROFILE%\kali\tmp\%2_preinstall
if "!contents!"=="404: Not Found" (
    echo Package %2 has no preinstall script
) else (
    echo Running preinstall script for package %2...
    "%USERPROFILE%\kali\usr\bin\busybox.exe" bash -c "C:/Users/%USERNAME%/kali/tmp/%2_preinstall"
)
echo Package %2 upgraded successfully.

del "%USERPROFILE%\kali\tmp\contents.txt"
del "%USERPROFILE%\kali\tmp\%2_preinstall"
exit

:search

rem Open package database in browser

echo Opening package database in browser...
start https://github.com/Kali-in-Batch/pkg/tree/main/packages

exit

:list

rem List all packages
setlocal enabledelayedexpansion
set /i count=0
for /f "delims=" %%a in ('dir /b "%USERPROFILE%\kali\usr\bin\*.sh"') do (
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
