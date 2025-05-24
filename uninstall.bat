@echo off

subst
set /p "driveletter=Virtual drives listed. Please enter the virtual drive used for Kali in Batch with a colon (e.g. Z:). Leave blank if none >> "
if "%driveletter%"=="" goto skip_subst
echo Deleting %driveletter%...
subst %driveletter% /d
goto skip_subst
:skip_subst
echo Deleting %APPDATA%\kali_in_batch...
rmdir /s /q "%APPDATA%\kali_in_batch"
echo Deleting C:\Users\%USERNAME%\kali...
rmdir /s /q "C:\Users\%USERNAME%\kali"
echo Uninstallation complete. Press any key to exit...
pause >nul
exit