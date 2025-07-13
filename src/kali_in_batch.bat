@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem kali_in_batch.bat
rem    * Main script for the Kali in Batch project.
rem    * Handles installation, boot process and sets up the bash environment.
rem    * Licensed under the Apache-2.0.

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

    if not exist "%~dp0bin\bash.exe" (
        echo Bash not found. Did you forget to run setup.bat?
        exit /b
    )

    set "bash_path=%~dp0bin\bash.exe"
    
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
        set /p "driveletter=Enter the drive letter to assign to the root filesystem (e.g. Z:) >> "
        echo Drive letter: !driveletter!
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
        mkdir "!kaliroot!\bin"
        mkdir "!kaliroot!\tmp"
        mkdir "!kaliroot!\usr"
        mkdir "!kaliroot!\etc"
        mkdir "!kaliroot!\usr\bin"
        rem Copy contents of %~dp0bin to !kaliroot!\usr\bin.
        copy /y "%~dp0bin\*" "!kaliroot!\usr\bin"
        set "bash_path=!kaliroot!\usr\bin\bash.exe"
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
    mkdir "%APPDATA%\kali_in_batch" >nul 2>&1
    @echo on
    echo !kaliroot!>"%APPDATA%\kali_in_batch\kaliroot.txt"
    @echo off
    rem Set install part to the txt file created in installer
    set /p kaliroot=<"%APPDATA%\kali_in_batch\kaliroot.txt"
    rem Enter the preinstall shell
    echo Welcome to the preinstall shell. Please type 'help' for the commands you'll need to finish setup. Type 'done' to boot into Kali in Batch.
    goto preinstall
)
rem Set install part to the txt file created in installer
set /p kaliroot=<"%APPDATA%\kali_in_batch\kaliroot.txt"
cls
goto boot

:preinstall
set /p "command=!COLOR_PROMPT!!COLOR_UNDERLINE!kali-in-batch-preinstall!COLOR_RESET! >> "
if !command!==help (
    echo Commands:
    echo help - Displays this message.
    echo done - Finishes setup and exits the preinstall shell.
    echo wipe - Wipes the Kali in Batch root filesystem.
    echo add-kibenv - Adds a .kibenv file to the file system.
    echo add-bashrc - Adds a .bashrc file to the home directory.
    echo edit-bashrc - Edits the .bashrc file.
    echo clear - Clears the screen.
    goto preinstall
) else if !command!==done (
    echo Finishing setup...
    if not exist "!kaliroot!\etc\.kibenv" (
        echo Please run add-kibenv before finishing setup
        goto preinstall
    )
    cls
    goto boot
) else if !command!==wipe (
    goto wipe
) else if !command!==add-kibenv (
    echo Adding .kibenv file...

    copy "%~dp0kibenv" "!kaliroot!\etc\.kibenv" /y >nul

    echo Done.
    goto preinstall
) else if !command!==add-bashrc (
    echo Adding .bashrc file...

    echo # Add commands to run on startup here>"!kaliroot!\home\!username!\.bashrc"

    echo Done.
    goto preinstall
) else if !command!==clear (
    cls
    goto preinstall
) else if !command!==edit-bashrc (
    rem Make sure the .bashrc file exists
    if exist "!kaliroot!\home\!username!\.bashrc" (
        rem Open the .bashrc file in Nvim or Notepad
        nvim --version >nul 2>&1
        if !errorlevel!==0 (
            nvim "!kaliroot!\home\!username!\.bashrc"
        ) else (
            notepad "!kaliroot!\home\!username!\.bashrc"
        )
        goto preinstall
    ) else (
        rem The .bashrc file doesn't exist!
        echo Please run the 'add-bashrc' command first.
        goto preinstall
    )
) else (
    if "!command!"=="" (
        rem Silently ignore empty commands
        goto preinstall
    )
    echo Invalid command.
    goto preinstall
)

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

rem Check if the !kaliroot! virtual drive letter is still assigned
if exist !kaliroot! (
    rem Nothing to do
) else (
    rem Fix for Kali in Batch not booting after a Windows reboot due to it deleting the virtual drive
    subst !kaliroot! "C:\Users\!username!\kali" >nul 2>&1
)

rem Copy %~dp0bin\* to !kaliroot!\usr\bin
xcopy "%~dp0bin\*" "!kaliroot!\usr\bin\" /s /y >nul

rem Copy kibenv
copy /y "%~dp0kibenv" "!kaliroot!\etc\.kibenv" >nul

rem Check if VERSION.txt exists and delete it if it does
if exist "%APPDATA%\kali_in_batch\VERSION.txt" (
    del "%APPDATA%\kali_in_batch\VERSION.txt"
)
rem Create VERSION.txt
echo 6.6>"%APPDATA%\kali_in_batch\VERSION.txt"

echo Starting services...
where nmap >nul 2>&1
if !errorlevel! neq 0 (
    echo !COLOR_ERROR!Error: Failed to start Nmap service: Nmap not found.!COLOR_RESET!
    echo Please install Nmap from https://nmap.org/download.html
    pause
    exit
)
where nvim >nul 2>&1
if !errorlevel! neq 0 (
    echo !COLOR_ERROR!Error: Failed to start Neovim service: Neovim not found.!COLOR_RESET!
)

if not exist "!kaliroot!\usr\bin\bash.exe" (
    echo !COLOR_ERROR!Error: Failed to start Bash service: Bash not found.!COLOR_RESET!
    pause >nul
    exit
)

if not exist "!kaliroot!\usr\bin\busybox.exe" (
    echo !COLOR_ERROR!Error: Failed to start Busybox service: Busybox not found.!COLOR_RESET!
    pause >nul
    exit
)

set "bash_path=!kaliroot!\usr\bin\bash.exe"

where pwsh >nul 2>&1
if !errorlevel! neq 0 (
    echo !COLOR_ERROR!Error: Failed to start PowerShell service: PowerShell not found.!COLOR_RESET!
    pause >nul
    exit
)
echo Checking for updates...
curl -# https://raw.githubusercontent.com/Kali-in-Batch/kali-in-batch/refs/heads/master/VERSION.txt >"!kaliroot!\tmp\VERSION.txt"
rem Check if the version is the same
set /p remote_version=<"!kaliroot!\tmp\VERSION.txt"
set /p local_version=<"%APPDATA%\kali_in_batch\VERSION.txt"
if !remote_version! neq !local_version! (
    rem Outdated Kali in Batch installation
    echo !COLOR_WARNING!New version available!!COLOR_RESET!
    echo !COLOR_WARNING!Remote version: !remote_version!!COLOR_RESET!
    echo !COLOR_WARNING!Local version: !local_version!!COLOR_RESET!
) else (
    echo !COLOR_SUCCESS!You are running the latest version.!COLOR_RESET!
    echo !COLOR_SUCCESS!Remote version: !remote_version!!COLOR_RESET!
    echo !COLOR_SUCCESS!Local version: !local_version!!COLOR_RESET!
)
timeout /t 1 >nul
del "!kaliroot!\tmp\VERSION.txt"
echo.
cls
goto startup

:startup
rem Navigate to home directory
cd /d "C:\Users\!username!\kali\home\!username!"
if %errorlevel% neq 0 (
    echo Fatal error, please reinstall Kali in Batch
    pause >nul
    exit
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

!bash_path! --rcfile "!kibenv!"
