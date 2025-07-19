@echo off
setlocal enabledelayedexpansion

rem setup.bat
rem    * Setup script for the Kali in Batch project.
rem    * Bundles binaries for proper functionality.
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

rem Download busybox64u.exe as busybox.exe
echo Downloading busybox64u.exe...
curl -L -o "%~dp0busybox.exe" "https://frippery.org/files/busybox/busybox64u.exe" -#

rem Make sure src\bin exists
if not exist "%~dp0src\bin\" mkdir "%~dp0src\bin\"

rem Move busybox.exe to src\bin
move /y "%~dp0busybox.exe" "%~dp0src\bin\busybox.exe"

echo Done!
