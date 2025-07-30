@echo off

set /p kaliroot=<"%APPDATA%\kali_in_batch\kaliroot.txt"

echo Deleting %kaliroot%\...

subst %kaliroot% /d >nul 2>&1

echo Deleting %APPDATA%\kali_in_batch...
rmdir /s /q "%APPDATA%\kali_in_batch"
echo Deleting %USERPROFILE%\kali...
rmdir /s /q "%USERPROFILE%\kali"
echo Uninstallation complete. Press any key to exit...
pause >nul
exit /b
