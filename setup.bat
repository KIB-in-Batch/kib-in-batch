@echo off
setlocal enabledelayedexpansion

rem setup.bat
rem    * Setup script. for the Kali in Batch project.
rem    * Bundles binaries for proper functionality.
rem    * Licensed under the Apache-2.0.

zstd --version >nul 2>&1

if !errorlevel! neq 0 (
    echo Zstd is not installed. Installing zstd...
    winget install --id Meta.Zstandard -e
)

rem Download busybox

echo Downloading busybox...
curl -# "https://web.archive.org/web/20250606214654/https://frippery.org/files/busybox/busybox.exe" --output "%~dp0busybox.exe"

rem Download https://repo.msys2.org/msys/x86_64/bash-5.2.037-2-x86_64.pkg.tar.zst

echo Downloading bash...
curl -# "https://repo.msys2.org/msys/x86_64/bash-5.2.037-2-x86_64.pkg.tar.zst" --output "%~dp0bash.tar.zst"

echo Extracting bash...

zstd -d "%~dp0bash.tar.zst"
"%~dp0busybox.exe" tar -xf "%~dp0bash.tar"

echo Downloading Msys2 runtime...

curl -# "https://repo.msys2.org/msys/x86_64/msys2-runtime-3.4.10-5-x86_64.pkg.tar.zst" --output "%~dp0msys2-runtime.tar.zst"

echo Extracting Msys2 runtime...

zstd -d "%~dp0msys2-runtime.tar.zst"
"%~dp0busybox.exe" tar -xf "%~dp0msys2-runtime.tar"

echo Copying busybox to "%~dp0src\bin\..."

copy /b /y "%~dp0busybox.exe" "%~dp0src\bin\busybox.exe"

echo Copying other binaries...
xcopy /y "%~dp0usr\bin\*" "%~dp0src\bin\"

echo Cleaning up...

del /s /q "%~dp0bash.tar.zst"
del /s /q "%~dp0msys2-runtime.tar.zst"
del /s /q "%~dp0bash.tar"
del /s /q "%~dp0msys2-runtime.tar"
rmdir /s /q "%~dp0usr"
echo Done!
choice /c yn /n /m "Do you want to run Kali in Batch? (y/n) "
if errorlevel 2 goto end
if errorlevel 1 goto kali

:kali

"%~dp0src\kali_in_batch.bat"

:end
