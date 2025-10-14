@echo off

setlocal enabledelayedexpansion

rem kibdock.bat
rem    * Container program for the KIB in Batch project.
rem    * Deploys secure KIB containers.
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

if not defined USER set "USER=%USERNAME%"

if "%~1"=="" goto help
if "%~1"=="help" goto help
if "%~1"=="init" goto init
if "%~1"=="uninit" goto uninit
if "%~1"=="create" goto create
if "%~1"=="deploy" goto deploy
if "%~1"=="delete" goto delete
if "%~1"=="list" goto list
if "%~1"=="list-img" goto list-img

echo Unknown command: %~1
exit /b 1

:help

echo %~0 [command]
echo.
echo Deploy secure KIB containers.
echo.
echo Commands:
echo ---------
echo - init                : Enable the KIBDock service.
echo - uninit              : Disable the KIBDock service. [deletes ALL kibdock data]
echo - create              : Create a new KIB container.
echo - deploy              : Deploy a KIB container.
echo - delete              : Delete a KIB container.
echo - list                : List all KIB containers.
echo - list-img            : List all available KIB images.
echo - help                : Display this help message.
echo.
echo This software is licensed to %USER% under the terms of the GNU General Public License, ONLY version 2 of it.
echo There is no warranty, without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
echo.

goto end


:init

if exist "%USERPROFILE%\.kibdock" goto kibdock_exists

call "%USERPROFILE%\kib\usr\libexec\kibdock-init.bat"

if errorlevel 1 (
    echo Error: unable to initialize KIBDock.
    rmdir /s /q "%USERPROFILE%\.kibdock"
    exit /b 1
)

echo KIBDock service enabled.

goto end

:uninit

if not exist "%USERPROFILE%\.kibdock" goto kibdock_doesnt_exist

echo Warning: This action is destructive and will delete all KIBDock data.
set /p confirm=ARE YOU SURE YOU WANT TO CONTINUE? [Y/N] 

if /i "%confirm%" == "y" (
    echo WAITING 10 SECONDS BEFORE PERFORMING DESTRUCTIVE ACTION. IF THIS WAS A MISTAKE, EXIT NOW.
    "%SystemRoot%\system32\timeout.exe" /t 10 >nul
    rmdir /s /q "%USERPROFILE%\.kibdock"
    echo KIBDock service disabled.
) else (
    goto end
)

goto end

:kibdock_exists

echo KIBDock service is already enabled.

goto end

:kibdock_doesnt_exist

echo KIBDock service is not enabled.

goto end

:create

if not exist "%USERPROFILE%\.kibdock" goto kibdock_doesnt_exist

set /p name=Enter container name: 

set /p image=Enter image name: 

if not defined name goto create_error
if not defined image goto create_error

rem Check if image exists

if not exist "%USERPROFILE%\.kibdock\images\!image!" goto create_error
if not exist "%USERPROFILE%\.kibdock\images\!image!\install.sh" goto create_error
if exist "%USERPROFILE%\.kibdock\containers\!name!" goto create_error

rem Use a for loop to remove trailing spaces from name

for /f "tokens=*" %%a in ("!name!") do (
    set "name=%%~a"
)

rem Remove special characters from name

set "name=!name: =_!"
set "name=!name:\=!"
set "name=!name:/=!"
set "name=!name:?=!"
set "name=!name:^^=!"

mkdir "%USERPROFILE%\.kibdock\containers\!name!"
echo !image!>"%USERPROFILE%\.kibdock\containers\!name!\image.txt"

set "CTNRNAME=!name!"

"%USERPROFILE%\kib\usr\bin\busybox.exe" bash -c "export CTNRNAME=!name!; source ""$USERPROFILE/.kibdock/images/!image!/install.sh"""

goto end

:deploy

set /p CONTAINERNAME=Enter container name: 
set /p image=<"%USERPROFILE%\.kibdock\containers\!CONTAINERNAME!\image.txt"

echo Deploying container "!CONTAINERNAME!"...

if not defined CONTAINERNAME goto deploy_error

if not exist "%USERPROFILE%\.kibdock\containers\!CONTAINERNAME!" goto deploy_error

set /p SUBSTDRIVELETTER=Enter drive letter for container: 

if exist "%SUBSTDRIVELETTER%\" goto deploy_error

subst %SUBSTDRIVELETTER% "%USERPROFILE%\.kibdock\containers\!CONTAINERNAME!"

if errorlevel 1 goto deploy_error

rem Now, run start.sh

"%USERPROFILE%\kib\usr\bin\busybox.exe" bash -c "export CTNRNAME=!CONTAINERNAME!; source ""$USERPROFILE/.kibdock/images/!image!/start.sh"""

rem Now it is done, so we delete the drive letter

subst %SUBSTDRIVELETTER% /d

goto end

:delete

set /p CONTAINERNAME=Enter container name: 

if not defined CONTAINERNAME (
    echo Error: Container name not specified.
    goto end
)

set /p image=<"%USERPROFILE%\.kibdock\containers\!CONTAINERNAME!\image.txt"

rem Run the uninstall.sh script if it exists

if exist "%USERPROFILE%\.kibdock\images\!image!\uninstall.sh" (
    set "CTNRNAME=!CONTAINERNAME!"
    "%USERPROFILE%\kib\usr\bin\busybox.exe" bash -c "export CTNRNAME=!CONTAINERNAME!; source ""$USERPROFILE/.kibdock/images/!image!/uninstall.sh"""
) else (
    rmdir /s /q "%USERPROFILE%\.kibdock\containers\!CONTAINERNAME!"
)

goto end

:list

dir /ad "%USERPROFILE%\.kibdock\containers"

goto end

:list-img

dir /ad "%USERPROFILE%\.kibdock\images"

goto end

:create_error

echo Error: Bad image and/or name.
exit /b 1

:deploy_error

echo Error: Bad container and/or drive letter.
exit /b 1

:end
