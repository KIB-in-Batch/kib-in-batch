@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem kib_in_batch.bat
rem    * Main script for the KIB in Batch project.
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
rem * %~dp0bin\kib-pkg.bat - Manages packages
rem * %~dp0bin\kpkg.bat - Wrapper for kib-pkg
rem * %~dp0bin\pkg.bat - Wrapper for kib-pkg (only exists for backward compatibility)
rem * %~dp0bin\uname.bat - Displays system information
rem * %~dp0bin\which.bat - Displays location of a file or directory in the PATH
rem * %~dp0bin\whoami.bat - Displays the current user
rem * %~dp0bin\kibfetch.bat - Simple neofetch-like program
rem * %~dp0bin\chsh.bat - Changes default shell
rem * %~dp0bin\kibdock.bat - Containerization program for KIB

if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    cls
    echo This app cannot run on your PC.
    echo Press any key to continue...
    pause >nul
    exit /b 1
)

if not exist "%~dp0..\kibposix\kibposix.dll" (
    echo POSIX DLL not found. Please compile it.
    echo Press any key to continue...
    pause >nul
    exit /b 1
)

if not exist "%~dp0..\kibposix\libkibposix.dll.a" (
    echo POSIX DLL not found. Please compile it.
    echo Press any key to continue...
    pause >nul
    exit /b 1
)

if defined ConEmuPID (
    echo Running inside ConEmu
    goto ok
)

if defined WT_SESSION (
    echo Running inside Windows Terminal
    goto ok
)

if defined MSYSTEM (
    echo Running inside MSYS2
    goto ok
)

if "%USERNAME%"=="runneradmin" goto ok

echo Please use a supported terminal emulator. The following terminals are supported:
echo.
echo * MSYS2
echo * Windows Terminal
echo * ConEmu
pause >nul
exit /b 1

:ok

rem Ensure compatibility with older Windows builds by enabling ANSI escape codes manually

reg add "HKCU\Console" /f >nul

reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f

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
set "COLOR_INFO=!COLOR_BRIGHT_CYAN!!COLOR_BOLD!"
set "COLOR_DEBUG=!COLOR_BRIGHT_MAGENTA!!COLOR_BOLD!"
set "COLOR_PROMPT=!COLOR_BRIGHT_BLUE!!COLOR_BOLD!"

rem Check multiple Wine indicators
set WINE_DETECTED=0

rem Check Wine registry keys
reg query "HKEY_CURRENT_USER\Software\Wine" >nul 2>&1
if %errorlevel% equ 0 set WINE_DETECTED=1

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wine" >nul 2>&1
if %errorlevel% equ 0 set WINE_DETECTED=1

rem Check Wine environment variables
if defined WINEPREFIX set WINE_DETECTED=1
if defined WINEARCH set WINE_DETECTED=1

rem Fail if Wine is detected
if %WINE_DETECTED% equ 1 (
    echo.
    echo ERROR: Wine environment detected!
    echo This script requires native Windows PowerShell.
    echo Wine's PowerShell implementation is incomplete and will cause failures.
    echo.
    echo Please run this script on native Windows.
    exit /b 1
)

where powershell >nul 2>&1

if %errorlevel% neq 0 (
    echo PowerShell not found.
    exit /b 1
)

if not exist "%~dp0bin" (
    echo This script is not meant to be used standalone.
    pause >nul
    start https://github.com/KIB-in-Batch/kib-in-batch/releases/latest
    exit /b 1
) else if not exist "%~dp0share" (
    echo This script is not meant to be used standalone.
    pause >nul
    start https://github.com/KIB-in-Batch/kib-in-batch/releases/latest
    exit /b 1
) else if not exist "%~dp0lib" (
    echo This script is not meant to be used standalone.
    pause >nul
    start https://github.com/KIB-in-Batch/kib-in-batch/releases/latest
    exit /b 1
) else if not exist "%~dp0include" (
    echo This script is not meant to be used standalone.
    pause >nul
    start https://github.com/KIB-in-Batch/kib-in-batch/releases/latest
    exit /b 1
)

where curl >nul 2>&1

if !errorlevel! neq 0 (
    echo !COLOR_ERROR!CRITICAL: Curl is not installed, exiting before anything can be done...!COLOR_RESET!
    pause >nul
    exit /b 1
)

rem Check if %APPDATA%\kib_in_batch\VERSION.txt exists

if exist "%APPDATA%\kib_in_batch\VERSION.txt" (
    rem Split by . using a for loop
    for /f "tokens=1 delims=." %%a in ('type "%APPDATA%\kib_in_batch\VERSION.txt"') do (
        set /a "version=%%a"
        if !version! lss 11 (
            echo Please reinstall KIB in Batch. This release has breaking changes.
            pause >nul
            exit /b 1
        )
    )
)

mkdir "%TEMP%\dummy.kib.d"

mklink /d "%~dp0test" "%TEMP%\dummy.kib.d"

rem Check if symlink creation is available

if errorlevel 1 (
    echo !COLOR_ERROR!CRITICAL: Symlink creation is not available. Requesting elevation...!COLOR_RESET!
    rmdir /s /q "%~dp0test" >nul 2>&1
    rmdir /s /q "%TEMP%\dummy.kib.d" >nul 2>&1
    net session >nul 2>&1
    if errorlevel 1 (
        echo ATTEMPT 1: Using sudo for Windows.
        "%SystemRoot%\System32\sudo.exe" "%~f0"
        if errorlevel 1 (
            echo ATTEMPT 2: Using PowerShell
            rem Elevate using powershell
            powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs" >nul 2>&1
        )
    ) else (
        echo Still cannot create symlinks. Please check you are using NTFS, or using Windows Vista or newer.
        pause >nul
        exit /b 1
    )
    exit /b 1
)

rmdir /s /q "%~dp0test" >nul 2>&1
rmdir /s /q "%TEMP%\dummy.kib.d" >nul 2>&1

cls
set "username=%USERNAME%"
title KIB in Batch
set "missing="
if not exist "%APPDATA%\kib_in_batch" set "missing=1"
if not exist "%USERPROFILE%\kib" set "missing=1"

if defined missing (

    where winget >nul 2>&1
    if !errorlevel! neq 0 (
        echo Winget is not installed. Nmap and Neovim will not be able to be automatically installed.
        timeout /t 1 /nobreak >nul
    )
    
    cls
    echo !COLOR_INFO!KIB in Batch Installer!COLOR_RESET!
    echo !COLOR_BG_BLUE!-----------------------------------------------------
    echo ^| * Press 1 to install KIB in Batch.                ^|
    echo ^| * Press 2 to exit.                                ^|
    echo ^| * Press 3 to enter manual install ^(live shell^).   ^|
    echo ^| * Press 4 to visit the GitHub page.               ^|
    echo -----------------------------------------------------!COLOR_RESET!
    echo.
    choice /c 1234 /n /m ""
    if errorlevel 4 (
        start https://github.com/KIB-in-Batch/kib-in-batch
        exit
    )
    if errorlevel 3 goto live_shell
    if errorlevel 2 exit
    if errorlevel 1 (
        mkdir "%APPDATA%\kib_in_batch"
        cls
        if exist "%USERPROFILE%\kib" (
            rmdir /s /q "%USERPROFILE%\kib" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
            echo Creating root filesystem...
            mkdir "%USERPROFILE%\kib" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        ) else (
            echo Creating root filesystem...
            mkdir "%USERPROFILE%\kib" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
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
        subst !driveletter! "%USERPROFILE%\kib" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        if errorlevel 1 (
            echo Invalid drive letter.
            pause >nul
            exit /b
        )
        set "kibroot=!driveletter!"
        echo Creating directories...
        mkdir "!kibroot!\home" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "!kibroot!\home\!username!" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        rem Copy all files from %USERPROFILE%\kalihome.bak.d\* to %USERPROFILE%\kib\home\!username!
        robocopy "%USERPROFILE%\kalihome.bak.d" "%USERPROFILE%\kib\home\!username!" /E /COPY:DATS /R:0 /W:0 /NFL /NDL /NJH /NJS /NP
        mkdir "!kibroot!\tmp" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "!kibroot!\usr" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "!kibroot!\etc" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "!kibroot!\usr\bin" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mklink /d "!kibroot!\bin" "!kibroot!\usr\bin" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        if errorlevel 1 (
            echo !COLOR_ERROR!Could not create symlinks. Please run as admin or enable developer mode in settings.!COLOR_RESET!
            pause >nul
            exit /b 1
        )
        mkdir "!kibroot!\usr\lib" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "!kibroot!\usr\share" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "!kibroot!\usr\local" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "!kibroot!\usr\libexec" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mklink /d "!kibroot!\lib" "!kibroot!\usr\lib" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        if errorlevel 1 (
            echo !COLOR_ERROR!Could not create symlinks. Please run as admin or enable developer mode in settings.!COLOR_RESET!
            pause >nul
            exit /b 1
        )
        mkdir "!kibroot!\var" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "!kibroot!\root" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        xcopy "%~dp0bin\*" "!kibroot!\usr\bin\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        xcopy "%~dp0etc\*" "!kibroot!\etc\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        xcopy "%~dp0lib\*" "!kibroot!\usr\lib\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        xcopy "%~dp0share\*" "!kibroot!\usr\share\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        xcopy "%~dp0libexec\*" "!kibroot!\usr\libexec\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        echo # Add commands to run on startup here>"!kibroot!\home\!username!\.bashrc"
        echo # Add commands to run on startup here>"!kibroot!\root\.bashrc"
        echo Checking dependencies...
    )
    where nmap >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
    if !errorlevel! neq 0 (
        echo Installing Nmap from winget...
        winget install --id Insecure.Nmap -e --source winget
        if errorlevel 1 (
            echo Winget not available or failed to install Nmap.
        )
    )
    where nvim >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
    if !errorlevel! neq 0 (
        echo Installing Neovim from winget...
        winget install --id Neovim.Neovim -e --source winget
        if errorlevel 1 (
            echo Winget not available or failed to install Neovim.
        )
    )
    echo Downloading busybox...
    curl -L -o "!kibroot!\usr\bin\busybox.exe" "https://github.com/KIB-in-Batch/busybox-w32/releases/latest/download/busybox64.exe" -#
    set "busybox_path=!kibroot!\usr\bin\busybox.exe"
    mkdir "%APPDATA%\kib_in_batch" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
    @echo on
    echo !kibroot!>"%APPDATA%\kib_in_batch\kibroot.txt"
    @echo off
    rem Set install part to the txt file created in installer
    set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"
)
rem Set install part to the txt file created in installer
set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"
cls
copy "%~dp0kibenv" "!kibroot!\etc\.kibenv" /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
goto boot

:live_shell

echo !COLOR_INFO!Starting live shell...!COLOR_RESET!
mkdir "%APPDATA%\kib_in_batch" >nul 2>&1
cd /d "%APPDATA%\kib_in_batch" >nul 2>&1
cls
echo !COLOR_INFO!Type help for a list of commands.!COLOR_RESET!
echo !COLOR_INFO!Note that kibstrap and mkdrive are REQUIRED for a functional installation.!COLOR_RESET!
echo !COLOR_INFO!You must type kibstrap before running mkdrive.!COLOR_RESET!
echo !COLOR_INFO!You must run kibstrap and mkdrive before running kib-pkg.!COLOR_RESET!
echo !COLOR_INFO!Running getdeps is recommended because it installs Nmap ^(a powerful reconnaissance tool^) and Neovim ^(a powerful text editor^).!COLOR_RESET!
goto live_shell_loop
:live_shell_loop
set "input="
set "args="
set "currentdir=!cd!"
rem Replace backslashes with forward slashes in currentdir
set "currentdir=!currentdir:\=/!"
set /p "input=!COLOR_BRIGHT_RED!root!COLOR_RESET!@kibiso: !COLOR_BOLD!!currentdir!!COLOR_RESET! # "
if defined input (
    for /f "tokens=1,*" %%a in ("!input!") do (
        set "input=%%~a"
        if not "%%~b"=="" (
            set "args=%%~b"
        )
    )

    if "!input!"=="help" (
        echo !COLOR_INFO!Available commands: !COLOR_RESET!
        echo !COLOR_INFO!  - help: Displays this help message. !COLOR_RESET!
        echo !COLOR_INFO!  - exit: Exits the live shell. !COLOR_RESET!
        echo !COLOR_INFO!  - kibstrap: Bootstraps a minimal base system at %USERPROFILE%\kib. !COLOR_RESET!
        echo !COLOR_INFO!  - kib-pkg: Package manager. Use it if you want packages in your base system. !COLOR_RESET!
        echo !COLOR_INFO!  - getdeps: Installs dependencies of KIB in Batch. !COLOR_RESET!
        echo !COLOR_INFO!  - mkdrive: Uses subst to create a drive letter for the KIB in Batch root. !COLOR_RESET!
        echo !COLOR_INFO!  - boot: Boots the KIB in Batch installation. !COLOR_RESET!
        echo !COLOR_INFO!  - clear: Clears the screen. !COLOR_RESET!
        echo !COLOR_INFO!  - wipe: Wipes the KIB in Batch installation. !COLOR_RESET!
        echo !COLOR_INFO!  - cd: Changes the current directory. !COLOR_RESET!
        echo !COLOR_INFO!  - mkdir: Creates a new directory. !COLOR_RESET!
        echo !COLOR_INFO!  - rmdir: Removes a directory. !COLOR_RESET!
        echo !COLOR_INFO!  - rm: Removes a file. !COLOR_RESET!
        echo !COLOR_INFO!  - cp: Copies a file. !COLOR_RESET!
        echo !COLOR_INFO!  - mv: Moves a file. !COLOR_RESET!
        echo !COLOR_INFO!  - ls: Lists the files in the current directory. !COLOR_RESET!
        echo.
    ) else if "!input!"=="exit" (
        echo !COLOR_INFO!Exiting live shell...!COLOR_RESET!
        goto wipe
    ) else if "!input!"=="kibstrap" (
        mkdir "%USERPROFILE%\kib\home" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "%USERPROFILE%\kib\home\!username!" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        rem Copy all files from %USERPROFILE%\kalihome.bak.d\* to %USERPROFILE%\kib\home\!username!
        robocopy "%USERPROFILE%\kalihome.bak.d" "%USERPROFILE%\kib\home\!username!" /E /COPY:DATS /R:0 /W:0 /NFL /NDL /NJH /NJS /NP
        mkdir "%USERPROFILE%\kib\tmp" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "%USERPROFILE%\kib\usr" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "%USERPROFILE%\kib\etc" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "%USERPROFILE%\kib\usr\bin" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mklink /d "%USERPROFILE%\kib\bin" "%USERPROFILE%\kib\usr\bin" >nul 2>&1
        if errorlevel 1 (
            echo !COLOR_ERROR!Could not create symlinks. Please run as admin or enable developer mode in settings.!COLOR_RESET!
            goto wipe
        )
        mkdir "%USERPROFILE%\kib\usr\lib" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "%USERPROFILE%\kib\usr\share" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "%USERPROFILE%\kib\usr\local" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "%USERPROFILE%\kib\usr\libexec" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mklink /d "%USERPROFILE%\kib\lib" "%USERPROFILE%\kib\usr\lib" >nul 2>&1
        if errorlevel 1 (
            echo !COLOR_ERROR!Could not create symlinks. Please run as admin or enable developer mode in settings.!COLOR_RESET!
            pause >nul
            goto wipe
        )
        mkdir "%USERPROFILE%\kib\var" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        mkdir "%USERPROFILE%\kib\root" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        xcopy "%~dp0bin\*" "%USERPROFILE%\kib\usr\bin\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        xcopy "%~dp0etc\*" "%USERPROFILE%\kib\etc\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        xcopy "%~dp0lib\*" "%USERPROFILE%\kib\usr\lib\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        xcopy "%~dp0share\*" "%USERPROFILE%\kib\usr\share\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        xcopy "%~dp0libexec\*" "%USERPROFILE%\kib\usr\libexec\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        echo # Add commands to run on startup here>"%USERPROFILE%\kib\home\!username!\.bashrc"
        echo # Add commands to run on startup here>"%USERPROFILE%\kib\root\.bashrc"
        curl -L -o "%USERPROFILE%\kib\usr\bin\busybox.exe" "https://github.com/KIB-in-Batch/busybox-w32/releases/latest/download/busybox64.exe" -#
        if errorlevel 1 (
            echo !COLOR_ERROR!Could not download busybox. Please check your internet connection.!COLOR_RESET
            pause >nul
            goto wipe
        )
        set "busybox_path=%USERPROFILE%\kib\usr\bin\busybox.exe"
        mkdir "%APPDATA%\kib_in_batch" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        call :create_symlinks
    ) else if "!input!"=="mkdrive" (
        if not defined args (
            echo !COLOR_ERROR!Please specify the drive letter.!COLOR_RESET!
            goto live_shell_loop
        )
        set "kibroot=!args!"
        if exist !kibroot! (
            echo Drive letter already in use.
        )
        subst !kibroot! "%USERPROFILE%\kib" >nul 2>&1
        if errorlevel 1 (
            echo Invalid drive letter.
        )
        @echo on
        echo !kibroot!>"%APPDATA%\kib_in_batch\kibroot.txt"
        @echo off
        rem Set install part to the txt file created in installer
        set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"
    ) else if "!input!"=="clear" (
        cls
    ) else if "!input!"=="boot" (
        set "busybox_path=!kibroot!\usr\bin\busybox.exe"
        copy "%~dp0kibenv" "!kibroot!\etc\.kibenv" /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
        goto boot
    ) else if "!input!"=="wipe" (
        goto wipe
    ) else if "!input!"=="getdeps" (
        call :get_deps
    ) else if "!input!"=="kib-pkg" (
        set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"
        set "kib-pkg_path=!kibroot!\usr\bin\kib-pkg.bat"
        call "!kib-pkg_path!" !args!
    ) else if "!input!"=="cd" (
        cd /d "!args!" >nul 2>&1
    ) else if "!input!"=="mkdir" (
        mkdir "!args!" >nul 2>&1
    ) else if "!input!"=="rmdir" (
        rmdir /s /q "!args!" >nul 2>&1
    ) else if "!input!"=="rm" (
        del /f /q "!args!" >nul 2>&1
    ) else if "!input!"=="ls" (
        dir !args!
    ) else if "!input!"=="cp" (
        copy !args!
    ) else if "!input!"=="mv" (
        ren !args!
    ) else (
        !input! !args!
    )
)
goto live_shell_loop 

:wipe
echo Wiping kib rootfs...
echo.
rem Remove the subst drive
set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"
subst !kibroot! /d >nul 2>&1
rem Delete all files KIB in Batch creates
rmdir /s /q "%USERPROFILE%\kib" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
rmdir /s /q "%APPDATA%\kib_in_batch" >nul 2>&1
echo Done, press any key to exit...
pause >nul
cls
exit

:get_deps

where nmap >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
if !errorlevel! neq 0 (
    echo Installing Nmap from winget...
    winget install --id Insecure.Nmap -e --source winget
) else (
    echo Nmap is already installed.
)
where nvim >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
if !errorlevel! neq 0 (
    echo Installing Neovim from winget...
    winget install --id Neovim.Neovim -e --source winget
) else (
    echo Neovim is already installed.
)
goto :eof

:boot

where gh >nul 2>&1
if errorlevel 1 (
    rem GitHub CLI isn’t installed, skip
    goto :after_issue_prompt
)


if exist "%APPDATA%\kib_in_batch\cpuvars.txt" (
    echo CPU info is cached.
    echo If you recently changed something about your CPU, delete "%APPDATA%\kib_in_batch\cpuvars.txt".
    echo.
) else (
    echo CPU info is not cached. Cache will be generated on boot, so setting up /proc will be slow.
    echo.
)
echo There may have been errors logged.
echo Would you like to file a GitHub issue with the log contents?
choice /c YN /n /m "Create issue now? [Y/N] "
if errorlevel 2 goto :after_issue_prompt

set "body="
for /f "usebackq delims=" %%L in ("%APPDATA%\kib_in_batch\errors.log") do (
    set "body=!body!%%L\n"
)

gh issue create ^
  --repo KIB-in-Batch/kib-in-batch ^
  --title "KIB in Batch errors on %COMPUTERNAME%" ^
  --body "!body!"

:after_issue_prompt

rem Check if "%APPDATA%\kib_in_batch\errors.log" is over 100 lines long using a for loop

set lines=0

for /f "usebackq delims=" %%L in ("%APPDATA%\kib_in_batch\errors.log") do (
    set /a lines+=1
)

if !lines! geq 100 (
    echo More than 100 errors logged, cleaning up
    echo. > "%APPDATA%\kib_in_batch\errors.log" 2>nul
)

rem Boot process for KIB in Batch
rem It handles essential checks to make sure KIB in Batch can boot properly.

if not exist "%USERPROFILE%\kib" (
    echo Your installation is broken
    goto live_shell
) else if not exist "%APPDATA%\kib_in_batch" (
    echo Your installation is broken
    goto live_shell
)

for /f "delims=" %%i in ('powershell -command "[System.Environment]::OSVersion.Version.ToString()"') do set kernelversion=%%i

echo.
echo Welcome to KIB in Batch 11.0.0-untagged ^(%PROCESSOR_ARCHITECTURE%^)
echo Booting system...
echo ------------------------------------------------
if not exist "%APPDATA%\kib_in_batch\kibroot.txt" goto live_shell

set "starttime=%time%"

::                                                                 |
<nul set /p "=Assigning drive letter...                            "

if not "!kibroot:~1,1!"==":" (
    rem Cause a boot loop
    <nul set /p "=[ !COLOR_ERROR!FAILED!COLOR_RESET! ]"
    echo.
    echo Press any key to continue...
    pause >nul
    del "%APPDATA%\kib_in_batch\kibroot.txt" >nul 2>&1
    cls
    goto boot
)

rem Check if the !kibroot! virtual drive letter is still assigned
if exist !kibroot! (
    rem Nothing to do
) else (
    rem Fix for KIB in Batch not booting after a Windows reboot due to it deleting the virtual drive
    subst !kibroot! "%USERPROFILE%\kib" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
    if errorlevel 1 (
        rem Cause a boot loop
        <nul set /p "=[ !COLOR_ERROR!FAILED!COLOR_RESET! ]"
        echo.
        echo Press any key to continue...
        pause >nul
        del "%APPDATA%\kib_in_batch\kibroot.txt" >nul 2>&1
        cls
        goto boot
    )
)

<nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
echo.

::                                                                 |
<nul set /p "=Checking if rescue is required...                    "

set "rescue_required=0"

if not exist "!kibroot!\etc" set rescue_required=1
if not exist "!kibroot!\tmp" set rescue_required=1
if not exist "!kibroot!\usr" set rescue_required=1
if not exist "!kibroot!\bin" set rescue_required=1
if not exist "!kibroot!\usr\bin" set rescue_required=1
if not exist "!kibroot!\usr\local" set rescue_required=1
if not exist "!kibroot!\usr\share" set rescue_required=1
if not exist "!kibroot!\usr\lib" set rescue_required=1
if not exist "!kibroot!\home" set rescue_required=1
if not exist "!kibroot!\home\!username!" set rescue_required=1
if not exist "!kibroot!\usr\libexec" set rescue_required=1
if not exist "!kibroot!\var" set rescue_required=1
if not exist "!kibroot!\root" set rescue_required=1
if not exist "!kibroot!\lib" set rescue_required=1
if not exist "!kibroot!\usr\include" set rescue_required=1

if %rescue_required%==1 (
    if not exist "!kibroot!\etc" mkdir "!kibroot!\etc"
    if not exist "!kibroot!\tmp" mkdir "!kibroot!\tmp"
    if not exist "!kibroot!\usr" (
        mkdir "!kibroot!\usr"
        mkdir "!kibroot!\usr\bin"
        mkdir "!kibroot!\usr\share"
        mkdir "!kibroot!\usr\lib"
        mkdir "!kibroot!\usr\local"
        mkdir "!kibroot!\usr\libexec"
        mkdir "!kibroot!\usr\include"
    )
    if not exist "!kibroot!\usr\bin" mkdir "!kibroot!\usr\bin"
    if not exist "!kibroot!\usr\share" mkdir "!kibroot!\usr\share"
    if not exist "!kibroot!\usr\lib" mkdir "!kibroot!\usr\lib"
    if not exist "!kibroot!\usr\include" mkdir "!kibroot!\usr\include"
    if not exist "!kibroot!\usr\local" mkdir "!kibroot!\usr\local"
    if not exist "!kibroot!\usr\libexec" mkdir "!kibroot!\usr\libexec"
    if not exist "!kibroot!\bin" mklink /d "!kibroot!\bin" "!kibroot!\usr\bin" >nul
    if errorlevel 1 (
        echo !COLOR_ERROR!Could not create symlinks. Please run as admin or enable developer mode in settings.!COLOR_RESET!
        pause >nul
        exit /b 1
    )
    if not exist "!kibroot!\home" mkdir "!kibroot!\home"
    if not exist "!kibroot!\home\!username!" mkdir "!kibroot!\home\!username!"
    if not exist "!kibroot!\var" mkdir "!kibroot!\var"
    if not exist "!kibroot!\root" mkdir "!kibroot!\root"
    if not exist "!kibroot!\lib" mklink /d "!kibroot!\lib" "!kibroot!\usr\lib" >nul
    if errorlevel 1 (
        echo !COLOR_ERROR!Could not create symlinks. Please run as admin or enable developer mode in settings.!COLOR_RESET!
        pause >nul
        exit /b 1
    )
)

<nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
echo.

::                                                                 |
<nul set /p "=Initializing ROOT environment variable...            "

rem Initialize ROOT variable
set "ROOT=0"
rem Initialize LOGGED_IN_AS_ROOT variable
set "LOGGED_IN_AS_ROOT=0"

<nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
echo.

::                                                                 |
<nul set /p "=Copying core files...                                "

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
    echo #  KIB in Batch        #
    echo #  environment. It is  #
    echo #  overwritten when    #
    echo #  you boot KIB in     #
    echo #  Batch.              #
    echo #                      #
    echo #  To add your own     #
    echo #  configurations,     #
    echo #  modify ~/.bashrc    #
    echo #  instead.            #
    echo #                      #
    echo ########################
    echo.
    echo ## Locale fixes ##
    echo.
    echo export LANG=C.UTF-8
    echo export LANGUAGE=C.UTF-8
    echo export LC_CTYPE=C.UTF-8
    echo export LC_NUMERIC=C.UTF-8
    echo export LC_TIME=C.UTF-8
    echo export LC_COLLATE=C.UTF-8
    echo export LC_MONETARY=C.UTF-8
    echo export LC_MESSAGES=C.UTF-8
    echo export LC_PAPER=C.UTF-8
    echo export LC_NAME=C.UTF-8
    echo export LC_ADDRESS=C.UTF-8
    echo export LC_TELEPHONE=C.UTF-8
    echo export LC_MEASUREMENT=C.UTF-8
    echo export LC_IDENTIFICATION=C.UTF-8
    echo export LC_ALL=C.UTF-8
    echo.
    echo ## Shell prompt ##
    echo.
    echo PS1='\[\e[32m\]$USER@\h\[\e[0m\]:\[\e[34m\]\w\e[0m\$ '
    echo.
    echo ## Changes to PATH ##
    echo.
    echo export PATH="$USERPROFILE/kib/usr/bin:$USERPROFILE/kib/usr/lib/file:$PATH"
    echo.
    echo ## Applet overrides ##
    echo.
    echo export BB_OVERRIDE_APPLETS="uname which whoami make file"
    echo.
    echo alias netcat="nc"
    echo.
    echo ## Aliases ##
    echo.
    echo alias ls='ls --color=auto'
    echo alias grep='grep --color=auto'
    echo alias ll='ls -lahF'
    echo alias la='ls -A'
    echo alias l='ls -lhF'
    echo alias apt='kib-pkg'
    echo alias apt-get='kib-pkg'
    echo.
    echo ## Functions ##
    echo.   
    echo sudo^(^) {
    echo     # Check if the first argument is --help
    echo     if [ "$1" == "--help" ]; then
    echo        echo "Usage: sudo <command> [args]"
    echo        echo "Note: This is not the real sudo, neither is it a port of the real sudo."
    echo        return
    echo     fi
    echo     export PREVROOTVAL="$ROOT"
    echo     export PREVUSERVAL="$USER"
    echo     export ROOT="1"
    echo     export USER="root"
    echo     eval "$@" # Run the arguments
    echo     export ROOT="$PREVROOTVAL"
    echo     export USER="$PREVUSERVAL"
    echo }
    echo.
    echo su^(^) {
    echo     # Check if the first argument is --help
    echo     if [ "$1" == "--help" ]; then
    echo        echo "Usage: su"
    echo        echo "Use this command to become the root user."
    echo        return
    echo     fi
    echo     export ROOT="1"
    echo     export USER="root"
    echo     export HOME="!kibroot!/root"
    echo     #PS1=$'\[\e[34m\]┌──^(\[\e[31m\]root㉿\h\[\e[34m\]^)-[\[\e[0m\]\w\[\e[34m\]]\n\[\e[34m\]└─\[\e[31m\]# \[\e[0m\]'
    echo }
    echo.
    echo unsu^(^) {
    echo     # Check if the first argument is --help
    echo     if [ "$1" == "--help" ]; then
    echo        echo "Usage: unsu"
    echo        echo "Use this command to become the regular user."
    echo        return
    echo     fi
    echo     if [ "$ROOT" == "0" ]; then
    echo        echo "Unsu cannot be run as the regular user"
    echo        return 1
    echo     fi
    echo.
    echo     if [ "$LOGGED_IN_AS_ROOT" == "1" ]; then
    echo         echo "Unsu cannot be ran as you were never the regular user"
    echo         return 1
    echo     fi
    echo.
    echo     export ROOT="0"
    echo     export USER="$USERNAME"
    echo     export HOME="!kibroot!/home/$USERNAME"
    echo     #PS1=$'\[\e[32m\]┌──^(\[\e[34m\]\u㉿\h\[\e[32m\]^)-[\[\e[0m\]\w\[\e[32m\]]\n\[\e[32m\]└─\[\e[34m\]$ \[\e[0m\]'
    echo }
    echo.
    echo exit^(^) {
    echo     if [ "$LOGGED_IN_AS_ROOT" == "1" ]; then
    echo         exit $1
    echo     fi
    echo.
    echo     if [ "$ROOT" == "1" ]; then
    echo        export ROOT="0"
    echo        export USER="$USERNAME"
    echo        export HOME="!kibroot!/home/$USERNAME"
    echo        #PS1=$'\[\e[32m\]┌──^(\[\e[34m\]\u㉿\h\[\e[32m\]^)-[\[\e[0m\]\w\[\e[32m\]]\n\[\e[32m\]└─\[\e[34m\]$ \[\e[0m\]'
    echo        return $1
    echo     fi
    echo.
    echo     command exit $1 # Changed to command exit to fix stack overflow error
    echo }
    echo.
    echo ## Change to ~ ##
    echo.
    echo cd ~
    echo.
    echo ## Exit if not interactive ##
    echo.
    echo case $- in
    echo     *i*^) ;;
    echo     *^)   return ;;
    echo esac
    echo.
    echo ## Load ~/.bashrc ##
    echo.
    echo source ~/.bashrc
) > "!kibroot!\etc\.kibenv" 2>>"%APPDATA%\kib_in_batch\errors.log"

(
    echo NAME="KIB in Batch"
    echo VERSION="11.0.0-untagged"
    echo ID=kibbatch
    echo ID_LIKE=linux
    echo VERSION_ID="11.0.0-untagged"
    echo PRETTY_NAME="KIB in Batch 11.0.0-untagged"
    echo ANSI_COLOR="0;36"
    echo HOME_URL="https://kib-in-batch.github.io"
    echo SUPPORT_URL="https://github.com/KIB-in-Batch/kib-in-batch/discussions"
    echo BUG_REPORT_URL="https://github.com/KIB-in-Batch/kib-in-batch/issues"
) > "!kibroot!\etc\os-release" 2>>"%APPDATA%\kib_in_batch\errors.log"

xcopy "%~dp0etc\*" "!kibroot!\etc\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
xcopy "%~dp0lib\*" "!kibroot!\usr\lib\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
xcopy "%~dp0share\*" "!kibroot!\usr\share\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
xcopy "%~dp0libexec\*" "!kibroot!\usr\libexec\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
xcopy "%~dp0bin\*" "!kibroot!\usr\bin\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
xcopy "%~dp0include\*" "!kibroot!\usr\include\" /s /y >nul 2>>"%APPDATA%\kib_in_batch\errors.log"

copy /b /y "%~dp0..\kibposix\kibposix.dll" "!kibroot!\usr\bin\kibposix.dll" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
copy /b /y "%~dp0..\kibposix\libkibposix.dll.a" "!kibroot!\usr\lib\libkibposix.dll.a" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"

if !errorlevel! neq 0 (
    <nul set /p "=[ !COLOR_ERROR!FAILED!COLOR_RESET! ]"
    echo.
    echo Note: It is very likely that the script did not fail to copy files.
) else (
    <nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
    echo.
)

rem Check if VERSION.txt exists and delete it if it does
if exist "%APPDATA%\kib_in_batch\VERSION.txt" (
    del "%APPDATA%\kib_in_batch\VERSION.txt"
)
rem Create VERSION.txt
echo 11.0.0-untagged>"%APPDATA%\kib_in_batch\VERSION.txt"

::                                                                 |
<nul set /p "=Starting Nmap service...                             "

where nmap >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
if !errorlevel! neq 0 (
    <nul set /p "=[ !COLOR_ERROR!FAILED!COLOR_RESET! ]"
    echo.
) else (
    <nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
    echo.
)

::                                                                 |
<nul set /p "=Starting Neovim service...                           "

where nvim >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
if !errorlevel! neq 0 (
    <nul set /p "=[ !COLOR_ERROR!FAILED!COLOR_RESET! ]"
    echo.
) else (
    <nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
    echo.
)

::                                                                 |
<nul set /p "=Starting Bash service...                             "

if not exist "!kibroot!\usr\bin\busybox.exe" (
    curl -L -o "!kibroot!\usr\bin\busybox.exe" "https://github.com/KIB-in-Batch/busybox-w32/releases/latest/download/busybox64.exe" -s

    if errorlevel 1 (
        <nul set /p "=[ !COLOR_ERROR!FAILED!COLOR_RESET! ]"
        pause >nul
        exit 1
    )
)

<nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
echo.

set "busybox_path=!kibroot!\usr\bin\busybox.exe"

::                                                                 |
<nul set /p "=Setting up /proc...                                  "

if not exist "!kibroot!\proc" (
    mkdir "!kibroot!/proc"
)

del /q /f "!kibroot!/proc/cpuinfo" >nul 2>&1
del /q /f "!kibroot!/proc/cmdline" >nul 2>&1
del /q /f "!kibroot!/proc/uptime" >nul 2>&1
del /q /f "!kibroot!/proc/version" >nul 2>&1

rem Set up cpuinfo

set "NUMBER_OF_PROCESSORS_FOR_LOOP=%NUMBER_OF_PROCESSORS%"

set /a NUMBER_OF_PROCESSORS_FOR_LOOP-=1


set "CPU_CACHE=%APPDATA%\kib_in_batch\cpuvars.txt"

if exist "%CPU_CACHE%" (
    for /f "tokens=1,2 delims==" %%A in (%CPU_CACHE%) do set "%%A=%%B"
) else (
    for /f "delims=" %%a in ('powershell -Command "Get-CimInstance Win32_Processor | Select-Object -ExpandProperty Name"') do set "CPU_NAME=%%a"
    for /f "delims=" %%a in ('powershell -Command "Get-CimInstance Win32_Processor | Select-Object -ExpandProperty Manufacturer"') do set "CPU_VENDOR=%%a"
    for /f "delims=" %%a in ('powershell -Command "Get-CimInstance Win32_Processor | Select-Object -ExpandProperty NumberOfCores"') do set "CPU_CORES=%%a"
    for /f "delims=" %%a in ('powershell -Command "Get-CimInstance Win32_Processor | Select-Object -ExpandProperty MaxClockSpeed"') do set "CPU_MHZ=%%a"
    for /f %%a in ('powershell -Command "(Get-CimInstance Win32_Processor).Stepping"') do set "CPU_STEPPING=%%a"

    if "!CPU_STEPPING!"=="" set "CPU_STEPPING=1"

    rem Save results to cache using delayed expansion
    >"!CPU_CACHE!" (
        echo CPU_NAME=!CPU_NAME!
        echo CPU_VENDOR=!CPU_VENDOR!
        echo CPU_CORES=!CPU_CORES!
        echo CPU_MHZ=!CPU_MHZ!
        echo CPU_STEPPING=!CPU_STEPPING!
    )
)

if "%CPU_STEPPING%"=="" (
    set "CPU_STEPPING=1"
)

del /q /f "!kibroot!\proc\cpuinfo" >nul 2>&1 
for /l %%i in (0,1,%NUMBER_OF_PROCESSORS_FOR_LOOP%) do (
    set "HYPERTHREADS_PER_CORE="
    set /a HYPERTHREADS_PER_CORE = NUMBER_OF_PROCESSORS / CPU_CORES
    set /a CORE_ID = %%i / HYPERTHREADS_PER_CORE
    rem Write the file
    (
        echo processor       : %%i
        echo vendor_id       : !CPU_VENDOR!
        echo cpu family      : !PROCESSOR_LEVEL!
        echo model           : 141
        echo model name      : !CPU_NAME!
        echo stepping        : !CPU_STEPPING!
        echo microcode       : 0xffffffff
        echo cpu MHz         : !CPU_MHZ!
        echo cache size      : 12288 KB
        echo physical id     : 0
        echo siblings        : !NUMBER_OF_PROCESSORS!
        echo core id         : !CORE_ID!
        echo cpu cores       : !CPU_CORES!
        echo apicid          : %%i
        echo initial apicid  : %%i
        echo fpu             : yes
        echo fpu_exception   : yes
        echo cpuid level     : 27
        echo wp              : yes
        echo flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon rep_good nopl xtopology tsc_reliable nonstop_tsc cpuid tsc_known_freq pni pclmulqdq vmx ssse3 fma cx16 pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch ssbd ibrs ibpb stibp ibrs_enhanced tpr_shadow ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid avx512f avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves vnmi avx512vbmi umip avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid movdiri movdir64b fsrm avx512_vp2intersect md_clear flush_l1d arch_capabilities
        echo vmx flags       : vnmi invvpid ept_x_only ept_ad ept_1gb tsc_offset vtpr ept vpid unrestricted_guest ept_mode_based_exec tsc_scaling
        echo bugs            : spectre_v1 spectre_v2 spec_store_bypass swapgs retbleed eibrs_pbrsb gds bhi
        echo bogomips        : 5375.99
        echo clflush size    : 64
        echo cache_alignment : 64
        echo address sizes   : 39 bits physical, 48 bits virtual
        echo power management:
        echo.
    ) >> "!kibroot!\proc\cpuinfo"
)

<nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
echo.

::                                                                 |
<nul set /p "=Creating BusyBox symlinks...                         "

call :create_symlinks

<nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"
echo.

if exist "%USERPROFILE%\.kibdock" (
    ::                                                                 |
    <nul set /p "=Starting KIBDock service...                          "

    call "%USERPROFILE%\kib\usr\libexec\kibdock-init.bat"

    <nul set /p "=[ !COLOR_SUCCESS!OK!COLOR_RESET! ]"

    echo.
)

set "endtime=%time%"

rem Check if %~1 isn't "automated"

if not "%~1"=="automated" (
    choice /c yn /n /m "Do you wish to update BusyBox? [Y/N] "
    
    if errorlevel 2 (
        echo Skipping BusyBox update
        goto skip_bb_update
    )

    if errorlevel 1 (
        curl -L -o "!kibroot!\usr\bin\busybox.exe" "https://github.com/KIB-in-Batch/busybox-w32/releases/latest/download/busybox64.exe" -#
        set "busybox_path=!kibroot!\usr\bin\busybox.exe"
        goto skip_bb_update
    )
)

:skip_bb_update

rem Calculate elapsed time
call :time_diff "%starttime%" "%endtime%" elapsed >nul 2>&1

echo ------------------------------------------------

echo !COLOR_SUCCESS!System boot completed. Boot time: !elapsed!!COLOR_RESET!
if "%~1"=="automated" (
    del "!kibroot!\tmp\VERSION.txt" >nul 2>>"%APPDATA%\kib_in_batch\errors.log"
    set "USER=!username!"
    set "ROOT=0"
    echo Connecting to Bash service...
    echo.
    goto startup
) else (
    goto login
)

:login

echo.
echo KIB in Batch 11.0.0-untagged
echo Kernel !kernelversion! on an %PROCESSOR_ARCHITECTURE%
echo.
echo Users on this system: !username!, root
echo.
echo !COLOR_WARNING!If you set gnu-bash-wrapper as default shell,
echo logging in directly as root or using su and unsu will cause issues.!COLOR_RESET!
echo.
set /p loginkibusername=%COMPUTERNAME% login: 
if "!loginkibusername!"=="!username!" (
    rem Correct
    set "USER=!username!"
    set "ROOT=0"
    set "LOGGED_IN_AS_ROOT=0"
    echo !COLOR_SUCCESS!User found!COLOR_RESET!
    echo Connecting to Bash service...
) else if "!loginkibusername!"=="root" (
    set "ROOT=1"
    set "USER=root"
    set "LOGGED_IN_AS_ROOT=1"
    echo !COLOR_SUCCESS!User found!COLOR_RESET!
    echo Connecting to Bash service...
) else (
    rem Incorrect
    echo !COLOR_ERROR!User not found!COLOR_RESET!
    echo Press any key to try again...
    pause >nul
    goto login
)

echo.
goto startup

:startup
rem Navigate to home directory
cd /d "%USERPROFILE%\kib\home\!username!"
if %errorlevel% neq 0 (
    echo !COLOR_ERROR!Fatal error, unable to navigate to home directory.!COLOR_RESET!
    pause >nul
    exit /b 69
)
set "kibenv=!kibroot!\etc\.kibenv"
set "home_dir=!cd!"

:shell

if not exist "!kibroot!\tmp" (
    mkdir "!kibroot!\tmp"
)

if "!ROOT!"=="0" (
    set "HOME=!kibroot!\home\!username!"
) else (
    set "HOME=!kibroot!\root"
)

if not exist "!HOME!\.bashrc" (
    echo # Add commands to run on startup here>"!HOME!\.bashrc"
)

set "ENV=C:/Users/!username!/kib/etc/.kibenv"

set "CPPFLAGS=-I!kibroot!/usr/include"
set "CFLAGS=-O2 -Wall !CPPFLAGS! !kibroot!/usr/lib/libkibposix.dll.a"
set "CXXFLAGS=-O2 -Wall !CPPFLAGS! !kibroot!/usr/lib/libkibposix.dll.a"
set "LDFLAGS=-L!kibroot!/usr/lib"
set "BUILD=x86_64-pc-cygwin"
set "HOST=x86_64-pc-cygwin"
set "CC=clang"
set "CXX=clang++"

if not exist "!HOME!\.hushlogin" (
    echo For a guide on how to use KIB in Batch, run 'ls !kibroot!/usr/share/guide' and
    echo open the text file that you think will help you.
    echo.
    echo Example:
    echo $ notepad !kibroot!/usr/share/guide/hacking.txt
    echo.
    echo You can just copy and paste that command and adjust the file name.
    echo.
    echo For the best experience, run the following commands:
    echo $ sudo kib-pkg update
    echo $ sudo kib-pkg install make # Build system
    echo $ sudo kib-pkg install file # Classic UNIX utility
    echo $ sudo kib-pkg install neofetch # Thorough system information tool written in Bash 3.2+
    echo $ notepad ~/.bashrc # Customize your shell
    echo.
    echo To disable this message, create a file called .hushlogin in your home directory.
    echo.
)

if not exist "!kibroot!\etc\shell.bat" (
    echo @echo off >"!kibroot!\etc\shell.bat"
    echo setlocal enabledelayedexpansion >>"!kibroot!\etc\shell.bat"
    echo "!busybox_path!" bash -l >> "!kibroot!\etc\shell.bat"
    call "!kibroot!\etc\shell.bat" 
) else (
    call "!kibroot!\etc\shell.bat"
)

goto :eof

:create_symlinks

rem This subroutine creates symlinks to BusyBox

if not defined busybox_path (
    echo Undefined variable busybox_path
    exit /b 1
)

rem Loop for each BusyBox applet

for /f "tokens=*" %%a in ('!busybox_path! --list ^| findstr /i /v "busybox" ^| findstr /i /v "make"') do (
    set "applet=%%a"
    set "applet_path=%USERPROFILE%\kib\usr\bin\!applet!"
    if not exist "!applet_path!.bat" (
        mklink "!applet_path!.exe" "!busybox_path!" >nul 2>&1
        mklink "!applet_path!" "!busybox_path!" >nul 2>&1
    )
)

goto :eof

rem Function to calculate time difference between %1=start and %2=end in HH:MM:SS.xx format, output in variable %3
:time_diff
setlocal
set "start=%~1"
set "end=%~2"

rem Parse start time
for /f "tokens=1-4 delims=:.," %%a in ("%start%") do (
    set /a "sh=1%%a - 100"
    set /a "sm=1%%b - 100"
    set /a "ss=1%%c - 100"
    set /a "sf=1%%d - 100"
)

rem Parse end time
for /f "tokens=1-4 delims=:.," %%a in ("%end%") do (
    set /a "eh=1%%a - 100"
    set /a "em=1%%b - 100"
    set /a "es=1%%c - 100"
    set /a "ef=1%%d - 100"
)

rem Convert start and end to centiseconds
set /a "start_cs=(((sh*60)+sm)*60+ss)*100+sf"
set /a "end_cs=(((eh*60)+em)*60+es)*100+ef"

rem Calculate difference (handle midnight wrap)
set /a "diff=end_cs - start_cs"
if %diff% lss 0 set /a "diff+=24*60*60*100"

rem Convert back to HH:MM:SS.cc
set /a "dh=diff/(60*60*100)"
set /a "dm=(diff/(60*100))%%60"
set /a "ds=(diff/100)%%60"
set /a "df=diff%%100"

endlocal & set "%~3=%dh%:%dm:~-2%:%ds:~-2%.%df:~-2%"
goto :eof
