@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem kali_in_batch.bat
rem    * Main script for the Kali in Batch project.
rem    * Handles installation, boot process, and passes variables to the pwsh scripts used in the software.
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

    where winget >nul 2>&1
    if !errorlevel! neq 0 (
        echo Winget is not installed.
        echo Redirecting to the winget download page...
        timeout /t 2 /nobreak >nul
        start https://github.com/microsoft/winget-cli
        exit /b
    )

    if not exist "%~dp0\bin\bash.exe" (
        echo Bash not found. Please get the latest version of Kali in Batch from https://github.com/Kali-in-Batch/kali-in-batch/releases/latest/download/kali_in_batch.zip.
        exit /b
    )

    set "bash_path=%~dp0\bin\bash.exe"

    rem The check above is so we can write some parts of the script in bash.
    
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
        mkdir "!kaliroot!\usr\bin"
        rem Copy contents of %~dp0\bin to !kaliroot!\usr\bin.
        copy /y "%~dp0\bin\*" "!kaliroot!\usr\bin"
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

    where pwsh >nul 2>&1
    if !errorlevel! neq 0 (
        echo Installing PowerShell from winget...
        winget install --id Microsoft.PowerShell -e --source winget
        pause >nul
        exit
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
    echo add-kalirc - Adds a .kalirc file to the home directory.
    echo clear - Clears the screen.
    echo add-kibprompt - Adds a .kibprompt file to the home directory.
    echo edit-kalirc - Edits the .kalirc file.
    echo edit-kibprompt - Edits the .kibprompt file.
    goto preinstall
) else if !command!==done (
    echo Finishing setup...
    cls
    goto boot
) else if !command!==wipe (
    goto wipe
) else if !command!==add-kalirc (
    echo Adding .kalirc file...
    echo echo "██   ██  █████  ██      ██     ██ ███    ██     ██████   █████  ████████  ██████ ██   ██" >> "!kaliroot!\home\!username!\.kalirc"
    echo echo "██  ██  ██   ██ ██      ██     ██ ████   ██     ██   ██ ██   ██    ██    ██      ██   ██" >> "!kaliroot!\home\!username!\.kalirc"
    echo echo "█████   ███████ ██      ██     ██ ██ ██  ██     ██████  ███████    ██    ██      ███████" >> "!kaliroot!\home\!username!\.kalirc"
    echo echo "██  ██  ██   ██ ██      ██     ██ ██  ██ ██     ██   ██ ██   ██    ██    ██      ██   ██" >> "!kaliroot!\home\!username!\.kalirc"
    echo echo "██   ██ ██   ██ ███████ ██     ██ ██   ████     ██████  ██   ██    ██     ██████ ██   ██" >> "!kaliroot!\home\!username!\.kalirc"
    echo echo "" >> "!kaliroot!\home\!username!\.kalirc"
    echo Done.
    goto preinstall
) else if !command!==clear (
    cls
    goto preinstall
) else if !command!==add-kibprompt (
    echo Adding .kibprompt file...
    echo Write-Host "$env:USERNAME@$env:COMPUTERNAME" -ForegroundColor $colorRed -NoNewLine >> "!kaliroot!\home\!username!\.kibprompt"
    echo Write-Host ":" -NoNewLine >> "!kaliroot!\home\!username!\.kibprompt"
    echo Write-Host "$kaliPathtwo" -ForegroundColor $colorBlue -NoNewLine  >> "!kaliroot!\home\!username!\.kibprompt"
    echo Write-Host "$ " -NoNewLine >> "!kaliroot!\home\!username!\.kibprompt"
    echo Done.
    goto preinstall
) else if !command!==edit-kalirc (
    rem Make sure the .kalirc file exists
    if exist "!kaliroot!\home\!username!\.kalirc" (
        rem Open the .kalirc file in Nvim or Notepad
        nvim --version >nul 2>&1
        if !errorlevel!==0 (
            nvim "!kaliroot!\home\!username!\.kalirc"
        ) else (
            notepad "!kaliroot!\home\!username!\.kalirc"
        )
        goto preinstall
    ) else (
        rem The .kalirc file doesn't exist!
        echo Please run the 'add-kalirc' command first.
        goto preinstall
    )
) else if !command!==edit-kibprompt (
    rem Make sure the .kibprompt file exists
    if exist "!kaliroot!\home\!username!\.kibprompt" (
        rem Open the .kibprompt file in Nvim or Notepad
        nvim --version >nul 2>&1
        if !errorlevel!==0 (
            nvim "!kaliroot!\home\!username!\.kibprompt"
        ) else (
            notepad "!kaliroot!\home\!username!\.kibprompt"
        )
        goto preinstall
    ) else (
        rem The .kibprompt file doesn't exist!
        echo Please run the 'add-kibprompt' command first.
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
rmdir /s /q "!kaliroot!\home\!username!"
rmdir /s /q "!kaliroot!\bin"
rmdir /s /q "!kaliroot!\tmp"
rmdir /s /q "!kaliroot!\home"
rmdir /s /q "!kaliroot!\usr"
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

rem Check if %APPDATA%\kali_in_batch\powershell exists and delete it if it does
if exist "%APPDATA%\kali_in_batch\powershell" (
    rmdir /s /q "%APPDATA%\kali_in_batch\powershell"
)
rem So if the user runs git pull on the local repository to get updates, they can get the latest version of the pwsh scripts.
mkdir "%APPDATA%\kali_in_batch\powershell"
cd /d "%~dp0" & rem Needed incase the user is using a Windows Terminal profile or something that changes the current directory
rem Copy .\powershell\* to %APPDATA%\kali_in_batch\powershell
xcopy .\powershell\* "%APPDATA%\kali_in_batch\powershell" /s /y >nul

rem Check if VERSION.txt exists and delete it if it does
if exist "%APPDATA%\kali_in_batch\VERSION.txt" (
    del "%APPDATA%\kali_in_batch\VERSION.txt"
)
rem Create VERSION.txt
echo 4.0.3>"%APPDATA%\kali_in_batch\VERSION.txt"

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
    echo !COLOR_ERROR!Error: Bash not found. Please try again.!COLOR_RESET!
    pause >nul
    exit
)

set "bash_path=!kaliroot!\usr\bin\bash.exe"

where pwsh >nul 2>&1
if !errorlevel! neq 0 (
    echo !COLOR_ERROR!Error: PowerShell is not installed. Please try again.!COLOR_RESET!
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
rem DEV BRANCH FIX: Delete VERSION.txt in tmp folder
del "!kaliroot!\tmp\VERSION.txt"
echo.
cls
goto startup

:startup
rem Navigate to home directory
cd /d "!kaliroot!\home\!username!"
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
    set bash_current_dir=!bash_current_dir:C:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:D:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:E:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:F:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:G:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:H:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:I:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:J:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:K:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:L:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:M:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:N:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:O:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:P:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:Q:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:R:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:S:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:T:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:U:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:V:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:W:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:X:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:Y:=! >nul 2>&1
    set bash_current_dir=!bash_current_dir:Z:=! >nul 2>&1
    "!bash_path!" -c "cd !bash_current_dir!; source .kalirc" 2>&1
    goto shell
) else (
    echo No .kalirc file found.
    goto shell
)

:shell
set current_dir=!cd!
if !current_dir!==!home_dir! (
    set current_dir=~
) else (
    set current_dir=!cd!
)

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

goto new_shell_prompt

:new_shell_prompt

rem Check if PS 7+ is installed
rem PS 7+ uses pwsh.exe instead of pwsh.exe
where pwsh.exe >nul 2>&1
if !errorlevel!==0 (
    rem It is installed!
) else (
    rem It is not installed!
    echo !COLOR_ERROR!pwsh is not installed.!COLOR_RESET!
    echo !COLOR_INFO!Installing pwsh...!COLOR_RESET!
    winget install --id Microsoft.PowerShell -e --source winget
    echo Press any key to exit...
    pause >nul
    exit /b
)

pwsh.exe -noprofile -executionpolicy bypass -file "%APPDATA%\kali_in_batch\powershell\shell_prompt.ps1" -bashexepath "!bash_path!" -kaliroot "!kaliroot!" -utils_path "%~dp0bin"