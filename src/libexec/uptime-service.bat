@echo off

rem uptime-service.bat
rem    * Uptime service for the KIB in Batch project.
rem    * Updates /proc/uptime
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

title /proc/uptime service

echo This window is the service that keeps /proc/uptime updated. Do not close this window!

setlocal enabledelayedexpansion

set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"

rem Get initial uptime once
for /f "tokens=1" %%i in ('powershell -NoProfile -Command "[math]::Round(((Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime).TotalSeconds)"') do set uptime=%%i

:loop

set "uptime_cpus="
set /a uptime_cpus = uptime * NUMBER_OF_PROCESSORS

echo !uptime! !uptime_cpus!>"!kibroot!\proc\uptime"

timeout /t 1 /nobreak >nul

set /a uptime+=1

goto loop
