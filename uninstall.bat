@echo off

set /p kaliroot=<"%APPDATA%\kali_in_batch\kaliroot.txt"

echo Deleting %APPDATA%\kali_in_batch...
rmdir /s /q "%APPDATA%\kali_in_batch"
choice /c yn /n /m "Do you want to back up %kaliroot%\home\%USERNAME% to %USERPROFILE%\kalihome.bak.d\? WE STRONGLY RECOMMEND YOU DO THIS. Type 'y' to back up, or 'n' to skip."
if %errorlevel%==1 (
    echo Backing up %kaliroot%\home\%USERNAME%\ to %USERPROFILE%\kalihome.bak.d\...
    rem Create the backup directory if it doesn't exist
    if not exist "%USERPROFILE%\kalihome.bak.d\" mkdir "%USERPROFILE%\kalihome.bak.d"
    rem Copy all files with xcopy
    xcopy /s /i /h /y "%kaliroot%\home\%USERNAME%\*" "%USERPROFILE%\kalihome.bak.d\"
    echo Back up complete. This will automatically be restored if you reinstall Kali in Batch.
)

echo Deleting %kaliroot%\...

subst %kaliroot% /d >nul 2>&1

echo Deleting %USERPROFILE%\kali...
rmdir /s /q "%USERPROFILE%\kali"

echo Uninstallation complete. Press any key to exit...
pause >nul
exit /b
