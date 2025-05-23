@echo off

rmdir /s /q "%APPDATA%\kali_in_batch"
rmdir /s /q "C:\Users\%USERNAME%\kali"
echo Uninstallation complete. Press any key to exit...
pause >nul
exit