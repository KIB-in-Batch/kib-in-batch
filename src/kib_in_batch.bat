@echo off

setlocal enabledelayedexpansion

ping -n 1 google.com >nul 2>&1
if errorlevel 1 (
    echo No internet connection.
    echo Press any key to continue...
    pause >nul
    exit /b 1
)

if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    cls
    echo This app cannot run on your PC.
    echo Press any key to continue...

pause >nul
    exit /b 1
)

where powershell >nul 2>&1

if %errorlevel% neq 0 (
    echo PowerShell not found.
    exit /b 1
)

where curl >nul 2>&1

if %errorlevel% neq 0 (
    echo Curl not found.
    exit /b 1
)

set "BUSYBOX_URL=https://github.com/KIB-in-Batch/busybox-w32/releases/latest/download/busybox64.exe"

:prompt_for_token

set /p "github=Enter your GitHub token. Leave blank if you are not experiencing rate limiting issues: "
set "GITHUB_TOKEN=!github!"

:prompt_for_letter

set /p "driveletter=Enter drive letter to use temporarily: "

if not defined driveletter goto prompt_for_letter
if exist !driveletter! (
    echo Drive exists
    goto prompt_for_letter
)

if exist "%TEMP%\kib_temp" (
    rd /s /q "%TEMP%\kib_temp"
)
if not exist "%TEMP%" (
    mkdir "%TEMP%"
)
mkdir "%TEMP%\kib_temp"
cd "%TEMP%\kib_temp"
subst "!driveletter!" "%TEMP%\kib_temp"
if errorlevel 1 (
    echo Invalid drive letter
    goto prompt_for_letter
)
mkdir "!driveletter!\bin"

:download_busybox

curl -L -# -o "!driveletter!\bin\busybox.exe" "%BUSYBOX_URL%"

if %errorlevel% neq 0 (
    echo Failed to download. Press any key to retry...
    pause >nul
    goto download_busybox
)

set "BUSYBOX_PATH=!driveletter!\bin\busybox.exe"

:try

set "pkg_name=init"

powershell -ExecutionPolicy Bypass -Command "& { try { $ErrorActionPreference = 'Stop'; $owner='KIB-in-Batch'; $repo='pkg'; $targetDir='packages-kib11/!pkg_name!'; $localDir='!driveletter!\tmp\!pkg_name!_package'; if(Test-Path $localDir){Remove-Item $localDir -Recurse -Force}; function Download-GitHubDirectory { param($owner,$repo,$path,$localPath); $apiUrl=\"https://api.github.com/repos/$owner/$repo/contents/$path\"; try { $headers = @{}; if($env:GITHUB_TOKEN) { $headers['Authorization'] = \"token $env:GITHUB_TOKEN\" }; $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -TimeoutSec 30; if(-not(Test-Path $localPath)){New-Item -ItemType Directory -Path $localPath -Force | Out-Null}; foreach($item in $response) { $itemLocalPath = Join-Path $localPath $item.name; if($item.type -eq 'file') { Write-Host \"Downloading: $($item.name)\"; Invoke-WebRequest -Uri $item.download_url -OutFile $itemLocalPath -TimeoutSec 30 } elseif($item.type -eq 'dir') { Download-GitHubDirectory $owner $repo \"$path/$($item.name)\" $itemLocalPath } } } catch { Write-Error \"Failed to download $path : $_\"; throw } }; Download-GitHubDirectory $owner $repo $targetDir $localDir; Write-Host 'Download completed successfully.' } catch { Write-Error \"PowerShell download failed: $_\"; exit 1 } }"

if errorlevel 1 (
    echo Download failed. Press any key to exit...
    pause >nul
    subst "!driveletter!" /d
    exit /b 1
)

:install

set "pkg_path=!driveletter!\tmp\!pkg_name!_package"
cd "!pkg_path!"

if not exist "!pkg_path!\INSTALL.sh" (
    echo No INSTALl.sh. Press any key to exit...
    pause >nul
    subst "!driveletter!" /d
    exit /b 1
)
if not exist "!pkg_path!\files" (
    echo No files. Press any key to exit...
    pause >nul
    subst "!driveletter!" /d
    exit /b 1
)

set "pkg_path_nix=!pkg_path:\=/!"

"!BUSYBOX_PATH!" bash -c "cd !pkg_path_nix!; find . -type f -exec dos2unix {} \;"

"!BUSYBOX_PATH!" bash -c "cd !pkg_path_nix!; ./INSTALL.sh"

"!BUSYBOX_PATH!" bash -c "cd !driveletter!/sys/kib/files; find . -type f -exec unix2dos {} \;"

"!driveletter!\sys\kib\files\kib_in_batch.bat"
if errorlevel 1 (
    echo Install failed. Press any key to exit...
    pause >nul
    subst "!driveletter!" /d
    exit /b 1
)

subst "!driveletter!" /d

exit /b 0
