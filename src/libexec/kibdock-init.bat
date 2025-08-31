@echo off

setlocal enabledelayedexpansion

rem kibdock-init.bat
rem    * Container initialization program for the KIB in Batch project.
rem    * Initializes the kibdock service.
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

rem Do not use any of the scripts directly. Instead, use the kibdock program in the KIB in Batch shell.

if exist "%USERPROFILE%\.kibdock" goto skip_kibdock_creation

mkdir "%USERPROFILE%\.kibdock" >nul 2>&1

:skip_kibdock_creation

mkdir "%USERPROFILE%\.kibdock\containers" >nul 2>&1
mkdir "%USERPROFILE%\.kibdock\images" >nul 2>&1
mkdir "%USERPROFILE%\.kibdock\logs" >nul 2>&1
echo. > "%USERPROFILE%\.kibdock\state.txt" 2>nul

::::             IMAGES                ::::
  :: These are the images for KIBDock. ::

:: -- windows_minimal -- ::

rmdir /s /q "%USERPROFILE%\.kibdock\images\windows_minimal" >nul 2>&1

mkdir "%USERPROFILE%\.kibdock\images\windows_minimal" >nul 2>&1

(
    echo #!/bin/sh
    echo.
    echo # This is the install script for the KIB Windows Minimal image.
    echo.
    echo # DESCRIPTION: The Windows Minimal image is a Windows image.
    echo # Windows is a trademark of Microsoft Corporation.
    echo.
    echo # Check if CTNRNAME isn't set.
    echo if [ -z "$CTNRNAME" ]; then
    echo     echo "Error: CTNRNAME must be set."
    echo     exit 1
    echo fi
    echo.
    echo echo "WARNING: Windows Defender doesn't quite like Windows containers. It might quarantine BusyBox."
    echo.
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32"
    echo ln -sf "$SYSTEMROOT/System32/WindowsPowerShell" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/WindowsPowerShell"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files (x86)"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/ProgramData"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/Desktop"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/Documents"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/AppData/Local/Temp"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/AppData/Local/Microsoft"
    echo mkdir -p "$USERPROFILE/.kibdock/container/CTNRNAME/Users/$USERNAME/AppData/Roaming"
    echo ln -sf "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Documents and Settings"
    echo.
    echo # Core DLLs
    echo ln -sf "$SYSTEMROOT/System32/ntdll.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/ntdll.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/ntdll.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/ntdll.dll"
    echo ln -sf "$SYSTEMROOT/System32/kernel32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/kernel32.dll"
    echo ln -sf "$SYSTEMROOT/System32/kernelbase.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/kernelbase.dll"
    echo ln -sf "$SYSTEMROOT/System32/user32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/user32.dll"
    echo ln -sf "$SYSTEMROOT/System32/gdi32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/gdi32.dll"
    echo ln -sf "$SYSTEMROOT/System32/advapi32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/advapi32.dll"
    echo ln -sf "$SYSTEMROOT/System32/shell32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/shell32.dll"
    echo ln -sf "$SYSTEMROOT/System32/comdlg32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/comdlg32.dll"
    echo ln -sf "$SYSTEMROOT/System32/ole32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/ole32.dll"
    echo ln -sf "$SYSTEMROOT/System32/oleaut32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/oleaut32.dll"
    echo ln -sf "$SYSTEMROOT/System32/rpcrt4.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/rpcrt4.dll"
    echo ln -sf "$SYSTEMROOT/System32/shlwapi.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/shlwapi.dll"
    echo ln -sf "$SYSTEMROOT/System32/ws2_32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/ws2_32.dll"
    echo ln -sf "$SYSTEMROOT/System32/crypt32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/crypt32.dll"
    echo ln -sf "$SYSTEMROOT/System32/version.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/version.dll"
    echo ln -sf "$SYSTEMROOT/System32/msvcrt.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/msvcrt.dll"
    echo ln -sf "$SYSTEMROOT/System32/ucrtbase.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/ucrtbase.dll"
    echo.
    echo # Key executables
    echo ln -sf "$SYSTEMROOT/System32/cmd.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/cmd.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/cmd.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/cmd.exe"
    echo ln -sf "$SYSTEMROOT/regedit.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/regedit.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/regedit.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/regedit.exe"
    echo ln -sf "$SYSTEMROOT/System32/taskmgr.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/taskmgr.exe"
    echo ln -sf "$SYSTEMROOT/System32/reg.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/reg.exe"
    echo ln -sf "$SYSTEMROOT/System32/conhost.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/conhost.exe"
    echo ln -sf "$SYSTEMROOT/System32/notepad.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/notepad.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/notepad.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/notepad.exe"
    echo ln -sf "$SYSTEMROOT/explorer.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/explorer.exe"
    echo ln -sf "$SYSTEMROOT/System32/reg.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/reg.exe"
    echo ln -sf "$SYSTEMROOT/System32/tasklist.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/tasklist.exe"
    echo ln -sf "$SYSTEMROOT/System32/findstr.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/findstr.exe"
    echo ln -sf "$SYSTEMROOT/System32/winver.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/winver.exe"
    echo ln -sf "$SYSTEMROOT/System32/tree.com" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/tree.com"
    echo ln -sf "$SYSTEMROOT/System32/calc.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/calc.exe"
    echo ln -sf "$SYSTEMROOT/System32/whoami.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/whoami.exe"
    echo.
    echo # Now go back to syswow64
    echo ln -sf "$SYSTEMROOT/SysWOW64/shell32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/shell32.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/user32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/user32.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/gdi32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/gdi32.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/kernelbase.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/kernelbase.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/advapi32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/advapi32.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/comdlg32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/comdlg32.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/winver.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/winver.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/tree.com" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/tree.com"
    echo ln -sf "$SYSTEMROOT/SysWOW64/calc.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/calc.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/findstr.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/findstr.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/tasklist.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/tasklist.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/reg.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/reg.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/taskmgr.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/taskmgr.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/conhost.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/conhost.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/whoami.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/whoami.exe"
    echo.
    echo # More DLLs because Windows is a mess
    echo ln -sf "$SYSTEMROOT/System32/api-ms-win-core-console-l1-1-0.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/api-ms-win-core-console-l1-1-0.dll"
    echo ln -sf "$SYSTEMROOT/System32/api-ms-win-core-console-l1-2-0.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/api-ms-win-core-console-l1-2-0.dll"
    echo ln -sf "$SYSTEMROOT/System32/api-ms-win-core-console-l2-1-0.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/api-ms-win-core-console-l2-1-0.dll"
    echo ln -sf "$SYSTEMROOT/System32/comctl32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/comctl32.dll"
    echo ln -sf "$SYSTEMROOT/System32/commdlg.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/commdlg.dll"
    echo ln -sf "$SYSTEMROOT/System32/msvcp140.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/msvcp140.dll"
    echo ln -sf "$SYSTEMROOT/System32/vcruntime140.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/vcruntime140.dll"
    echo ln -sf "$SYSTEMROOT/System32/windowscodecs.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/windowscodecs.dll"
    echo ln -sf "$SYSTEMROOT/System32/uxtheme.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/uxtheme.dll"
    echo # Core .NET runtime
    echo ln -sf "$SYSTEMROOT/System32/mscoree.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/mscoree.dll"
    echo ln -sf "$SYSTEMROOT/Microsoft.NET" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/Microsoft.NET"
    echo ln -sf "$SYSTEMROOT/System32/MSVCR100.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/MSVCR100.dll"
    echo ln -sf "$SYSTEMROOT/System32/MSVCR110.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/MSVCR110.dll"
    echo ln -sf "$SYSTEMROOT/System32/MSVCR120.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/MSVCR120.dll"
    echo ln -sf "$SYSTEMROOT/System32/MSVCRT.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/MSVCRT.dll"
    echo ln -sf "$SYSTEMROOT/System32/MSVCR100_clr0400.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/MSVCR100_clr0400.dll"
    echo ln -sf "$SYSTEMROOT/System32/MSVCR120_clr0400.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/MSVCR120_clr0400.dll"
    echo.
    echo # Registry
    echo ln -sf "$SYSTEMROOT/System32/config" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/config"
    echo.
    echo # Language resources
    echo ln -sf "$SYSTEMROOT/System32/en-GB" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/en-GB"
    echo ln -sf "$SYSTEMROOT/SysWOW64/en-GB" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/en-GB"
    echo ln -sf "$SYSTEMROOT/en-GB" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/en-GB"
    echo.
    echo # Additional critical DLLs
    echo ln -sf "$SYSTEMROOT/System32/msi.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/msi.dll"
    echo ln -sf "$SYSTEMROOT/System32/winhttp.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/winhttp.dll"
    echo ln -sf "$SYSTEMROOT/System32/netapi32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/netapi32.dll"
    echo ln -sf "$SYSTEMROOT/System32/dbghelp.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/dbghelp.dll"
    echo ln -sf "$SYSTEMROOT/System32/wbemprox.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/wbemprox.dll"
    echo ln -sf "$SYSTEMROOT/System32/wbemcomn.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/wbemcomn.dll"
    echo ln -sf "$SYSTEMROOT/System32/wbemsvc.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/wbemsvc.dll"
    echo ln -sf "$SYSTEMROOT/System32/wmiutils.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/wmiutils.dll"
    echo ln -sf "$SYSTEMROOT/System32/winmm.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/winmm.dll"
    echo ln -sf "$SYSTEMROOT/System32/dnsapi.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/dnsapi.dll"
    echo ln -sf "$SYSTEMROOT/System32/iphlpapi.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/iphlpapi.dll"
    echo ln -sf "$SYSTEMROOT/System32/srvcli.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/srvcli.dll"
    echo ln -sf "$SYSTEMROOT/System32/netutils.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/netutils.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/msi.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/msi.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/netapi32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/netapi32.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/dbghelp.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/dbghelp.dll"
    echo ln -sf "$SYSTEMROOT/SysWOW64/winmm.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/winmm.dll"
    
    echo.
    echo # Additional utilities
    echo ln -sf "$SYSTEMROOT/System32/wmic.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/wmic.exe"
    echo ln -sf "$SYSTEMROOT/System32/msiexec.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/msiexec.exe"
    echo ln -sf "$SYSTEMROOT/System32/rundll32.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/rundll32.exe"
    echo ln -sf "$SYSTEMROOT/System32/regsvr32.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/regsvr32.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/msiexec.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/msiexec.exe"
    echo ln -sf "$SYSTEMROOT/System32/curl.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/curl.exe"
    echo ln -sf "$SYSTEMROOT/SysWOW64/where.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/where.exe"
    echo ln -sf "$SYSTEMROOT/System32/where.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/where.exe"
    echo.
    echo # Core Windows directories
    echo ln -sf "$SYSTEMROOT/Fonts" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/Fonts"
    echo ln -sf "$SYSTEMROOT/Resources" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/Resources"
    echo ln -sf "$SYSTEMROOT/AppPatch" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/AppPatch"
    echo ln -sf "$SYSTEMROOT/System32/drivers" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/drivers"
    echo ln -sf "$SYSTEMROOT/System32/spool" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/spool"
    echo ln -sf "$SYSTEMROOT/System32/wbem" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/wbem"
    echo ln -sf "$SYSTEMROOT/System32/WDI" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/WDI"
    echo ln -sf "$SYSTEMROOT/SysWOW64/wbem" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SysWOW64/wbem"
    
    echo.
    echo # Shell integration
    echo ln -sf "$SYSTEMROOT/System32/shell32.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/shell32.dll"
    echo ln -sf "$SYSTEMROOT/System32/shlwapi.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/shlwapi.dll"
    echo ln -sf "$SYSTEMROOT/explorer.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/explorer.exe"
    echo ln -sf "$SYSTEMROOT/System32/actxprxy.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/actxprxy.dll"
    echo ln -sf "$SYSTEMROOT/System32/comres.dll" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/System32/comres.dll"
    echo.
    echo # UWP directories
    echo ln -sf "$SYSTEMDRIVE/Program Files/WindowsApps" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files/WindowsApps"
    echo ln -sf "$SYSTEMROOT/SystemApps" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows/SystemApps"
    echo ln -sf "$USERPROFILE/AppData/Local/Microsoft/WindowsApps" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/AppData/Local/Microsoft/WindowsApps"
) > "%USERPROFILE%\.kibdock\images\windows_minimal\install.sh"

(
    echo #!/bin/sh
    echo.
    echo # This is the start script for the KIB Windows Minimal image.
    echo.
    echo # DESCRIPTION: The Windows Minimal image is a Windows image.
    echo # Windows is a trademark of Microsoft Corporation.
    echo.
    echo # Make sure SUBSTDRIVELETTER is set.
    echo.
    echo if [ -z "$SUBSTDRIVELETTER" ]; then
    echo     echo "Error: SUBSTDRIVELETTER must be set."
    echo     exit 1
    echo fi
    echo.
    echo # Set environment variables. These do the container isolation by making apps access directories of the container.
    echo.
    echo export SYSTEMDRIVE="$SUBSTDRIVELETTER"
    echo export SYSTEMROOT="$SUBSTDRIVELETTER\Windows"
    echo export USERPROFILE="$SUBSTDRIVELETTER\Users\%USERNAME%"
    echo export APPDATA="$SUBSTDRIVELETTER\Users\%USERNAME%\AppData\Roaming"
    echo export LOCALAPPDATA="$SUBSTDRIVELETTER\Users\%USERNAME%\AppData\Local"
    echo export TEMP="$SUBSTDRIVELETTER\Users\%USERNAME%\AppData\Local\Temp"
    echo export HOMEDRIVE="$SUBSTDRIVELETTER"
    echo export HOMEPATH="\Users\%USERNAME%"
    echo export USERNAME="%USERNAME%"
    echo export PROGRAMFILES="$SUBSTDRIVELETTER\Program Files"
    echo export COMMONPROGRAMFILES="$SUBSTDRIVELETTER\Program Files\Common Files"
    echo export PATH="$SUBSTDRIVELETTER\Windows;$SUBSTDRIVELETTER\Windows\System32;$SUBSTDRIVELETTER\Windows\System32\WindowsPowerShell\v1.0;$HOMEDRIVE$HOMEPATH\AppData\Local\Microsoft\WindowsApps;%USERPROFILE%\kib\usr\bin"
    echo.
    echo # Run the cmd.exe.
    echo.
    echo echo "Welcome to KIBDock on KIB in Batch 10.2.2. Image: windows_minimal"
    echo echo "If you see this message and a command shell, it means your container has successfully been deployed!"
    echo cd "$USERPROFILE"
    echo "$SUBSTDRIVELETTER\Windows\System32\cmd.exe"
) > "%USERPROFILE%\.kibdock\images\windows_minimal\start.sh"

:: -- end of windows_minimal -- ::

:: -- ubuntu -- ::

rmdir /s /q "%USERPROFILE%\.kibdock\images\ubuntu" >nul 2>nul

mkdir "%USERPROFILE%\.kibdock\images\ubuntu" >nul 2>nul

rem Create install script

(
    echo #!/bin/sh
    echo.
    echo # This is the install script for the KIB Ubuntu image.
    echo.
    echo # DESCRIPTION: The Ubuntu image is a Ubuntu image.
    echo # Ubuntu is a trademark of Canonical Ltd.
    echo.
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/rootfs"
    echo.
    echo # Download https://cdimages.ubuntu.com/ubuntu-wsl/noble/daily-live/current/noble-wsl-amd64.wsl
    echo curl -f -L https://cdimages.ubuntu.com/ubuntu-wsl/noble/daily-live/current/noble-wsl-amd64.wsl -o "$USERPROFILE/.kibdock/containers/$CTNRNAME/ubuntu.wsl"
    echo if [ $? -ne 0 ]; then
    echo     echo "Failed to download Ubuntu image. Please check your network connection."
    echo     rm -rf "$USERPROFILE/.kibdock/containers/$CTNRNAME"
    echo     exit 1
    echo fi
    echo.
    echo wsl --import "${CTNRNAME}_ubuntu_kib" "$USERPROFILE/.kibdock/containers/$CTNRNAME/rootfs" "$USERPROFILE/.kibdock/containers/$CTNRNAME/ubuntu.wsl" --version 2
) > "%USERPROFILE%\.kibdock\images\ubuntu\install.sh"

rem Create uninstall script

(
    echo #!/bin/sh
    echo.
    echo # This is the uninstall script for the KIB Ubuntu image.
    echo.
    echo # DESCRIPTION: The Ubuntu image is a Ubuntu image.
    echo # Ubuntu is a trademark of Canonical Ltd.
    echo.
    echo wsl --terminate "${CTNRNAME}_ubuntu_kib"
    echo wsl --unregister "${CTNRNAME}_ubuntu_kib"
    echo rm -rf "$USERPROFILE/.kibdock/containers/$CTNRNAME"
) > "%USERPROFILE%\.kibdock\images\ubuntu\uninstall.sh"

rem Create start script

(
    echo #!/bin/sh
    echo.
    echo # This is the start script for the KIB Ubuntu image.
    echo.
    echo # DESCRIPTION: The Ubuntu image is a Ubuntu image.
    echo # Ubuntu is a trademark of Canonical Ltd.
    echo.
    echo echo "Welcome to KIBDock on KIB in Batch 10.2.2. Image: ubuntu"
    echo echo "If you see this message and a command shell, it means your container has successfully been deployed!"
    echo wsl -d "${CTNRNAME}_ubuntu_kib"
) > "%USERPROFILE%\.kibdock\images\ubuntu\start.sh"

:: -- end of ubuntu -- ::

:: website ::

:: This image uses busybox httpd to serve the current directory on localhost.

rmdir /s /q "%USERPROFILE%\.kibdock\images\website" 2>nul
mkdir "%USERPROFILE%\.kibdock\images\website" 2>nul

rem Create install script

(
    echo #!/bin/sh
    echo.
    echo # This is the install script for the KIB website image.
    echo.
    echo # DESCRIPTION: The website image is a website image.
    echo.
    echo # Check if CTNRNAME isn't set.
    echo.
    echo if [ -z "$CTNRNAME" ]; then
    echo   echo "Error: CTNRNAME is not set. Please set it before running this script."
    echo   exit 1
    echo fi
    echo.
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/usr/bin"
    echo.
    echo # Copy busybox.exe, it's all we need
    echo cp -f "$USERPROFILE/kib/usr/bin/busybox.exe" "$USERPROFILE/.kibdock/containers/$CTNRNAME/usr/bin/busybox-ctnr-http.exe"
    echo.
    echo echo "Succesfully created the website container."
) > "%USERPROFILE%\.kibdock\images\website\install.sh"

rem Create start script

(
    echo #!/bin/sh
    echo.
    echo # This is the start script for the KIB website image.
    echo.
    echo # DESCRIPTION: The website image is a website image.
    echo.
    echo rm -rf "$SUBSTDRIVELETTER/website"
    echo.
    echo ln -sf "$(pwd)" "$SUBSTDRIVELETTER/website"
    echo.
    echo # Get port number
    echo.
    echo read -p "Enter the port number you want to use: " PORT
    echo.
    echo # If not defined, default to 8080
    echo if [ -z "$PORT" ]; then
    echo   PORT=8080
    echo fi
    echo.
    echo "$SUBSTDRIVELETTER/usr/bin/busybox-ctnr-http.exe" httpd -p $PORT -h "$SUBSTDRIVELETTER/website/"
    echo read -p "Press enter to stop the server... "
    echo taskkill.exe /f /im busybox-ctnr-http.exe
) > "%USERPROFILE%\.kibdock\images\website\start.sh"

:: -- end of website -- ::

:: -- windows_functional -- ::

rmdir /s /q "%USERPROFILE%\.kibdock\images\windows_functional" >nul 2>&1

mkdir "%USERPROFILE%\.kibdock\images\windows_functional" >nul 2>&1

(
    echo #!/bin/sh
    echo.
    echo # This is the install script for the KIB Windows Functional image.
    echo.
    echo # DESCRIPTION: The Windows Functional image is a Windows image.
    echo # Windows is a trademark of Microsoft Corporation.
    echo.
    echo # Check if CTNRNAME isn't set.
    echo if [ -z "$CTNRNAME" ]; then
    echo     echo "Error: CTNRNAME must be set."
    echo     exit 1
    echo fi
    echo.
    echo echo "WARNING: Windows Defender doesn't quite like Windows containers. It might quarantine BusyBox."
    echo.
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files (x86)"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/ProgramData"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/Desktop"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/Documents"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/AppData/Local/Temp"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/AppData/Local/Microsoft"
    echo mkdir -p "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/AppData/Roaming"
    echo ln -sf "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Documents and Settings"
    echo.
    echo # Symlink entire Windows system directories instead of individual files
    echo echo "Creating comprehensive Windows system directory symlinks..."
    echo.
    echo # Main Windows directories
    echo ln -sf "$SYSTEMROOT" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Windows"
    echo.
    echo # Program Files directories
    echo echo "Linking Program Files directories..."
    echo if [ -d "$SYSTEMDRIVE/Program Files/Common Files" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files/Common Files" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files/Common Files"
    echo fi
    echo if [ -d "$SYSTEMDRIVE/Program Files/WindowsApps" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files/WindowsApps" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files/WindowsApps"
    echo fi
    echo if [ -d "$SYSTEMDRIVE/Program Files/Windows Defender" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files/Windows Defender" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files/Windows Defender"
    echo fi
    echo if [ -d "$SYSTEMDRIVE/Program Files/Windows Security" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files/Windows Security" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files/Windows Security"
    echo fi
    echo if [ -d "$SYSTEMDRIVE/Program Files/Microsoft Office" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files/Microsoft Office" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files/Microsoft Office"
    echo fi
    echo if [ -d "$SYSTEMDRIVE/Program Files/Windows NT" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files/Windows NT" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files/Windows NT"
    echo fi
    echo if [ -d "$SYSTEMDRIVE/Program Files/Windows Kits" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files/Windows Kits" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files/Windows Kits"
    echo fi
    echo if [ -d "$SYSTEMDRIVE/Program Files/Windows Photo Viewer" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files/Windows Photo Viewer" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files/Windows Photo Viewer"
    echo fi
    echo.
    echo # Program Files ^(x86^) directories
    echo if [ -d "$SYSTEMDRIVE/Program Files (x86)/Common Files" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files (x86)/Common Files" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files (x86)/Common Files"
    echo fi
    echo if [ -d "$SYSTEMDRIVE/Program Files (x86)/Microsoft Office" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files (x86)/Microsoft Office" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files (x86)/Microsoft Office"
    echo fi
    echo if [ -d "$SYSTEMDRIVE/Program Files (x86)/Windows Kits" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files (x86)/Windows Kits" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files (x86)/Windows Kits"
    echo fi
    echo if [ -d "$SYSTEMDRIVE/Program Files (x86)/Windows NT" ]; then
    echo     ln -sf "$SYSTEMDRIVE/Program Files (x86)/Windows NT" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Program Files (x86)/Windows NT"
    echo fi
    echo.
    echo # User profile AppData links
    echo if [ -d "$USERPROFILE/AppData/Local/Microsoft/WindowsApps" ]; then
    echo     ln -sf "$USERPROFILE/AppData/Local/Microsoft/WindowsApps" "$USERPROFILE/.kibdock/containers/$CTNRNAME/Users/$USERNAME/AppData/Local/Microsoft/WindowsApps"
    echo fi
) > "%USERPROFILE%\.kibdock\images\windows_functional\install.sh"

(
    echo #!/bin/sh
    echo.
    echo # This is the start script for the KIB Windows Functional image.
    echo.
    echo # DESCRIPTION: The Windows Functional image is a Windows image.
    echo # Windows is a trademark of Microsoft Corporation.
    echo.
    echo # Make sure SUBSTDRIVELETTER is set.
    echo.
    echo if [ -z "$SUBSTDRIVELETTER" ]; then
    echo     echo "Error: SUBSTDRIVELETTER must be set."
    echo     exit 1
    echo fi
    echo.
    echo # Set environment variables. These do the container isolation by making apps access directories of the container.
    echo.
    echo export SYSTEMDRIVE="$SUBSTDRIVELETTER"
    echo export SYSTEMROOT="$SUBSTDRIVELETTER\Windows"
    echo export USERPROFILE="$SUBSTDRIVELETTER\Users\%USERNAME%"
    echo export APPDATA="$SUBSTDRIVELETTER\Users\%USERNAME%\AppData\Roaming"
    echo export LOCALAPPDATA="$SUBSTDRIVELETTER\Users\%USERNAME%\AppData\Local"
    echo export TEMP="$SUBSTDRIVELETTER\Users\%USERNAME%\AppData\Local\Temp"
    echo export HOMEDRIVE="$SUBSTDRIVELETTER"
    echo export HOMEPATH="\Users\%USERNAME%"
    echo export USERNAME="%USERNAME%"
    echo export PROGRAMFILES="$SUBSTDRIVELETTER\Program Files"
    echo export COMMONPROGRAMFILES="$SUBSTDRIVELETTER\Program Files\Common Files"
    echo export PATH="$SUBSTDRIVELETTER\Windows;$SUBSTDRIVELETTER\Windows\System32;$SUBSTDRIVELETTER\Windows\System32\WindowsPowerShell\v1.0;$HOMEDRIVE$HOMEPATH\AppData\Local\Microsoft\WindowsApps;%USERPROFILE%\kib\usr\bin"
    echo.
    echo # Run the cmd.exe.
    echo.
    echo echo "Welcome to KIBDock on KIB in Batch 10.2.2. Image: windows_functional"
    echo echo "If you see this message and a command shell, it means your container has successfully been deployed!"
    echo cd "$USERPROFILE"
    echo export SYSTEMDRIVE="$SUBSTDRIVELETTER"
    echo export SYSTEMROOT="$SUBSTDRIVELETTER\Windows"
    echo export USERPROFILE="$SUBSTDRIVELETTER\Users\%USERNAME%"
    echo export APPDATA="$SUBSTDRIVELETTER\Users\%USERNAME%\AppData\Roaming"
    echo export LOCALAPPDATA="$SUBSTDRIVELETTER\Users\%USERNAME%\AppData\Local"
    echo export TEMP="$SUBSTDRIVELETTER\Users\%USERNAME%\AppData\Local\Temp"
    echo export HOMEDRIVE="$SUBSTDRIVELETTER"
    echo export HOMEPATH="\Users\%USERNAME%"
    echo export USERNAME="%USERNAME%"
    echo export PROGRAMFILES="$SUBSTDRIVELETTER\Program Files"
    echo export COMMONPROGRAMFILES="$SUBSTDRIVELETTER\Program Files\Common Files"
    echo export PATH="$SUBSTDRIVELETTER\Windows;$SUBSTDRIVELETTER\Windows\System32;$SUBSTDRIVELETTER\Windows\System32\WindowsPowerShell\v1.0;$HOMEDRIVE$HOMEPATH\AppData\Local\Microsoft\WindowsApps;%USERPROFILE%\kib\usr\bin"
    echo "$SUBSTDRIVELETTER\Windows\System32\cmd.exe"
) > "%USERPROFILE%\.kibdock\images\windows_functional\start.sh"

:: -- end of windows_functional -- ::
