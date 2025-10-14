@echo off

chcp 65001 >nul

rem kibfetch.bat
rem    * Neofetch-like program for the KIB in Batch project.
rem    * Displays thorough system info with an ASCII banner.
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

call "%USERPROFILE%\colors.bat"

if not defined USER (
    set "USER=%USERNAME%"
)

rem Fetch kibroot

set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"

echo ██   ██ ██ ██████         %COLOR_DEBUG%%USER%%COLOR_RESET%@%COLOR_DEBUG%%COMPUTERNAME%%COLOR_RESET%
echo ██  ██  ██ ██   ██        -------------------------------
echo █████   ██ ██████         %COLOR_DEBUG%OS%COLOR_RESET%: KIB in Batch 11.0.0-untagged
echo ██  ██  ██ ██   ██        %COLOR_DEBUG%Kernel%COLOR_RESET%: KIB_%OS%
echo ██   ██ ██ ██████         %COLOR_DEBUG%KIB in Batch Root%COLOR_RESET%: %kibroot%/
echo                           %COLOR_DEBUG%CPU Architecture%COLOR_RESET%: %PROCESSOR_ARCHITECTURE%
echo                           %COLOR_DEBUG%CPU Level%COLOR_RESET%: %PROCESSOR_LEVEL%
echo                           %COLOR_DEBUG%Number of CPU cores%COLOR_RESET%: %NUMBER_OF_PROCESSORS%
echo                           %COLOR_DEBUG%CPU Revision%COLOR_RESET%: %PROCESSOR_REVISION%
echo.
