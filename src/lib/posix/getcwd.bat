@echo off
chcp 65001 >nul

rem getcwd.bat
rem    * getcwd API reimplementation for the Kali in Batch project.
rem    * Usage: getcwd
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

rem Color Definitions
set "COLOR_RESET=[0m"
set "COLOR_BLACK=[30m"
set "COLOR_RED=[31m"
set "COLOR_GREEN=[32m"
set "COLOR_YELLOW=[33m"
set "COLOR_BLUE=[34m"
set "COLOR_MAGENTA=[35m"
set "COLOR_CYAN=[36m"
set "COLOR_WHITE=[37m"
set "COLOR_BRIGHT_BLACK=[90m"
set "COLOR_BRIGHT_RED=[91m"
set "COLOR_BRIGHT_GREEN=[92m"
set "COLOR_BRIGHT_YELLOW=[93m"
set "COLOR_BRIGHT_BLUE=[94m"
set "COLOR_BRIGHT_MAGENTA=[95m"
set "COLOR_BRIGHT_CYAN=[96m"
set "COLOR_BRIGHT_WHITE=[97m"

rem Background Colors
set "COLOR_BG_BLACK=[40m"
set "COLOR_BG_RED=[41m"
set "COLOR_BG_GREEN=[42m"
set "COLOR_BG_YELLOW=[43m"
set "COLOR_BG_BLUE=[44m"
set "COLOR_BG_MAGENTA=[45m"
set "COLOR_BG_CYAN=[46m"
set "COLOR_BG_WHITE=[47m"
set "COLOR_BG_BRIGHT_BLACK=[100m"
set "COLOR_BG_BRIGHT_RED=[101m"
set "COLOR_BG_BRIGHT_GREEN=[102m"
set "COLOR_BG_BRIGHT_YELLOW=[103m"
set "COLOR_BG_BRIGHT_BLUE=[104m"
set "COLOR_BG_BRIGHT_MAGENTA=[105m"
set "COLOR_BG_BRIGHT_CYAN=[106m"
set "COLOR_BG_BRIGHT_WHITE=[107m"

rem Text Styles
set "COLOR_BOLD=[1m"
set "COLOR_DIM=[2m"
set "COLOR_ITALIC=[3m"
set "COLOR_UNDERLINE=[4m"
set "COLOR_BLINK=[5m"
set "COLOR_REVERSE=[7m"
set "COLOR_HIDDEN=[8m"
set "COLOR_STRIKETHROUGH=[9m"

rem Combined Styles
set "COLOR_ERROR=%COLOR_BRIGHT_RED%%COLOR_BOLD%"
set "COLOR_WARNING=%COLOR_BRIGHT_YELLOW%%COLOR_BOLD%"
set "COLOR_SUCCESS=%COLOR_BRIGHT_GREEN%%COLOR_BOLD%"
set "COLOR_INFO=%COLOR_BRIGHT_CYAN%%COLOR_BOLD%"
set "COLOR_DEBUG=%COLOR_BRIGHT_MAGENTA%%COLOR_BOLD%"
set "COLOR_PROMPT=%COLOR_BRIGHT_BLUE%%COLOR_BOLD%"

rem The original POSIX API is used like this:
rem    char *getcwd(char *buf, size_t size);
rem The Batch API is used like this:
rem    getcwd
rem The Batch API is not meant to be used standalone, but rather through unistd.h.

rem Check argument count: getcwd expects 0 args
set argcount=0
for %%i in (%*) do (
    set /a argcount+=1
)
if %argcount% neq 0 (
    echo %COLOR_ERROR%error:%COLOR_RESET% getcwd takes no arguments, use the wrapper in unistd.h in a C file for arguments%COLOR_RESET%
    echo %COLOR_ERROR%%~0%COLOR_RESET% %*
    echo %COLOR_ERROR%^^~~~%COLOR_RESET%
    exit /b 1
)

rem Store %cd% with backslashes converted to slashes in cwd

set "cwd=%cd:/=\%"

echo %cwd%

exit /b 0
