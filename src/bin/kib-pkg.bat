@echo off

setlocal enabledelayedexpansion

rem kib-pkg.bat
rem    * Package manager for the Kali in Batch project.
rem    * Manages packages.
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
set "COLOR_PACKAGE=!COLOR_BRIGHT_CYAN!!COLOR_ITALIC!"
set "COLOR_VERSION=!COLOR_BRIGHT_YELLOW!"
set "COLOR_COMMAND=!COLOR_BRIGHT_GREEN!!COLOR_BOLD!"
set "COLOR_OPTION=!COLOR_BRIGHT_MAGENTA!!COLOR_BOLD!"
set "COLOR_HEADER=!COLOR_BRIGHT_WHITE!!COLOR_BOLD!!COLOR_BG_BLUE!"
set "COLOR_LIST_ITEM=!COLOR_BRIGHT_WHITE!"
set "COLOR_LIST_NUM=!COLOR_BRIGHT_GREEN!"

goto start

:start

rem Check if ROOT is set to 0
if "%ROOT%" == "0" (
    echo !COLOR_ERROR!Please log in as the root user to run kib-pkg, or you can:!COLOR_RESET!
    echo 1. Run kib-pkg with sudo !COLOR_ITALIC!^(e.g. sudo kib-pkg %*!COLOR_RESET!^)
    echo 2. Use the su command to become root, then run unsu after you don't need root anymore.
    exit /b 1
)

if not exist "%APPDATA%\kali_in_batch" (
    echo !COLOR_ERROR!Error: Kali in Batch is not installed on your system.!COLOR_RESET!
    exit /b 1
)

if not exist "%APPDATA%\kali_in_batch\kaliroot.txt" (
    echo !COLOR_ERROR!Error: kaliroot.txt not found.!COLOR_RESET!
    exit /b 1
)

set /p kaliroot=<"%APPDATA%\kali_in_batch\kaliroot.txt"

rem Validate kaliroot path
if not exist "!kaliroot!" (
    echo !COLOR_ERROR!Error: Kali root directory does not exist: !COLOR_PACKAGE!!kaliroot!!COLOR_RESET!
    exit /b 1
)

rem Ensure tmp directory exists
if not exist "!kaliroot!\tmp" (
    echo !COLOR_INFO!Creating tmp directory: !COLOR_PACKAGE!!kaliroot!\tmp!COLOR_RESET!
    mkdir "!kaliroot!\tmp"
)

:check_args
rem Check if the command line arguments are empty
if "%*"=="" (
    goto noargs
) else (
    goto parse
)

:noargs

echo !COLOR_HEADER!Usage: %~0 (install/remove/upgrade/search/list/update/help)!COLOR_RESET!
exit /b 64

:help

echo !COLOR_HEADER!Usage: %~0 (install/remove/upgrade/search/list/update/help)!COLOR_RESET!
echo.
echo !COLOR_UNDERLINE!Commands:!COLOR_RESET!
echo   !COLOR_COMMAND!install!COLOR_RESET!         - Install a package by name.
echo   !COLOR_COMMAND!remove!COLOR_RESET!          - Remove an installed package by name.
echo   !COLOR_COMMAND!upgrade!COLOR_RESET!         - Upgrade an installed package to the latest version.
echo   !COLOR_COMMAND!search!COLOR_RESET!          - Search for packages in the package database.
echo   !COLOR_COMMAND!list!COLOR_RESET!            - List all installed packages.
echo   !COLOR_COMMAND!update!COLOR_RESET!          - Update the package database cache.
echo   !COLOR_COMMAND!help!COLOR_RESET!            - Display this help message.
exit /b

:parse

rem Check the first argument
if "%1"=="install" (
    if "%2"=="" (
        echo !COLOR_ERROR!Package name is required.!COLOR_RESET!
        exit /b 1
    )
    goto install
) else if "%1"=="remove" (
    if "%2"=="" (
        echo !COLOR_ERROR!Package name is required.!COLOR_RESET!
        exit /b 1
    )
    goto remove
) else if "%1"=="upgrade" (
    if "%2"=="" (
        echo !COLOR_ERROR!Package name is required.!COLOR_RESET!
        exit /b 1
    )
    goto upgrade
) else if "%1"=="help" (
    goto help
) else if "%1"=="search" (
    if "%2"=="" (
        echo !COLOR_ERROR!Search term is required.!COLOR_RESET!
        exit /b 1
    )
    goto search
) else if "%1"=="list" (
    goto list
) else if "%1"=="update" (
    goto update
) else (
    echo !COLOR_ERROR!Invalid argument: !COLOR_PACKAGE!%1!COLOR_RESET!
    echo Run '!COLOR_COMMAND!kib-pkg help!COLOR_RESET!' for usage information.
    exit /b 1
)

:update

echo !COLOR_INFO!Updating package database...!COLOR_RESET!

rem Check if curl is available
curl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo !COLOR_ERROR!Error: curl is not installed or not in PATH.!COLOR_RESET!
    exit /b 1
)

curl -f -s https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages.list >"%APPDATA%\kali_in_batch\packages.list"

if %errorlevel% neq 0 (
    echo !COLOR_ERROR!Failed to update package database. Check your internet connection.!COLOR_RESET!
    exit /b 1
)

echo !COLOR_SUCCESS!Package database updated successfully.!COLOR_RESET!
exit /b

:check_package_exists

rem Check if package exists in the package list
set kib-pkg_to_check=%1
if "!kib-pkg_to_check!"=="" (
    echo !COLOR_ERROR!No package name provided.!COLOR_RESET!
    exit /b 1
)

if not exist "%APPDATA%\kali_in_batch\packages.list" (
    echo !COLOR_ERROR!Package database not found. Please run: !COLOR_COMMAND!kib-pkg update!COLOR_RESET!
    exit /b 1
)

findstr /c:"!kib-pkg_to_check!" "%APPDATA%\kali_in_batch\packages.list" >nul
if %errorlevel% neq 0 (
    echo !COLOR_ERROR!Package !COLOR_PACKAGE!!kib-pkg_to_check!!COLOR_RESET!!COLOR_ERROR! is not available in the repository.!COLOR_RESET!
    echo Try running '!COLOR_COMMAND!kib-pkg search !kib-pkg_to_check!!COLOR_RESET!' to find similar packages.
    exit /b 1
)
goto :eof

:check_package_installed

rem Check if package is installed
set kib-pkg_to_check=%1
if not exist "%APPDATA%\kali_in_batch\installed.packages.list" (
    echo. >"%APPDATA%\kali_in_batch\installed.packages.list"
)
if "!kib-pkg_to_check!"=="" (
    exit /b 1
)
findstr /c:"!kib-pkg_to_check!" "%APPDATA%\kali_in_batch\installed.packages.list" >nul
if %errorlevel% neq 0 (
    exit /b 1
)
goto :eof

:add_to_installed

rem Add package to installed list
set kib-pkg_to_add=%1
if not "!kib-pkg_to_add!"=="" (
    echo !kib-pkg_to_add!>>"%APPDATA%\kali_in_batch\installed.packages.list"
)
goto :eof

:remove_from_installed

rem Remove package from installed list
set kib-pkg_to_remove=%1
if exist "%APPDATA%\kali_in_batch\installed.packages.list" (
    if not "!kib-pkg_to_remove!"=="" (
        findstr /v /c:"!kib-pkg_to_remove!" "%APPDATA%\kali_in_batch\installed.packages.list" >"%APPDATA%\kali_in_batch\temp.list"
        if exist "%APPDATA%\kali_in_batch\temp.list" (
            move "%APPDATA%\kali_in_batch\temp.list" "%APPDATA%\kali_in_batch\installed.packages.list" >nul
        )
    )
)
goto :eof

:install_dependencies

rem Check if DEPENDENCIES.txt exists and install dependencies
echo !COLOR_INFO!Checking for dependencies...!COLOR_RESET!

rem Clean up any existing dependency file
if exist "!kaliroot!\tmp\%1_dependencies.txt" (
    del "!kaliroot!\tmp\%1_dependencies.txt"
)

curl -f -s https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%1/DEPENDENCIES.txt -o "!kaliroot!\tmp\%1_dependencies.txt" 2>nul

if %errorlevel% neq 0 (
    echo !COLOR_INFO!No dependencies found for !COLOR_PACKAGE!%1!COLOR_RESET!
    goto :eof
)

rem Check if file was downloaded successfully and has content
if not exist "!kaliroot!\tmp\%1_dependencies.txt" (
    echo !COLOR_INFO!No dependencies found for !COLOR_PACKAGE!%1!COLOR_RESET!
    goto :eof
)

rem Check file size
for %%A in ("!kaliroot!\tmp\%1_dependencies.txt") do set size=%%~zA
if !size! equ 0 (
    echo !COLOR_INFO!No dependencies found for !COLOR_PACKAGE!%1!COLOR_RESET!
    del "!kaliroot!\tmp\%1_dependencies.txt" 2>nul
    goto :eof
)

echo !COLOR_INFO!Installing dependencies for !COLOR_PACKAGE!%1!COLOR_RESET!...
for /f "usebackq delims=" %%i in ("!kaliroot!\tmp\%1_dependencies.txt") do (
    echo Installing dependency: !COLOR_PACKAGE!%%i!COLOR_RESET!
    call :install_single_package "%%i"
    if !errorlevel! neq 0 (
        echo !COLOR_WARNING!Warning: Failed to install dependency !COLOR_PACKAGE!%%i!COLOR_RESET!
    )
)

del "!kaliroot!\tmp\%1_dependencies.txt" 2>nul
goto :eof

:install_single_package

rem Install a single package (used for dependencies)
set kib-pkg_name=%~1

rem Check if already installed
call :check_package_installed "!kib-pkg_name!"
if %errorlevel% equ 0 (
    echo !COLOR_INFO!Package !COLOR_PACKAGE!!kib-pkg_name!!COLOR_RESET!!COLOR_INFO! is already installed.!COLOR_RESET!
    goto :eof
)

rem Check if package exists
call :check_package_exists "!kib-pkg_name!"
if %errorlevel% neq 0 (
    echo !COLOR_ERROR!Dependency !COLOR_PACKAGE!!kib-pkg_name!!COLOR_RESET!!COLOR_ERROR! is not available.!COLOR_RESET!
    exit /b 1
)

echo !COLOR_INFO!Installing !COLOR_PACKAGE!!kib-pkg_name!!COLOR_RESET!...

rem Clean up any existing package directory
if exist "!kaliroot!\tmp\!kib-pkg_name!_package" (
    rmdir /s /q "!kaliroot!\tmp\!kib-pkg_name!_package"
)

rem Download the entire package directory using PowerShell
echo !COLOR_INFO!Downloading package files for !COLOR_PACKAGE!!kib-pkg_name!!COLOR_RESET!...

powershell -ExecutionPolicy Bypass -Command "& { try { $ErrorActionPreference = 'Stop'; $owner='Kali-in-Batch'; $repo='pkg'; $targetDir='packages/!kib-pkg_name!'; $localDir='!kaliroot!\tmp\!kib-pkg_name!_package'; if(Test-Path $localDir){Remove-Item $localDir -Recurse -Force}; function Download-GitHubDirectory { param($owner,$repo,$path,$localPath); $apiUrl=\"https://api.github.com/repos/$owner/$repo/contents/$path\"; try { $headers = @{}; if($env:GITHUB_TOKEN) { $headers['Authorization'] = \"token $env:GITHUB_TOKEN\" }; $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -TimeoutSec 30; if(-not(Test-Path $localPath)){New-Item -ItemType Directory -Path $localPath -Force | Out-Null}; foreach($item in $response) { $itemLocalPath = Join-Path $localPath $item.name; if($item.type -eq 'file') { Write-Host \"Downloading: $($item.name)\"; Invoke-WebRequest -Uri $item.download_url -OutFile $itemLocalPath -TimeoutSec 30 } elseif($item.type -eq 'dir') { Download-GitHubDirectory $owner $repo \"$path/$($item.name)\" $itemLocalPath } } } catch { Write-Error \"Failed to download $path : $_\"; throw } }; Download-GitHubDirectory $owner $repo $targetDir $localDir; Write-Host 'Download completed successfully.' } catch { Write-Error \"PowerShell download failed: $_\"; exit 1 } }"
powershell -ExecutionPolicy Bypass -Command "& { try { $ErrorActionPreference = 'Stop'; $owner='Kali-in-Batch'; $repo='pkg'; $targetDir='packages/!kib-pkg_name!/files'; $localDir='!kaliroot!\tmp\!kib-pkg_name!_package\files'; if(Test-Path $localDir){Remove-Item $localDir -Recurse -Force}; function Download-GitHubDirectory { param($owner,$repo,$path,$localPath); $apiUrl=\"https://api.github.com/repos/$owner/$repo/contents/$path\"; try { $headers = @{}; if($env:GITHUB_TOKEN) { $headers['Authorization'] = \"token $env:GITHUB_TOKEN\" }; $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -TimeoutSec 30; if(-not(Test-Path $localPath)){New-Item -ItemType Directory -Path $localPath -Force | Out-Null}; foreach($item in $response) { $itemLocalPath = Join-Path $localPath $item.name; if($item.type -eq 'file') { Write-Host \"Downloading: $($item.name)\"; Invoke-WebRequest -Uri $item.download_url -OutFile $itemLocalPath -TimeoutSec 30 } elseif($item.type -eq 'dir') { Download-GitHubDirectory $owner $repo \"$path/$($item.name)\" $itemLocalPath } } } catch { Write-Error \"Failed to download $path : $_\"; throw } }; Download-GitHubDirectory $owner $repo $targetDir $localDir; Write-Host 'Download completed successfully.' } catch { Write-Error \"PowerShell download failed: $_\"; exit 1 } }"

if %errorlevel% neq 0 (
    echo !COLOR_ERROR!Failed to download package !COLOR_PACKAGE!!kib-pkg_name!!COLOR_RESET!.
    echo This could be due to:
    echo   - Network connectivity issues
    echo   - Package does not exist in repository
    echo   - GitHub API rate limiting
    exit /b 1
)

rem Verify the download was successful
if not exist "!kaliroot!\tmp\!kib-pkg_name!_package" (
    echo !COLOR_ERROR!Error: Package directory was not created.!COLOR_RESET!
    exit /b 1
)

if not exist "!kaliroot!\usr\share\%1" mkdir "!kaliroot!\usr\share\%1" >nul 2>&1
curl -s -f https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%1/VERSION.txt >"!kaliroot!\usr\share\%1\VERSION.txt" 2>nul

rem Check if contents are "404: Not Found"

set /p vercontents=<"!kaliroot!\usr\share\%1\VERSION.txt"

if "%vercontents%" == "404: Not Found" (
    echo !COLOR_ERROR!No version found!COLOR_RESET!
    exit /b 1
)

rem Run INSTALL.sh if it exists
if exist "!kaliroot!\tmp\!kib-pkg_name!_package\INSTALL.sh" (
    echo !COLOR_INFO!Running install script for !COLOR_PACKAGE!!kib-pkg_name!!COLOR_RESET!...
    
    rem Check if bash exists
    if not exist "!kaliroot!\usr\bin\bash.exe" (
        echo !COLOR_ERROR!what the hell why did you delete a critical file!COLOR_RESET!
        exit /b 1
    ) else (
        set bash_path=!kaliroot!\usr\bin\bash.exe
    )
    
    "!bash_path!" -c "cd !kaliroot!/tmp/!kib-pkg_name!_package; !kaliroot!/tmp/!kib-pkg_name!_package/INSTALL.sh"
    
    if !errorlevel! neq 0 (
        echo !COLOR_ERROR!Error: Install script returned error code !errorlevel!!COLOR_RESET!
        exit /b 1
    )
) else (
    echo !COLOR_ERROR!No install script found for !COLOR_PACKAGE!!kib-pkg_name!!COLOR_RESET!.
    exit /b 1
)

rem Add to installed packages
call :add_to_installed "!kib-pkg_name!"

rem Clean up
rmdir /s /q "!kaliroot!\tmp\!kib-pkg_name!_package" 2>nul

echo !COLOR_SUCCESS!Package !COLOR_PACKAGE!!kib-pkg_name!!COLOR_RESET!!COLOR_SUCCESS! installed successfully.!COLOR_RESET!
goto :eof

:install

rem Check if package exists
call :check_package_exists "%2"
if %errorlevel% neq 0 exit /b 1

rem Check if already installed
call :check_package_installed "%2"
if %errorlevel% equ 0 (
    echo !COLOR_INFO!Package !COLOR_PACKAGE!%2!COLOR_RESET!!COLOR_INFO! is already installed.!COLOR_RESET!
    exit /b
)

rem Install dependencies first
call :install_dependencies %2
if %errorlevel% neq 0 (
    echo !COLOR_WARNING!Warning: Some dependencies failed to install. Continuing with main package...!COLOR_RESET!
)

rem Install the main package
call :install_single_package "%2"

exit /b

:remove

rem Check if package is installed
call :check_package_installed "%2"
if %errorlevel% neq 0 (
    echo !COLOR_ERROR!Package !COLOR_PACKAGE!%2!COLOR_RESET!!COLOR_ERROR! is not installed. Install it by running: !COLOR_COMMAND!kib-pkg install %2!COLOR_RESET!
    exit /b 1
)

echo !COLOR_INFO!Removing package !COLOR_PACKAGE!%2!COLOR_RESET!...

rem Clean up any existing uninstall script
if exist "!kaliroot!\tmp\%2_uninstall.sh" (
    del "!kaliroot!\tmp\%2_uninstall.sh"
)

rem Download and run UNINSTALL.sh if it exists
curl -f -s https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/UNINSTALL.sh -o "!kaliroot!\tmp\%2_uninstall.sh" 2>nul

if %errorlevel% equ 0 (
    if exist "!kaliroot!\tmp\%2_uninstall.sh" (
        echo !COLOR_INFO!Running uninstall script for !COLOR_PACKAGE!%2!COLOR_RESET!...
        
        rem Find bash interpreter
        if exist "!kaliroot!\usr\bin\bash.exe" (
            set bash_path=!kaliroot!\usr\bin\bash.exe
        ) else if exist "!kaliroot!\bin\bash.exe" (
            set bash_path=!kaliroot!\bin\bash.exe
        ) else (
            echo !COLOR_ERROR!Unable to find bash interpreter.!COLOR_RESET!
            exit /b 1
        )
        
        "!bash_path!" "!kaliroot!\tmp\%2_uninstall.sh"
    )
) else (
    echo !COLOR_INFO!No uninstall script found for !COLOR_PACKAGE!%2!COLOR_RESET!.
)

rem Remove from installed packages
call :remove_from_installed "%2"

rem Remove the folder in /usr/share
rmdir /s /q "!kaliroot!\usr\share\%2" 2>nul

echo !COLOR_SUCCESS!Package !COLOR_PACKAGE!%2!COLOR_RESET!!COLOR_SUCCESS! removed successfully.!COLOR_RESET!
exit /b

:compare_versions

rem Compare two version strings (format: x.y.z)
rem %3 = current version, %4 = new version
rem Returns 0 if new version is greater, 1 if not

set current_ver=%3
set new_ver=%4

rem Split versions by dots
for /f "tokens=1,2,3 delims=." %%a in ("%current_ver%") do (
    set curr_major=%%a
    set curr_minor=%%b
    set curr_patch=%%c
)

for /f "tokens=1,2,3 delims=." %%a in ("%new_ver%") do (
    set new_major=%%a
    set new_minor=%%b
    set new_patch=%%c
)

rem Set defaults for missing parts
if "!curr_major!"=="" set curr_major=0
if "!curr_minor!"=="" set curr_minor=0
if "!curr_patch!"=="" set curr_patch=0
if "!new_major!"=="" set new_major=0
if "!new_minor!"=="" set new_minor=0
if "!new_patch!"=="" set new_patch=0

rem Compare major version
if !new_major! gtr !curr_major! exit /b 0
if !new_major! lss !curr_major! exit /b 1
if !new_major! equ !curr_major! exit /b 1

rem Compare minor version
if !new_minor! gtr !curr_minor! exit /b 0
if !new_minor! lss !curr_minor! exit /b 1
if !new_minor! equ !curr_minor! exit /b 1

rem Compare patch version
if !new_patch! gtr !curr_patch! exit /b 0
if !new_patch! lss !curr_patch! exit /b 1
if !new_patch! equ !curr_patch! exit /b 1

exit /b 1

:upgrade

rem Check if package is installed
call :check_package_installed "%2"
if %errorlevel% neq 0 (
    echo !COLOR_ERROR!Package !COLOR_PACKAGE!%2!COLOR_RESET!!COLOR_ERROR! is not installed. Install it by running: !COLOR_COMMAND!kib-pkg install %2!COLOR_RESET!
    exit /b 1
)

rem Check if package exists in repository
call :check_package_exists "%2"
if %errorlevel% neq 0 exit /b 1

echo !COLOR_INFO!Checking for updates to !COLOR_PACKAGE!%2!COLOR_RESET!...

rem Clean up any existing version file
if exist "!kaliroot!\tmp\%2_new_version.txt" (
    del "!kaliroot!\tmp\%2_new_version.txt"
)

rem Get current version
curl -f -s https://raw.githubusercontent.com/Kali-in-Batch/pkg/refs/heads/main/packages/%2/VERSION.txt -o "!kaliroot!\tmp\%2_new_version.txt" 2>nul

if %errorlevel% neq 0 (
    echo !COLOR_ERROR!Cannot determine version for package !COLOR_PACKAGE!%2!COLOR_RESET!
    exit /b 1
)

set /p new_version=<"!kaliroot!\tmp\%2_new_version.txt"

rem Try to get current installed version
set current_version=0.0.0
if exist "!kaliroot!\usr\share\%2\VERSION.txt" (
    set /p current_version=<"!kaliroot!\usr\share\%2\VERSION.txt"
)

echo Current version: !COLOR_VERSION!!current_version!!COLOR_RESET!
echo Available version: !COLOR_VERSION!!new_version!!COLOR_RESET!

rem Compare versions
call :compare_versions %2 !current_version! !new_version!
if %errorlevel% neq 0 (
    echo !COLOR_INFO!Package !COLOR_PACKAGE!%2!COLOR_RESET!!COLOR_INFO! is already up to date.!COLOR_RESET!
    del "!kaliroot!\tmp\%2_new_version.txt" 2>nul
    exit /b
)

echo !COLOR_INFO!Upgrading package !COLOR_PACKAGE!%2!COLOR_RESET!...

rem Install dependencies first
call :install_dependencies %2

rem Install the updated package
call :install_single_package "%2"

del "!kaliroot!\tmp\%2_new_version.txt" 2>nul
echo !COLOR_SUCCESS!Package !COLOR_PACKAGE!%2!COLOR_RESET!!COLOR_SUCCESS! upgraded successfully.!COLOR_RESET!
exit /b

:search

rem Search for packages
echo !COLOR_INFO!Searching for packages containing "!COLOR_PACKAGE!%2!COLOR_RESET!!COLOR_INFO!"...!COLOR_RESET!
if not exist "%APPDATA%\kali_in_batch\packages.list" (
    echo !COLOR_ERROR!Package cache not found. Please run: !COLOR_COMMAND!kib-pkg update!COLOR_RESET!
    exit /b 1
)

findstr /i /c:"%2" "%APPDATA%\kali_in_batch\packages.list"
if %errorlevel% neq 0 (
    echo !COLOR_INFO!No packages found matching !COLOR_PACKAGE!"%2"!COLOR_RESET!!COLOR_INFO!.!COLOR_RESET!
)

echo.

exit /b

:list

rem List all installed packages
if not exist "%APPDATA%\kali_in_batch\installed.packages.list" (
    echo !COLOR_INFO!No packages are currently installed.!COLOR_RESET!
    exit /b
)

::echo !COLOR_HEADER!Installed packages:!COLOR_RESET!
set count=0
for /f "usebackq delims=" %%a in ("%APPDATA%\kali_in_batch\installed.packages.list") do (
    rem Strip out spaces from the package name
    set "package=%%~a"
    set "package=!package: =!"
    if not "!package!"=="" (
        set /a count+=1
        echo !package!
    )
)

if !count! equ 0 (
    echo !COLOR_INFO!No packages are currently installed.!COLOR_RESET!
)

exit /b
