@echo off

set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"

echo Deleting %APPDATA%\kib_in_batch...
rmdir /s /q "%APPDATA%\kib_in_batch"
choice /c yn /n /m "Do you want to back up %kibroot%\home\%USERNAME% to %USERPROFILE%\kalihome.bak.d\? WE STRONGLY RECOMMEND YOU DO THIS. Type 'y' to back up, or 'n' to skip."
if %errorlevel%==1 (
    echo Backing up %kibroot%\home\%USERNAME%\ to %USERPROFILE%\kalihome.bak.d\...
    rem Create the backup directory if it doesn't exist
    if not exist "%USERPROFILE%\kalihome.bak.d\" mkdir "%USERPROFILE%\kalihome.bak.d"
    rem Copy all files with xcopy
    robocopy "%kibroot%\home\%USERNAME%" "%USERPROFILE%\kalihome.bak.d" /E /COPY:DATS /R:0 /W:0 /NFL /NDL /NJH /NJS /NP
    echo Back up complete. This will automatically be restored if you reinstall KIB in Batch.
)

echo Deleting %kibroot%\...

subst %kibroot% /d >nul 2>&1

echo Deleting %USERPROFILE%\kib...
rmdir /s /q "%USERPROFILE%\kib"

echo Uninstallation complete. Press any key to exit...
pause >nul
exit /b
