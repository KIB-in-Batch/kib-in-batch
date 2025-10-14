@echo off

rem pkg.bat
rem    * Package manager for the KIB in Batch project.
rem    * Wrapper for kib-pkg.
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

rem Fetch kibroot

set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"

rem Run kib-pkg

echo %COLOR_WARNING%WARNING%COLOR_RESET%: This wrapper is only kept for backward compatibility.
echo We recommend you run %COLOR_ITALIC%kib-pkg%COLOR_RESET% or %COLOR_ITALIC%kpkg%COLOR_RESET% instead.
echo %COLOR_ITALIC%kpkg%COLOR_RESET% is a wrapper for %COLOR_ITALIC%kib-pkg%COLOR_RESET%, but it is only for convenience, not backward compatibility that
echo may be removed in the future.
echo.

"%kibroot%\usr\bin\kib-pkg.bat" %*
