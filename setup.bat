@echo off
setlocal

rem Only run this if you choose to use git clone instead of release zip file.

rem Download the files with proper output filenames
curl -s https://repo.msys2.org/msys/x86_64/bash-5.2.037-2-x86_64.pkg.tar.zst --output bash-5.2.037-2-x86_64.pkg.tar.zst
curl -s https://repo.msys2.org/msys/x86_64/msys2-runtime-3.4.10-5-x86_64.pkg.tar.zst --output msys2-runtime-3.4.10-5-x86_64.pkg.tar.zst

rem Install 7-Zip
7z --version
if errorlevel 1 (
    rem Install 7-Zip
    winget install 7zip.7zip --accept-source-agreements --accept-package-agreements
)

rem Extract bash package (two steps)
7z e bash-5.2.037-2-x86_64.pkg.tar.zst -y -o"%CD%"
7z x bash-5.2.037-2-x86_64.pkg.tar -y -o"%CD%"

rem Extract msys2-runtime package (two steps)
7z e msys2-runtime-3.4.10-5-x86_64.pkg.tar.zst -y -o"%CD%"
7z x msys2-runtime-3.4.10-5-x86_64.pkg.tar -y -o"%CD%"

rem Remove intermediate .tar files
del bash-5.2.037-2-x86_64.pkg.tar
del msys2-runtime-3.4.10-5-x86_64.pkg.tar

rem Move files from usr\bin to src\bin
xcopy /y /s ".\usr\bin\*" ".\src\bin\"

echo Done!
pause