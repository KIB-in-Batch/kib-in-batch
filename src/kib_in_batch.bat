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

if "%~1"=="automated" (
    echo Argument 1 is "automated". 'KIB in Batch' will boot without any interactive prompts.
    echo.
)

copy /y /b "%~dp0internal\colors.bat" "%USERPROFILE%\colors.bat" >nul 2>&1

call "%USERPROFILE%\colors.bat"

rem ----------------------------- Constants --------------------------------
set "ERRLOG=%APPDATA%\kib_in_batch\errors.log"
set "KIB_HOME_DIR=%USERPROFILE%\kib"
set "BINDIR=%~dp0bin"
set "ETCDIR=%~dp0etc"
set "LIBDIR=%~dp0lib"
set "SHAREDIR=%~dp0share"
set "LIBEXECDIR=%~dp0libexec"
set "KIBPOSIX_DLL=%~dp0..\kibposix\kibposix.dll"
set "KIBPOSIX_LIB=%~dp0..\kibposix\libkibposix.dll.a"
set "BUSYBOX_URL=https://github.com/KIB-in-Batch/busybox-w32/releases/latest/download/busybox64.exe"
rem ------------------------- Helper subroutines -----------------------------
goto start_code
:fatal
rem Usage: call :fatal "message" [exitcode]
set "_msg=%~1"
set "_code=%~2"
if "%_code%"=="" set "_code=1"

echo.
echo %COLOR_ERROR%CRITICAL: %_msg%%COLOR_RESET%
if exist "%ERRLOG%" ( echo See %ERRLOG% for details. )
pause >nul
exit %_code%

:info
rem Usage: call :info "message"
echo %COLOR_INFO%%~1%COLOR_RESET%
goto :eof

:require_file
rem Usage: call :require_file "path" "Error message"
if not exist "%~1" (
    call :fatal "%~2"
)
goto :eof

:require_cmd
rem Usage: call :require_cmd command "friendly name"
where %~1 >nul 2>&1
if errorlevel 1 (
    echo %COLOR_WARNING%Warning: %~2 not found.%COLOR_RESET%
    exit /b 1
)
goto :eof

:create_dir_tree
rem Usage: call :create_dir_tree target_root
set "_root=%~1"
if not exist "%_root%" (
    mkdir "%_root%" >nul 2>>"%ERRLOG%"
)
if not exist "%_root%\usr\bin" mkdir "%_root%\usr\bin" >nul 2>>"%ERRLOG%"
if not exist "%_root%\usr\lib" mkdir "%_root%\usr\lib" >nul 2>>"%ERRLOG%"
if not exist "%_root%\usr\share" mkdir "%_root%\usr\share" >nul 2>>"%ERRLOG%"
if not exist "%_root%\usr\local" mkdir "%_root%\usr\local" >nul 2>>"%ERRLOG%"
if not exist "%_root%\usr\libexec" mkdir "%_root%\usr\libexec" >nul 2>>"%ERRLOG%"
if not exist "%_root%\usr\include" mkdir "%_root%\usr\include" >nul 2>>"%ERRLOG%"
if not exist "%_root%\bin" mklink /d "%_root%\bin" "%_root%\usr\bin" >nul 2>>"%ERRLOG%"
if errorlevel 1 (
    echo %COLOR_ERROR%Could not create symlinks. Please run as admin or enable developer mode in settings.%COLOR_RESET%
    exit /b 1
)
if not exist "%_root%\lib" mklink /d "%_root%\lib" "%_root%\usr\lib" >nul 2>>"%ERRLOG%"
if errorlevel 1 (
    echo %COLOR_ERROR%Could not create symlinks. Please run as admin or enable developer mode in settings.%COLOR_RESET%
    exit /b 1
)
if not exist "%_root%\home" mkdir "%_root%\home" >nul 2>>"%ERRLOG%"
if not exist "%_root%\tmp" mkdir "%_root%\tmp" >nul 2>>"%ERRLOG%"
if not exist "%_root%\etc" mkdir "%_root%\etc" >nul 2>>"%ERRLOG%"
if not exist "%_root%\var" mkdir "%_root%\var" >nul 2>>"%ERRLOG%"
if not exist "%_root%\root" mkdir "%_root%\root" >nul 2>>"%ERRLOG%"
if not exist "%_root%\home\%USERNAME%" mkdir "%_root%\home\%USERNAME%" >nul 2>>"%ERRLOG%"
goto :eof

:copy_tree
rem Usage: call :copy_tree "src" "dst"
xcopy "%~1\*" "%~2\" /s /y >nul 2>>"%ERRLOG%"
goto :eof

:download_busybox
rem Usage: call :download_busybox "target_path"
set "_target=%~1"
curl -L -o "%_target%" "%BUSYBOX_URL%" -# >nul 2>>"%ERRLOG%"
if errorlevel 1 (
    echo %COLOR_ERROR%Failed to download BusyBox to %_target%.%COLOR_RESET%
)
set "busybox_path=%_target%"
goto :eof

:install_if_missing_winget
rem Usage: call :install_if_missing_winget "binaryname" "winget-id"
where %~1 >nul 2>>"%ERRLOG%"
if errorlevel 1 (
    where winget >nul 2>&1
    if errorlevel 1 (
        echo %COLOR_WARNING%Winget not available, cannot auto-install %~1.%COLOR_RESET%
    ) else (
        echo Installing %~1 from winget...
        winget install --id %~2 -e --source winget >nul 2>>"%ERRLOG%"
    )
) else (
    echo %~1 is already installed.
)
goto :eof

:start_code

rem ---------------------------- Start checks --------------------------------
if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    cls
    echo This app cannot run on your PC.
    echo Press any key to continue...
    pause >nul
    exit /b 1
)

call :require_file "%KIBPOSIX_DLL%" "POSIX DLL not found. Please compile it."
call :require_file "%KIBPOSIX_LIB%" "POSIX DLL import library not found. Please compile it."

set "WINE_DETECTED=0"
reg query "HKEY_CURRENT_USER\Software\Wine" >nul 2>&1 && set "WINE_DETECTED=1"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wine" >nul 2>&1 && set "WINE_DETECTED=1"
if defined WINEPREFIX set "WINE_DETECTED=1"
if defined WINEARCH set "WINE_DETECTED=1"
if "%WINE_DETECTED%"=="1" (
    echo.
    echo %COLOR_ERROR%ERROR: Wine environment detected!%COLOR_RESET%
    echo This script requires native Windows PowerShell.
    echo Please run this script on native Windows.
    exit /b 1
)

where powershell >nul 2>&1 || call :fatal "PowerShell not found."

if not exist "%BINDIR%" (
    call :fatal "This script is not meant to be used standalone."
)
if not exist "%SHAREDIR%" call :fatal "This script is not meant to be used standalone."
if not exist "%LIBDIR%" call :fatal "This script is not meant to be used standalone."

rem Set errorlog dir and ensure folder exists
if not exist "%APPDATA%\kib_in_batch" mkdir "%APPDATA%\kib_in_batch" >nul 2>&1
if not exist "%ERRLOG%" echo.>"%ERRLOG%"

where curl >nul 2>&1 || call :fatal "Curl is required but not found."

set "missing="
if not exist "%APPDATA%\kib_in_batch" set "missing=1"
if not exist "%KIB_HOME_DIR%" set "missing=1"

if defined missing (
    cls
    if "%~1"=="automated" (
        set "kibroot=Z:"
        echo Creating directories...
        call :create_dir_tree "%USERPROFILE%\kib"
        echo Setting up kibroot...
        subst "!kibroot!" "%USERPROFILE%\kib"
        echo !kibroot!>"%APPDATA%\kib_in_batch\kibroot.txt" 2>nul
    ) else (
        goto dumbshell
    )
)

rem Ensure kibroot loaded
if not defined kibroot (
    if exist "%APPDATA%\kib_in_batch\kibroot.txt" set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"
)

if exist "%~dp0kibenv" copy "%~dp0kibenv" "!kibroot!\etc\.kibenv" /y >nul 2>>"%ERRLOG%"

goto boot

:setup

echo Setup is starting...

color 17
cls

echo 'KIB in Batch' Setup
echo ====================

echo.
echo   Welcome to Setup.
echo.
echo   The Setup program installs 'KIB in Batch' on your computer.
echo.
echo     * To install now, press 1.
echo.
echo     * To quit Setup, press 2.
echo.

choice /c 12 /n /m ""

if errorlevel 2 goto __setup_end
if errorlevel 1 goto __setup_install

:__setup_install

cls

echo 'KIB in Batch' Setup
echo ====================

echo.
echo   Setup needs to know if you want to install Nmap and Neovim.
echo.
echo     * If you do, press y.
echo.
echo     * If you don't, press n.
echo.

choice /c yn /n /m ""

if errorlevel 2 goto __setup_kibroot

if errorlevel 1 (
    goto __setup_install_pkgs
)

:__setup_install_pkgs

cls

echo 'KIB in Batch' Setup
echo ====================

echo.

echo   Setup is installing Nmap and Neovim...
echo.

call :get_deps
color 17

goto __setup_kibroot

:__setup_kibroot

color 17

cls

echo 'KIB in Batch' Setup
echo ====================

echo.

echo   Setup is setting up the kibroot drive...
echo.

if not exist "%APPDATA%\kib_in_batch" (
    mkdir "%APPDATA%\kib_in_batch" >nul 2>&1
)

set /p "kibroot=Please enter the kibroot drive letter (e.g., Z:): "
if exist "!kibroot!" (
    echo Drive exists.
    echo Press any key to continue...
    pause >nul
    goto __setup_kibroot
)

if not exist "%USERPROFILE%\kib" (
    mkdir "%USERPROFILE%\kib" >nul 2>&1
)

subst "!kibroot!" "%USERPROFILE%\kib" >nul 2>&1
if errorlevel 1 (
    goto __setup_kibroot
)
echo !kibroot!>"%APPDATA%\kib_in_batch\kibroot.txt" 2>nul

goto __setup_dirs

:__setup_dirs

color 17

cls

echo 'KIB in Batch' Setup
echo ====================

echo.

echo   Setup is setting up the directories inside !kibroot!...
echo.

call :create_dir_tree "%USERPROFILE%\kib"

color 17

:__setup_end

color 17

cls

echo 'KIB in Batch' Setup
echo ====================

echo.

echo   Setup has now installed 'KIB in Batch' on your computer.

echo.

echo   Press any key to continue booting...

pause >nul

color 07

goto boot

:dumbshell

echo Type help for built-in commands.
echo Run "setup" to start the installer.

goto dumbshell_loop

:dumbshell_loop

set "command="

set "PROMPT=%COLOR_RED%%USERNAME%%COLOR_RESET%@%COMPUTERNAME%#"

set /p "command=!PROMPT! "

if "!command!"=="help" (
    call :info "Built-in commands:"
    echo ------------------
    echo echo [text]              Print text to the screen
    echo exit                     Exit the shell
    echo setup                    Install 'KIB in Batch'
    echo clear                    Clear the screen
    echo whoami                   Get your username
    echo hostname                 Get your hostname
) else if "!command!"=="clear" (
    cls
) else if "!command!"=="setup" (
    goto setup
) else if /i "!command:~0,5!"=="echo " (
    echo !command:~5!
) else if /i "!command!"=="exit" (
    exit /b
) else if "!command!"=="whoami" (
    echo %USERNAME%
) else if "!command!"=="hostname" (
    echo %COMPUTERNAME%
) else (
    if not "!command!"=="" (
        echo %COLOR_ERROR%!command!: command not found%COLOR_RESET%
    )
)

goto dumbshell_loop

:wipe
call :info "Wiping kib rootfs..."
set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt" 2>nul
if defined kibroot subst !kibroot! /d >nul 2>&1
rmdir /s /q "%KIB_HOME_DIR%" >nul 2>>"%ERRLOG%"
rmdir /s /q "%APPDATA%\kib_in_batch" >nul 2>&1
call :info "Done, press any key to exit..."
pause >nul
cls
exit /b 0

:get_deps
call :install_if_missing_winget nmap Insecure.Nmap
call :install_if_missing_winget nvim Neovim.Neovim
goto :eof

:boot

set /a lines=0
for /f "usebackq delims=" %%L in ("%ERRLOG%") do set /a lines+=1
if %lines% geq 100 echo.>"%ERRLOG%"

if not exist "%KIB_HOME_DIR%" (
    echo Your installation is broken
    goto live_shell
)
if not exist "%APPDATA%\kib_in_batch" (
    echo Your installation is broken
    goto live_shell
)
for /f "delims=" %%i in ('powershell -command "[System.Environment]::OSVersion.Version.ToString()"') do set kernelversion=%%i

echo.
echo Welcome to KIB in Batch 11.0.0-untagged ^(%PROCESSOR_ARCHITECTURE%^)
echo Booting system...
echo ------------------------------------------------

if not exist "%APPDATA%\kib_in_batch\kibroot.txt" goto boot
set "starttime=%time%"

rem Validate kibroot looks like a drive letter
if not "!kibroot:~1,1!"==":" (
    del "%APPDATA%\kib_in_batch\kibroot.txt" >nul 2>&1
    goto boot
)

if not exist !kibroot! (
    subst !kibroot! "%KIB_HOME_DIR%" >nul 2>>"%ERRLOG%"
    if errorlevel 1 (
        del "%APPDATA%\kib_in_batch\kibroot.txt" >nul 2>&1
        goto boot
    )
)

::                                                                 |
<nul set /p "=Checking if rescue is required...                    "

set "rescue_required=0"
for %%d in (etc tmp usr bin "usr\bin" "usr\local" "usr\share" "usr\lib" home "home\%USERNAME%" "usr\libexec" var root lib "usr\include") do (
    if not exist "!kibroot!\%%~d" set "rescue_required=1"
)

if %rescue_required%==1 (
    call :create_dir_tree "!kibroot!"
)

<nul set /p "=[ %COLOR_SUCCESS%OK%COLOR_RESET% ]"
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
    echo PS1='${COLOR_GREEN}$USER@\h${COLOR_RESET}:${COLOR_BLUE}\w${COLOR_RESET}\$ '
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
    echo if [ "$HASCOLORS" == "1" ]; then
    echo     alias ls='ls --color=auto'
    echo     alias grep='grep --color=auto'
    echo else
    echo     alias ls='ls --color=never'
    echo     alias grep='grep --color=never'
    echo fi
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
) > "!kibroot!\etc\.kibenv" 2>>"%ERRLOG%"

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
) > "!kibroot!\etc\os-release" 2>>"%ERRLOG%"

call :copy_tree "%~dp0lib" "!kibroot!\usr\lib"
call :copy_tree "%~dp0share" "!kibroot!\usr\share"
call :copy_tree "%~dp0libexec" "!kibroot!\usr\libexec"
call :copy_tree "%~dp0bin" "!kibroot!\usr\bin"
call :copy_tree "%~dp0include" "!kibroot!\usr\include"

copy /b /y "%KIBPOSIX_DLL%" "!kibroot!\usr\bin\kibposix.dll" >nul 2>>"%ERRLOG%"
copy /b /y "%KIBPOSIX_LIB%" "!kibroot!\usr\lib\libkibposix.dll.a" >nul 2>>"%ERRLOG%"

if not exist "!kibroot!\home\!username!\.bashrc" (
    echo # Add commands to run on startup here>"!kibroot!\home\!username!\.bashrc"
)

if not exist "!kibroot!\root\.bashrc" (
    echo # Add commands to run on startup here>"!kibroot!\root\.bashrc"
)

if errorlevel 1 (
    <nul set /p "=[ %COLOR_ERROR%FAILED%COLOR_RESET% ]"
    echo.
    echo Note: It is very likely that the script did not fail to copy files.
) else (
    <nul set /p "=[ %COLOR_SUCCESS%OK%COLOR_RESET% ]"
    echo.
)

if exist "%APPDATA%\kib_in_batch\VERSION.txt" del "%APPDATA%\kib_in_batch\VERSION.txt"
echo 11.0.0-untagged>"%APPDATA%\kib_in_batch\VERSION.txt"

::                                                                 |
<nul set /p "=Starting Nmap service...                             "
where nmap >nul 2>>"%ERRLOG%"
if errorlevel 1 (
    <nul set /p "=[ %COLOR_ERROR%FAILED%COLOR_RESET% ]"
) else (
    <nul set /p "=[ %COLOR_SUCCESS%OK%COLOR_RESET% ]"
)
echo.

<nul set /p "=Starting Neovim service...                           "
where nvim >nul 2>>"%ERRLOG%"
if errorlevel 1 (
    <nul set /p "=[ %COLOR_ERROR%FAILED%COLOR_RESET% ]"
) else (
    <nul set /p "=[ %COLOR_SUCCESS%OK%COLOR_RESET% ]"
)
echo.

::                                                                 |
<nul set /p "=Setting up BusyBox...                                "

call :download_busybox "!kibroot!\usr\bin\busybox.exe"
set "busybox_path=!kibroot!\usr\bin\busybox.exe"
call :create_symlinks
<nul set /p "=[ %COLOR_SUCCESS%OK%COLOR_RESET% ]"
echo.

if not exist "%USERPROFILE%\.kibdock" (
    goto skip_kibdock
)

::                                                                 |
<nul set /p "=Starting KIBDock service...                          "
call "%USERPROFILE%\kib\usr\libexec\kibdock-init.bat"
<nul set /p "=[ %COLOR_SUCCESS%OK%COLOR_RESET% ]"
echo.

:skip_kibdock

set "endtime=%time%"
call :time_diff "%starttime%" "%endtime%" elapsed >nul 2>&1

echo ------------------------------------------------
echo %COLOR_SUCCESS%System boot completed. Boot time: !elapsed!%COLOR_RESET%
if "%~1"=="automated" (
    del "!kibroot!\tmp\VERSION.txt" >nul 2>>"%ERRLOG%"
    set "USER=%USERNAME%"
    set "HOME=!kibroot!\home\%USERNAME%"
    set "LOGGED_IN_AS_ROOT=1"
    set "ROOT=0"
    echo Connecting to Bash service...
    goto startup
) else (
    goto login
)

:login
echo.
echo KIB in Batch 11.0.0-untagged
echo Kernel %kernelversion% on an %PROCESSOR_ARCHITECTURE%
echo.
echo Users on this system: %USERNAME%, root
echo.
set /p "loginkibusername=%COMPUTERNAME% login: "
if "%loginkibusername%"=="%USERNAME%" (
    set "USER=%USERNAME%"
    set "ROOT=0"
    set "LOGGED_IN_AS_ROOT=0"
    set "HOME=!kibroot!\home\%USERNAME%"
    echo %COLOR_SUCCESS%User found%COLOR_RESET%
    echo Connecting to Bash service...
) else if "%loginkibusername%"=="root" (
    set "ROOT=1"
    set "USER=root"
    set "LOGGED_IN_AS_ROOT=1"
    set "HOME=!kibroot!\root"
    echo %COLOR_SUCCESS%User found%COLOR_RESET%
    echo Connecting to Bash service...
) else (
    echo %COLOR_ERROR%User not found%COLOR_RESET%
    echo Press any key to try again...
    pause >nul
    goto login
)

echo.
goto startup

:startup
set "kibenv=!kibroot!\etc\.kibenv"
rem env flags
set "ENV=C:/Users/%USERNAME%/kib/etc/.kibenv"
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

cd /d "!HOME!"

"!busybox_path!" bash -l

goto :eof

:create_symlinks

rem This subroutine creates symlinks in /bin

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
    )
)

for %%f in ("%USERPROFILE%\kib\usr\bin\*.exe") do (
    mklink "%USERPROFILE%\kib\usr\bin\%%~nf" "%%f" >nul 2>&1
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


:get_ini_value
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "$p=@{};$s='';foreach($l in Get-Content '%~1'){if($l -match '^\s*\[(.+)\]'){$s=$matches[1];$p[$s]=@{}}elseif($l -match '^\s*([^=]+)=(.*)$'){$p[$s][$matches[1].Trim()]=$matches[2].Trim()}};$p['%~2']['%~3']"`) do set "v=%%A"
set "%~4=%v%"
exit /b
