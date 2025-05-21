@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem kali_in_batch.bat
rem    * Main script for the Kali in Batch project.
rem    * Handles installation, boot process, and passes variables to the PowerShell scripts used in the software.
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

rem Color Definitions
set "COLOR_RESET=[0m"
set "COLOR_BLACK=[30m"
set "COLOR_RED=[31m"
set "COLOR_GREEN=[32m"
set "COLOR_YELLOW=[33m"
set "COLOR_BLUE=[34m"
set "COLOR_MAGENTA=[35m"
set "COLOR_CYAN=[36m"
set "COLOR_WHITE=[37m"
set "COLOR_BRIGHT_BLACK=[90m"
set "COLOR_BRIGHT_RED=[91m"
set "COLOR_BRIGHT_GREEN=[92m"
set "COLOR_BRIGHT_YELLOW=[93m"
set "COLOR_BRIGHT_BLUE=[94m"
set "COLOR_BRIGHT_MAGENTA=[95m"
set "COLOR_BRIGHT_CYAN=[96m"
set "COLOR_BRIGHT_WHITE=[97m"

rem Background Colors
set "COLOR_BG_BLACK=[40m"
set "COLOR_BG_RED=[41m"
set "COLOR_BG_GREEN=[42m"
set "COLOR_BG_YELLOW=[43m"
set "COLOR_BG_BLUE=[44m"
set "COLOR_BG_MAGENTA=[45m"
set "COLOR_BG_CYAN=[46m"
set "COLOR_BG_WHITE=[47m"
set "COLOR_BG_BRIGHT_BLACK=[100m"
set "COLOR_BG_BRIGHT_RED=[101m"
set "COLOR_BG_BRIGHT_GREEN=[102m"
set "COLOR_BG_BRIGHT_YELLOW=[103m"
set "COLOR_BG_BRIGHT_BLUE=[104m"
set "COLOR_BG_BRIGHT_MAGENTA=[105m"
set "COLOR_BG_BRIGHT_CYAN=[106m"
set "COLOR_BG_BRIGHT_WHITE=[107m"

rem Text Styles
set "COLOR_BOLD=[1m"
set "COLOR_DIM=[2m"
set "COLOR_ITALIC=[3m"
set "COLOR_UNDERLINE=[4m"
set "COLOR_BLINK=[5m"
set "COLOR_REVERSE=[7m"
set "COLOR_HIDDEN=[8m"
set "COLOR_STRIKETHROUGH=[9m"

rem Combined Styles
set "COLOR_ERROR=!COLOR_BRIGHT_RED!!COLOR_BOLD!"
set "COLOR_WARNING=!COLOR_BRIGHT_YELLOW!!COLOR_BOLD!"
set "COLOR_SUCCESS=!COLOR_BRIGHT_GREEN!!COLOR_BOLD!"
set "COLOR_INFO=!COLOR_BRIGHT_CYAN!"
set "COLOR_DEBUG=!COLOR_BRIGHT_MAGENTA!"
set "COLOR_PROMPT=!COLOR_BRIGHT_BLUE!!COLOR_BOLD!"

cls
set "username=%USERNAME%"
title Kali in Batch
if not exist "%APPDATA%\kali_in_batch" (
    
    echo !COLOR_INFO!Welcome to Kali in Batch Installer!COLOR_RESET!
    echo !COLOR_BG_BLUE!
    echo - Press 1 to install Kali in Batch.
    echo - Press 2 to exit.
    echo !COLOR_RESET!
    echo.
    choice /c 12 /n /m ""
    if errorlevel 2 exit
    if errorlevel 1 (
        cls
        set /p "install_part=Choose a partitition or USB drive to install Kali in Batch on. Drive must be empty. Type the drive letter with a colon (e.g. E:) > "

        echo Testing if it exists...
        if not exist "!install_part!\" (
            echo !COLOR_ERROR!Error: Drive does not exist. Please try again.!COLOR_RESET!
            pause >nul
            exit
        )
        echo Testing if it is empty...
        rem Check if it is empty
        dir "!install_part!\" >nul 2>nul
        if !errorlevel! neq 1 (
            echo !COLOR_ERROR!Error: Drive is not empty. Please try again.!COLOR_RESET!
            pause >nul
            exit
        )
        echo Creating directories...
        mkdir "!install_part!\home" >nul 2>nul
        mkdir "!install_part!\home\!username!" >nul 2>nul
        mkdir "!install_part!\bin" >nul 2>nul
        mkdir "!install_part!\tmp" >nul 2>nul
        echo Creating files...
        echo Checking dependencies...
    )
    where nmap >nul 2>nul
    if !errorlevel! neq 0 (
        echo Press any key to go to https://nmap.org/download.html#windows and download Nmap for Windows...
        pause >nul
        start https://nmap.org/download.html#windows
    )
    where vim >nul 2>nul
    if !errorlevel! neq 0 (
        echo Press any key to go to https://www.vim.org/download.php and download Vim...
        pause >nul
        start https://www.vim.org/download.php
    )
    where powershell >nul 2>nul
    if !errorlevel! neq 0 (
        echo !COLOR_ERROR!CRITICAL ERROR: Powershell is not found. Please repair Windows installation. Your Windows installation may not be genuine.!COLOR_RESET!
        echo You can install a genuine Windows 11 from https://www.microsoft.com/en-us/software-download/windows11 or Windows 10 from https://www.microsoft.com/en-us/software-download/windows10.
        pause >nul
        exit
    )
    where ping >nul 2>nul
    if !errorlevel! neq 0 (
        echo !COLOR_ERROR!CRITICAL ERROR: Ping is not found. Please repair Windows installation. Your Windows installation may not be genuine.!COLOR_RESET!
        echo You can install a genuine Windows 11 from https://www.microsoft.com/en-us/software-download/windows11 or Windows 10 from https://www.microsoft.com/en-us/software-download/windows10.
        pause >nul
        exit
    )
    for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\GitForWindows" /v InstallPath 2^>nul') do set GIT_PATH=%%b
    if not defined GIT_PATH (
        for /f "tokens=2,*" %%a in ('reg query "HKLM\Software\GitForWindows" /v InstallPath 2^>nul') do set GIT_PATH=%%b
    )
    if not defined GIT_PATH (
        echo Press any key to go to https://git-scm.com/downloads/win and download Git for Windows, also ensure you get Git Bash too...
        pause >nul
        start https://git-scm.com/downloads/win
    )
    mkdir "%APPDATA%\kali_in_batch" >nul 2>nul
    @echo on
    echo !install_part!>"%APPDATA%\kali_in_batch\install_part.txt"
    @echo off
	choice /c 12 /m "Done. Press 1 to continue booting, or press 2 to delete your kali rootfs and exit."
	if errorlevel 2 goto wipe
)
rem Set install part to the txt file created in installer
set /p install_part=<"%APPDATA%\kali_in_batch\install_part.txt"
cls
goto boot

:wipe
echo Wiping kali rootfs...
echo.
rmdir /s /q "!install_part!\home\!username!"
rmdir /s /q "!install_part!\bin"
rmdir /s /q "!install_part!\tmp"
rmdir /s /q "!install_part!\home"
rmdir /s /q "%APPDATA%\kali_in_batch"
echo Done, press any key to exit...
pause >nul
cls
exit


:boot

rem Check if %APPDATA%\kali_in_batch\powershell exists and delete it if it does
if exist "%APPDATA%\kali_in_batch\powershell" (
    rmdir /s /q "%APPDATA%\kali_in_batch\powershell"
)
rem Create powershell directory
mkdir "%APPDATA%\kali_in_batch\powershell"
cd /d "%~dp0"
rem Copy .\powershell\* to %APPDATA%\kali_in_batch\powershell
xcopy .\powershell\* "%APPDATA%\kali_in_batch\powershell" /s /y

rem Check if VERSION.txt exists and delete it if it does
if exist "%APPDATA%\kali_in_batch\VERSION.txt" (
    del "%APPDATA%\kali_in_batch\VERSION.txt"
)
rem Create VERSION.txt
echo 2.1.0>"%APPDATA%\kali_in_batch\VERSION.txt"
echo Starting services...
where nmap >nul 2>nul
if !errorlevel! neq 0 (
    echo !COLOR_ERROR!Error: Failed to start Nmap service: Nmap not found.!COLOR_RESET!
    echo Please install Nmap from https://nmap.org/download.html
    pause
    exit
)
where vim >nul 2>nul
if !errorlevel! neq 0 (
    echo !COLOR_WARNING!Warning: Failed to start Vim service: Vim not found. While this is not critical, it is recommended to install it for better text editing experience.!COLOR_RESET!
    echo You can install it from https://www.vim.org/download.php
)

rem Registry interactions in a batch file may make your Antivirus flag it.
for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\GitForWindows" /v InstallPath 2^>nul') do set GIT_PATH=%%b

if not defined GIT_PATH (
    for /f "tokens=2,*" %%a in ('reg query "HKLM\Software\GitForWindows" /v InstallPath 2^>nul') do set GIT_PATH=%%b
)

if defined GIT_PATH (
    set bash_path=!GIT_PATH!\bin\bash.exe
) else (
    echo !COLOR_ERROR!Error: Failed to start Git Bash service: Git for Windows not found.!COLOR_RESET!
    echo Please install Git for Windows from https://git-scm.com/downloads/win
)
where powershell >nul 2>nul
if !errorlevel! neq 0 (
    echo !COLOR_ERROR!CRITICAL ERROR: Powershell is not found. Please repair Windows installation. Your Windows installation may not be genuine.!COLOR_RESET!
    echo You can install a genuine Windows 11 from https://www.microsoft.com/en-us/software-download/windows11 or Windows 10 from https://www.microsoft.com/en-us/software-download/windows10.
    pause 
    exit
)
echo Checking for updates...
curl -# https://codeberg.org/Kali-in-Batch/kali-in-batch/raw/branch/master/VERSION.txt >"!install_part!\tmp\VERSION.txt"
rem Check if the version is the same
set /p remote_version=<"!install_part!\tmp\VERSION.txt"
set /p local_version=<"%APPDATA%\kali_in_batch\VERSION.txt"
if !remote_version! neq !local_version! (
    rem Outdated Kali in Batch installation
    echo !COLOR_WARNING!New version available!!COLOR_RESET!
    echo !COLOR_WARNING!Remote version: !remote_version!!COLOR_RESET!
    echo !COLOR_WARNING!Local version: !local_version!!COLOR_RESET!
    echo Please run git pull in your cloned repository to update.
) else (
    echo !COLOR_SUCCESS!You are running the latest version.!COLOR_RESET!
    echo !COLOR_SUCCESS!Remote version: !remote_version!!COLOR_RESET!
    echo !COLOR_SUCCESS!Local version: !local_version!!COLOR_RESET!
)
timeout /t 1 >nul
rem DEV BRANCH FIX: Delete VERSION.txt in tmp folder
del "!install_part!\tmp\VERSION.txt"
echo.
cls
echo.
goto startup

:startup
rem Navigate to home directory
cd /d "!install_part!\home\!username!"
if %errorlevel% neq 0 (
    echo error
    pause >nul
    exit
)
set "kalirc=!cd!\.kalirc"
set "home_dir=!cd!"
if exist !kalirc! (
    set bash_current_dir=!cd! >nul 2>&1
    set bash_current_dir=!cd:\=/! >nul 2>&1
    set bash_current_dir=!bash_current_dir:C:=/c! >nul 2>&1
    set bash_current_dir=!bash_current_dir:D:=/d! >nul 2>&1
    set bash_current_dir=!bash_current_dir:E:=/e! >nul 2>&1
    set bash_current_dir=!bash_current_dir:F:=/f! >nul 2>&1
    set bash_current_dir=!bash_current_dir:G:=/g! >nul 2>&1
    set bash_current_dir=!bash_current_dir:H:=/h! >nul 2>&1
    set bash_current_dir=!bash_current_dir:I:=/i! >nul 2>&1
    set bash_current_dir=!bash_current_dir:J:=/j! >nul 2>&1
    set bash_current_dir=!bash_current_dir:K:=/k! >nul 2>&1
    set bash_current_dir=!bash_current_dir:L:=/l! >nul 2>&1
    set bash_current_dir=!bash_current_dir:M:=/m! >nul 2>&1
    set bash_current_dir=!bash_current_dir:N:=/n! >nul 2>&1
    set bash_current_dir=!bash_current_dir:O:=/o! >nul 2>&1
    set bash_current_dir=!bash_current_dir:P:=/p! >nul 2>&1
    set bash_current_dir=!bash_current_dir:Q:=/q! >nul 2>&1
    set bash_current_dir=!bash_current_dir:R:=/r! >nul 2>&1
    set bash_current_dir=!bash_current_dir:S:=/s! >nul 2>&1
    set bash_current_dir=!bash_current_dir:T:=/t! >nul 2>&1
    set bash_current_dir=!bash_current_dir:U:=/u! >nul 2>&1
    set bash_current_dir=!bash_current_dir:V:=/v! >nul 2>&1
    set bash_current_dir=!bash_current_dir:W:=/w! >nul 2>&1
    set bash_current_dir=!bash_current_dir:X:=/x! >nul 2>&1
    set bash_current_dir=!bash_current_dir:Y:=/y! >nul 2>&1
    set bash_current_dir=!bash_current_dir:Z:=/z! >nul 2>&1
    !bash_path! -c "cd !bash_current_dir!; source .kalirc" 2>&1
    echo.
    if not exist "!home_dir!\.no_help_startup" (
        echo Hello !username!, welcome to Kali in Batch!
        echo If you want to disable this message, create a file called .no_help_startup in your home directory.
        echo.
    )
    goto shell
) else (
    echo No .kalirc file found. Try creating one, it is a bash script that runs on startup.
    echo.
    echo Hello !username!, welcome to Kali in Batch!
    goto shell
)

:shell
set current_dir=!cd!
if !current_dir!==!home_dir! (
    set current_dir=~
) else (
    set current_dir=!cd!
)

::title Kali in Batch at !current_dir!

rem Replace backslashes with forward slashes in !current_dir!
set current_dir=!current_dir:\=/!
rem Replace drive letters with nothing in !current_dir!
set current_dir=!current_dir:C:=!
set current_dir=!current_dir:D:=!
set current_dir=!current_dir:E:=!
set current_dir=!current_dir:F:=!
set current_dir=!current_dir:G:=!
set current_dir=!current_dir:H:=!
set current_dir=!current_dir:I:=!
set current_dir=!current_dir:J:=!
set current_dir=!current_dir:K:=!
set current_dir=!current_dir:L:=!
set current_dir=!current_dir:M:=!
set current_dir=!current_dir:N:=!
set current_dir=!current_dir:O:=!
set current_dir=!current_dir:P:=!
set current_dir=!current_dir:Q:=!
set current_dir=!current_dir:R:=!
set current_dir=!current_dir:S:=!
set current_dir=!current_dir:T:=!
set current_dir=!current_dir:U:=!
set current_dir=!current_dir:V:=!
set current_dir=!current_dir:W:=!
set current_dir=!current_dir:X:=!
set current_dir=!current_dir:Y:=!
set current_dir=!current_dir:Z:=!

::title Kali in Batch at !current_dir! & rem Moved down here to fix it being a Windows path

goto new_shell_prompt

:new_shell_prompt

rem Check if PS 7+ is installed
rem PS 7+ uses pwsh.exe instead of powershell.exe
where pwsh.exe >nul 2>&1
if !errorlevel!==0 (
    rem It is installed!
) else (
    rem It is not installed!
    echo !COLOR_ERROR!Powershell is not installed.!COLOR_RESET!
    echo !COLOR_INFO!You can install it from the MS Store.!COLOR_RESET!
    exit /b
)

rem As of v2.0.0, the shell is now written in PowerShell due to batch limitations.
pwsh.exe -noprofile -executionpolicy bypass -file "%APPDATA%\kali_in_batch\powershell\shell_prompt.ps1" -bashexepath !bash_path! -installpart !install_part!