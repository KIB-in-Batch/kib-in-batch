@echo off

setlocal enabledelayedexpansion

rem msfconsole.bat
rem    * Metasploit wrapper for the KIB in Batch project.
rem    * Launches Kali Linux WSL to launch msfconsole.
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

echo Starting, this may take a few minutes...

wsl -d kali-linux bash -c "exit 0" >nul 2>>"%APPDATA%\kali_in_batch\errors.log"

if errorlevel 1 (
    echo Kali Linux WSL is not installed. Installing it...
    pause >nul
    wsl --install -d kali-linux
)

wsl --set-default-version 2 >nul 2>>"%APPDATA%\kali_in_batch\errors.log"

wsl --set-version kali-linux 2 >nul 2>>"%APPDATA%\kali_in_batch\errors.log"

rem Get the current directory
set "currentDir=!cd!"

rem Extract the drive letter from the current directory
set "driveLetter=!currentDir:~0,2!"

rem Extract the path without the drive letter
set "pathWithoutDrive=!currentDir:~3!"

rem Set the new path with the desired drive letter and path
set "newPath=%USERPROFILE%\kali\!pathWithoutDrive!"

echo !newPath!

rem Change to newPath if output of subst contains !driveLetter!

subst | findstr /i "!driveLetter!" >nul 2>>"%APPDATA%\kali_in_batch\errors.log"

rem Check if errorlevel is 0

if "!errorlevel!"=="0" (
    echo Output of subst contains !driveLetter!
    cd /d "!newPath!" >nul 2>>"%APPDATA%\kali_in_batch\errors.log"
)

wsl -d kali-linux msfconsole %*

if errorlevel 1 (
    echo Metasploit is not installed. Installing it...
    wsl -d kali-linux sudo apt-get update
    wsl -d kali-linux sudo apt-get install -y metasploit-framework
    wsl -d kali-linux msfconsole %*
)

rem Change back to the original directory

cd /d "!currentDir!" >nul 2>>"%APPDATA%\kali_in_batch\errors.log"
