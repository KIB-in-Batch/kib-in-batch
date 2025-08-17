@echo off

setlocal enabledelayedexpansion

rem updater.bat
rem    * Updater for the KIB in Batch project.
rem    * Updates KIB in Batch to the latest version.
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

set /p dp0=<"%APPDATA%\kib_in_batch\dp0.txt"

rem Test network

ping -n 1 github.com > nul

if errorlevel 1 (
    echo Error: No internet connection.
    pause
    exit /b 1
)

curl -# -f -L https://github.com/KIB-in-Batch/kib-in-batch/releases/latest/download/kib_in_batch.zip -o kib_in_batch.zip

if %errorlevel% neq 0 (
    echo Error: Failed to download the latest version of KIB in Batch.
    pause
    exit /b 1
)

rem Unzip it

powershell -Command "Expand-Archive -Path 'kib_in_batch.zip' -DestinationPath '.' -Force" > nul

if %errorlevel% neq 0 (
    echo Error: Failed to unzip the latest version of KIB in Batch.
    pause
    exit /b 1
)

set /p version=<"src\VERSION.txt"

rem Check the second word

for /f "tokens=2" %%a in ('echo !version!') do (
    if /i "%%a"=="LTS" (
        echo Error: The version is an LTS version and you are not on an LTS version.
        pause
        exit /b 1
    )
)

rem Back up dp0

robocopy "!dp0!" "!dp0!.bak"

rem Copy files

echo Copying files...

robocopy "src\" "!dp0!"

echo Cleaning up...

rd /s /q "src\"

echo KIB in Batch has been successfully upgraded.

set /p choice="Do you want to restore the backup? [Y/N]: "

if /i "!choice!"=="y" (
    robocopy "!dp0!.bak\" "!dp0!"
)
