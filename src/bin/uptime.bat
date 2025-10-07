@echo off

setlocal enabledelayedexpansion

rem uptime.bat
rem    * uptime reimplementation for the KIB in Batch project.
rem    * Prints the current uptime.
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

set "hh="
set "mm="
set "ss="
set "seconds="

for /f "tokens=1-4 delims=,.:" %%a in ("%TIME%") do (
    set "hh=%%a"
    set "mm=%%b"
    set "ss=%%c"
)

set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"

set /p uptime_file=<"!kibroot!\proc\uptime"

for /f "tokens=1" %%a in ("!uptime_file!") do (
    set "seconds=%%a"
)

if "!seconds!"=="60" (
    set "minutes=1 min"
) else if "!seconds!" gtr 60 (
    set /a minutes = seconds / 60
    set "minutes=!minutes! min"
) else (
    set "minutes=!seconds! sec"
)

echo  !hh!:!mm!:!ss! up !minutes!,  load average: 0.00, 0.00, 0.00
