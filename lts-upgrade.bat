@echo off

rem lts-upgrade.bat
rem    * LTS upgrader for the KIB in Batch project.
rem    * Upgrades an LTS version to the latest release of it.
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

curl --version >nul 2>&1
if errorlevel 1 (
    echo Curl not found
    pause >nul
    exit /b 1
)

echo Choose a version to upgrade.
echo.
echo 1 - 9.9.2 LTS
echo.
choice /c 1 /n /m ""

if errorlevel 1 goto one

:one

set "URL=https://github.com/KIB-in-Batch/kib-in-batch/releases/download/9.9.2-lts-13/kali_in_batch.zip"

del /q /f "%TEMP%\kib.zip" & rem We don't need old files
curl -L -# %URL% -o "%TEMP%\kib.zip"

powershell.exe -nologo -noprofile -command "Expand-Archive -Path \"%TEMP%\kib.zip\" -DestinationPath \"%USERPROFILE%\Desktop\kib_installer\" -Force"

if errorlevel 0 (
    echo Extraction successful!
) else (
    echo Error during extraction!
)

echo The files have been placed in "%USERPROFILE%\Desktop\kib_installer". Please find kali_in_batch.bat there in the src directory.
