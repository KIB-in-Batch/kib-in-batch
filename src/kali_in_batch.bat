@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem kali_in_batch.bat
rem    * Main script for the Kali in Batch project.
rem    * Handles installation, boot process and sets up the bash environment.
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
rem
rem -- Other Scripts --
rem
rem * %~dp0bin\clear.bat - Clears the console
rem * %~dp0bin\pkg.bat - Manages packages
rem * %~dp0bin\touch.bat - Creates a new file
rem * %~dp0bin\uname.bat - Displays system information
rem * %~dp0bin\which.bat - Displays location of a file or directory in the PATH
rem * %~dp0bin\whoami.bat - Displays the current user
rem * %~dp0bin\msfconsole.bat - Uses the Windows Subsystem for Linux to launch the Metasploit Framework


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

    where winget >nul 2>&1
    if !errorlevel! neq 0 (
        echo Winget is not installed.
        echo Redirecting to the winget download page...
        timeout /t 2 /nobreak >nul
        start https://github.com/microsoft/winget-cli
        exit /b
    )
    
    cls
    echo !COLOR_INFO!Kali in Batch Installer!COLOR_RESET!
    echo !COLOR_BG_BLUE!---------------------------------------
    echo ^| * Press 1 to install Kali in Batch. ^|
    echo ^| * Press 2 to exit.                  ^|
    echo ^| * Press 3 to visit the GitHub page. ^|
    echo ---------------------------------------!COLOR_RESET!
    echo.
    choice /c 123 /n /m ""
    if errorlevel 3 (
        start https://github.com/Kali-in-Batch/kali-in-batch
        exit
    )
    if errorlevel 2 exit
    if errorlevel 1 (
        cls
        if exist "C:\Users\!username!\kali" (
            rmdir /s /q "C:\Users\!username!\kali" >nul 2>&1
            echo Creating root filesystem...
            mkdir "C:\Users\!username!\kali" >nul 2>&1
        ) else (
            echo Creating root filesystem...
            mkdir "C:\Users\!username!\kali" >nul 2>&1
        )
        rem Ask for what drive letter to assign to the root filesystem.
        if "%~1"=="automated" (
            set "driveletter=Z:"
        ) else (
            set /p "driveletter=Enter the drive letter to assign to the root filesystem (e.g. Z:) >> "
            echo Drive letter: !driveletter!
        )
        rem Make sure it isn't an existing drive letter.
        if exist !driveletter! (
            echo Drive letter already in use.
            pause >nul
            exit /b
        )
        subst !driveletter! "C:\Users\!username!\kali" >nul 2>&1
        if errorlevel 1 (
            echo Invalid drive letter.
            pause >nul
            exit /b
        )
        set "kaliroot=!driveletter!"
        echo Creating directories...
        mkdir "!kaliroot!\home"
        mkdir "!kaliroot!\home\!username!"
        mkdir "!kaliroot!\tmp"
        mkdir "!kaliroot!\usr"
        mkdir "!kaliroot!\etc"
        mkdir "!kaliroot!\usr\bin"
        rem Make a directory junction so /bin is /usr/bin
        mklink /j "!kaliroot!\bin" "!kaliroot!\usr\bin" >nul
        mkdir "!kaliroot!\usr\lib"
        mkdir "!kaliroot!\usr\share"
        mkdir "!kaliroot!\usr\local"
        mkdir "!kaliroot!\usr\libexec"
        mklink /j "!kaliroot!\lib" "!kaliroot!\usr\lib" >nul
        mkdir "!kaliroot!\var"
        mkdir "!kaliroot!\root"
        xcopy "%~dp0bin\*" "!kaliroot!\usr\bin\" /s /y >nul
        xcopy "%~dp0etc\*" "!kaliroot!\etc\" /s /y >nul
        xcopy "%~dp0lib\*" "!kaliroot!\usr\lib\" /s /y >nul
        xcopy "%~dp0share\*" "!kaliroot!\usr\share\" /s /y >nul
        xcopy "%~dp0libexec\*" "!kaliroot!\usr\libexec\" /s /y >nul
        echo # Add commands to run on startup here>"!kaliroot!\home\!username!\.bashrc"
        echo # Add commands to run on startup here>"!kaliroot!\root\.bashrc"
        echo Checking dependencies...
    )
    where nmap >nul 2>&1
    if !errorlevel! neq 0 (
        echo Installing Nmap from winget...
        winget install --id Insecure.Nmap -e --source winget
    )
    where nvim >nul 2>&1
    if !errorlevel! neq 0 (
        echo Installing Neovim from winget...
        winget install --id Neovim.Neovim -e --source winget
    )
    echo Downloading busybox...
    curl -L -o "!kaliroot!\usr\bin\busybox.exe" "https://frippery.org/files/busybox/busybox64u.exe" -#
    set "busybox_path=!kaliroot!\usr\bin\busybox.exe"
    mkdir "%APPDATA%\kali_in_batch" >nul 2>&1
    @echo on
    echo !kaliroot!>"%APPDATA%\kali_in_batch\kaliroot.txt"
    @echo off
    rem Set install part to the txt file created in installer
    set /p kaliroot=<"%APPDATA%\kali_in_batch\kaliroot.txt"
)
rem Set install part to the txt file created in installer
set /p kaliroot=<"%APPDATA%\kali_in_batch\kaliroot.txt"
mkdir "%APPDATA%\kali_in_batch\emptydir" >nul 2>&1
echo Hello world!>"%APPDATA%\kali_in_batch\emptydir\hello.txt"
cls
copy "%~dp0kibenv" "!kaliroot!\etc\.kibenv" /y >nul 2>&1
goto boot

:wipe
echo Wiping kali rootfs...
echo.
rem Delete all files Kali in Batch creates
rmdir /s /q "C:\Users\!username!\kali"
rmdir /s /q "%APPDATA%\kali_in_batch"
rem Remove the drive letter assignment
subst !kaliroot! /d
echo Done, press any key to exit...
pause >nul
cls
exit


:boot
rem Boot process for Kali in Batch
rem It handles essential checks to make sure Kali in Batch can boot properly.

for /f "delims=" %%i in ('powershell -command "[System.Environment]::OSVersion.Version.ToString()"') do set kernelversion=%%i

cls

echo Welcome to Kali in Batch 9.0 ^(%PROCESSOR_ARCHITECTURE%^)
echo Booting system...
echo ------------------------------------------------
::                                                                 |
<nul set /p "=Assigning drive letter...                            "

rem Check if the !kaliroot! virtual drive letter is still assigned
if exist !kaliroot! (
    rem Nothing to do
) else (
    rem Fix for Kali in Batch not booting after a Windows reboot due to it deleting the virtual drive
    subst !kaliroot! "C:\Users\!username!\kali" >nul 2>&1
)

<nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
echo.

::                                                                 |
<nul set /p "=Checking if rescue is required...                    "

set "rescue_required=0"

if not exist "!kaliroot!\etc" set rescue_required=1
if not exist "!kaliroot!\tmp" set rescue_required=1
if not exist "!kaliroot!\usr" set rescue_required=1
if not exist "!kaliroot!\bin" set rescue_required=1
if not exist "!kaliroot!\usr\bin" set rescue_required=1
if not exist "!kaliroot!\usr\local" set rescue_required=1
if not exist "!kaliroot!\usr\share" set rescue_required=1
if not exist "!kaliroot!\usr\lib" set rescue_required=1
if not exist "!kaliroot!\home" set rescue_required=1
if not exist "!kaliroot!\home\!username!" set rescue_required=1
if not exist "!kaliroot!\usr\libexec" set rescue_required=1
if not exist "!kaliroot!\var" set rescue_required=1
if not exist "!kaliroot!\root" set rescue_required=1
if not exist "!kaliroot!\lib" set rescue_required=1

if %rescue_required%==1 (
    if not exist "!kaliroot!\etc" mkdir "!kaliroot!\etc"
    if not exist "!kaliroot!\tmp" mkdir "!kaliroot!\tmp"
    if not exist "!kaliroot!\usr" (
        mkdir "!kaliroot!\usr"
        mkdir "!kaliroot!\usr\bin"
        mkdir "!kaliroot!\usr\share"
        mkdir "!kaliroot!\usr\lib"
        mkdir "!kaliroot!\usr\local"
        mkdir "!kaliroot!\usr\libexec"
    )
    if not exist "!kaliroot!\usr\bin" mkdir "!kaliroot!\usr\bin"
    if not exist "!kaliroot!\usr\share" mkdir "!kaliroot!\usr\share"
    if not exist "!kaliroot!\usr\lib" mkdir "!kaliroot!\usr\lib"
    if not exist "!kaliroot!\usr\local" mkdir "!kaliroot!\usr\local"
    if not exist "!kaliroot!\usr\libexec" mkdir "!kaliroot!\usr\libexec"
    if not exist "!kaliroot!\bin" mklink /j "!kaliroot!\bin" "!kaliroot!\usr\bin" >nul
    if not exist "!kaliroot!\home" mkdir "!kaliroot!\home"
    if not exist "!kaliroot!\home\!username!" mkdir "!kaliroot!\home\!username!"
    if not exist "!kaliroot!\var" mkdir "!kaliroot!\var"
    if not exist "!kaliroot!\root" mkdir "!kaliroot!\root"
    if not exist "!kaliroot!\lib" mklink /j "!kaliroot!\lib" "!kaliroot!\usr\lib" >nul
)

<nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
echo.

::                                                                 |
<nul set /p "=Initializing ROOT environment variable...            "

rem Initialize ROOT variable
set "ROOT=0"

<nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
echo.

::                                                                 |
<nul set /p "=Copying core files from local repository...          "

xcopy "%~dp0bin\*" "!kaliroot!\usr\bin\" /s /y >nul 2>&1
xcopy "%~dp0etc\*" "!kaliroot!\etc\" /s /y >nul 2>&1
xcopy "%~dp0lib\*" "!kaliroot!\usr\lib\" /s /y >nul 2>&1
xcopy "%~dp0share\*" "!kaliroot!\usr\share\" /s /y >nul 2>&1
xcopy "%~dp0libexec\*" "!kaliroot!\usr\libexec\" /s /y >nul 2>&1
(
    echo #!/bin/bash
    echo.
    echo ########################
    echo #                      #
    echo #       WARNING        #
    echo #                      #
    echo #  This script is      #
    echo #  NOT intended for    #
    echo #  modification in the #
    echo #  Kali in Batch       #
    echo #  environment. It is  #
    echo #  overwritten when    #
    echo #  you boot Kali in    #
    echo #  Batch.              #
    echo #                      #
    echo #  To add your own     #
    echo #  configurations,     #
    echo #  modify ~/.bashrc    #
    echo #  instead.            #
    echo #                      #
    echo ########################
    echo.
    echo ## Kali Linux shell prompt ##
    echo.
    echo # Check if ROOT is 1
    echo.
    echo if [ "$ROOT" == "1" ]; then
    echo     PS1=$'\[\e[34m\]┌──^(\[\e[31m\]root㉿\h\[\e[34m\]^)-[\[\e[0m\]\w\[\e[34m\]]\n\[\e[34m\]└─\[\e[31m\]# \[\e[0m\]'
    echo else
    echo     PS1=$'\[\e[32m\]┌──^(\[\e[34m\]\u㉿\h\[\e[32m\]^)-[\[\e[0m\]\w\[\e[32m\]]\n\[\e[32m\]└─\[\e[34m\]$ \[\e[0m\]'
    echo fi
    echo.
    echo ## Changes to PATH ##
    echo.
    echo export PATH="C:/Users/$USERNAME/kali/usr/bin:$PATH"
    echo.
    echo ## Aliases ##
    echo.
    echo alias clear="clear.bat"
    echo alias pkg="pkg.bat"
    echo alias touch="touch.bat"
    echo alias uname="uname.bat"
    echo alias which="which.bat"
    echo alias whoami="whoami.bat"
    echo alias msfconsole="msfconsole.bat"
    echo.
    echo alias netcat="nc"
    echo.
    echo ## Functions ##
    echo.
    echo sudo^(^) {
    echo     export ROOT="1"
    echo     export USER="root"
    echo     "$@" # Run the arguments
    echo     export ROOT="0"
    echo     export USER="$USERNAME"
    echo }
    echo.
    echo su^(^) {
    echo     export ROOT="1"
    echo     export USER="root"
    echo     PS1=$'\[\e[34m\]┌──^(\[\e[31m\]root㉿\h\[\e[34m\]^)-[\[\e[0m\]\w\[\e[34m\]]\n\[\e[34m\]└─\[\e[31m\]# \[\e[0m\]'
    echo }
    echo.
    echo unsu^(^) {
    echo     export ROOT="0"
    echo     export USER="$USERNAME"
    echo     PS1=$'\[\e[32m\]┌──^(\[\e[34m\]\u㉿\h\[\e[32m\]^)-[\[\e[0m\]\w\[\e[32m\]]\n\[\e[32m\]└─\[\e[34m\]$ \[\e[0m\]'
    echo }
    echo.
    echo ## Load ~/.bashrc ##
    echo.
    echo source ~/.bashrc
) > "!kaliroot!\etc\.kibenv"

(
    echo NAME="Kali in Batch"
    echo VERSION="9.0"
    echo ID=kalibatch
    echo ID_LIKE=linux
    echo VERSION_ID="9.0"
    echo PRETTY_NAME="Kali in Batch 9.0"
    echo ANSI_COLOR="0;36"
    echo HOME_URL="https://kali-in-batch.github.io"
    echo SUPPORT_URL="https://github.com/Kali-in-Batch/kali-in-batch/discussions"
    echo BUG_REPORT_URL="https://github.com/Kali-in-Batch/kali-in-batch/issues"
) > "!kaliroot!\etc\os-release"

if !errorlevel! neq 0 (
    <nul set /p "=[ !COLOR_ERROR!FAILED!COLOR_RESET! ]"
    echo.
    echo Note: It is very likely that the script did not fail to copy files.
) else (
    <nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
    echo.
)

rem Check if VERSION.txt exists and delete it if it does
if exist "%APPDATA%\kali_in_batch\VERSION.txt" (
    del "%APPDATA%\kali_in_batch\VERSION.txt"
)
rem Create VERSION.txt
echo 9.0>"%APPDATA%\kali_in_batch\VERSION.txt"

::                                                                 |
<nul set /p "=Starting Nmap service...                             "

where nmap >nul 2>&1
if !errorlevel! neq 0 (
    <nul set /p "=[ !COLOR_ERROR!FAILED!COLOR_RESET! ]"
    echo.
) else (
    <nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
    echo.
)

::                                                                 |
<nul set /p "=Starting Neovim service...                           "

where nvim >nul 2>&1
if !errorlevel! neq 0 (
    <nul set /p "=[ !COLOR_ERROR!FAILED!COLOR_RESET! ]"
    echo.
) else (
    <nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
    echo.
)

::                                                                 |
<nul set /p "=Starting Bash service...                             "

curl -L -o "!kaliroot!\usr\bin\busybox.exe" "https://frippery.org/files/busybox/busybox64u.exe" -s

<nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
echo.

set "busybox_path=!kaliroot!\usr\bin\busybox.exe"

::                                                                 |
<nul set /p "=Checking for remote updates...                       "

curl -s https://raw.githubusercontent.com/Kali-in-Batch/kali-in-batch/refs/heads/master/VERSION.txt >"!kaliroot!\tmp\VERSION.txt"
rem Check if the version is the same
set /p remote_version=<"!kaliroot!\tmp\VERSION.txt"
set /p local_version=<"%APPDATA%\kali_in_batch\VERSION.txt"
if !remote_version! neq !local_version! (
    rem Outdated Kali in Batch installation
    <nul set /p "=[ !COLOR_WARNING!OUTDATED!COLOR_RESET! ]"
    echo.
) else (
    <nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
    echo.
)

echo ------------------------------------------------

echo !COLOR_SUCCESS!System boot completed.!COLOR_RESET!
if "%~1"=="automated" (
    del "!kaliroot!\tmp\VERSION.txt" >nul 2>&1
    set "USER=!username!"
    set "ROOT=0"
    echo.
    cls
    goto startup
) else (
    echo Press any key to log into the system...
    pause >nul
    goto login
)

:login

cls
echo Kali in Batch 9.0
echo Kernel !kernelversion! on an %PROCESSOR_ARCHITECTURE%
echo.
echo Users on this system: !username!, root
echo.
set /p loginkibusername=%COMPUTERNAME% login: 
if "!loginkibusername!"=="!username!" (
    rem Correct
    set "USER=!username!"
    set "ROOT=0"
    echo !COLOR_SUCCESS!User found!COLOR_RESET!
    echo Connecting to Bash service...
    timeout /t 1 /nobreak >nul 2>&1
) else if "!loginkibusername!"=="root" (
    set "ROOT=1"
    set "USER=root"
    echo !COLOR_SUCCESS!User found!COLOR_RESET!
    echo Connecting to Bash service...
    timeout /t 1 /nobreak >nul 2>&1
) else (
    rem Incorrect
    echo !COLOR_ERROR!User not found!COLOR_RESET!
    echo Press any key to try again...
    pause >nul
    goto login
)

del "!kaliroot!\tmp\VERSION.txt"
echo.
cls
goto startup

:startup
rem Navigate to home directory
cd /d "C:\Users\!username!\kali\home\!username!"
if %errorlevel% neq 0 (
    echo !COLOR_ERROR!Fatal error, unable to navigate to home directory.!COLOR_RESET!
    pause >nul
    exit /b 69
)
set "kibenv=!kaliroot!\etc\.kibenv"
set "home_dir=!cd!"

:shell

echo ██   ██  █████  ██      ██     ██ ███    ██     ██████   █████  ████████  ██████ ██   ██
echo ██  ██  ██   ██ ██      ██     ██ ████   ██     ██   ██ ██   ██    ██    ██      ██   ██
echo █████   ███████ ██      ██     ██ ██ ██  ██     ██████  ███████    ██    ██      ███████
echo ██  ██  ██   ██ ██      ██     ██ ██  ██ ██     ██   ██ ██   ██    ██    ██      ██   ██
echo ██   ██ ██   ██ ███████ ██     ██ ██   ████     ██████  ██   ██    ██     ██████ ██   ██
echo.

if not exist "!kaliroot!\tmp" (
    mkdir "!kaliroot!\tmp"
)

if "!ROOT!"=="0" (
    set "HOME=!kaliroot!\home\!username!"
) else (
    set "HOME=!kaliroot!\root"
)

if not exist "!HOME!\.bashrc" (
    echo # Add commands to run on startup here>"!HOME!\.bashrc"
)

set "ENV=C:/Users/!username!/kali/etc/.kibenv"

if not exist "!HOME!\.hushlogin" (
    echo For a guide on how to use Kali in Batch, run 'ls -l /usr/share/guide' and
    echo open the text file that you think will help you.
    echo.
    echo Example:
    echo $ less /usr/share/guide/hacking.txt # Less is used here because you can scroll
    echo.
    echo To disable this message, create a file called .hushlogin in your home directory.
)

"!busybox_path!" bash -l
