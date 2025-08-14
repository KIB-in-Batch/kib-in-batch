@echo off

setlocal enabledelayedexpansion

rem lsb_release.bat
rem    * lsb_release reimplementation for the KIB in Batch project.
rem    * This is just here incase a shell script checks for lsb_release.
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

set help=0

rem Loop for each argument
for %%a in (%*) do (
    if "%%a"=="-h" set help=1
    if "%%a"=="--help" set help=1
)

if "!help!"=="1" (
    goto help
) else if "!help!"=="0" (
    echo No LSB modules are available.
)

exit /b 0

:help

echo Usage: lsb_release [options]
echo.
echo Options:
echo   -h, --help         show this help message and exit
echo   -v, --version      show LSB modules this system supports
echo   -i, --id           show distributor ID
echo   -d, --description  show description of this distribution
echo   -r, --release      show release number of this distribution
echo   -c, --codename     show code name of this distribution
echo   -a, --all          show all of the above information
echo   -s, --short        show requested information in short format
