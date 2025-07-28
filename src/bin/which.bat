@echo off

rem which.bat
rem    * "Which" reimplementation for the Kali in Batch project.
rem    * Wrapper for "where"
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


setlocal enabledelayedexpansion

set "is_flag=false"
set "show_all=false"

rem Loop for each argument

for %%a in (%*) do (
    set "arg=%%a"
    set "first_char=!arg:~0,1!"

    if "!arg!"=="-a" (
        set "show_all=true"
    ) else if "!arg!"=="--all" (
        set "show_all=true"
    ) else if "!arg!"=="--help" (
        echo Usage: %~0 [options] [--] COMMAND [..]
        echo Write the full path of COMMAND^(s^) to standard output.
        echo.
        echo    --version, -[vV]           Print version and exit successfully.          
        echo    --help,                    Print this help and exit successfully.
        echo    --all, -a                  Print all matches in PATH, not just the first
        echo.
        echo Consider contributing to this project as this is an incomplete which implementation.
        exit /b 0
    ) else if "!arg!"=="--version" (
        echo which for Kali in Batch 9.3
        echo This is GPL-2.0-only licensed free software. There is NO WARRANTY.
    ) else if "!arg!"=="-v" (
        echo which for Kali in Batch 9.3
        echo This is GPL-2.0-only licensed free software. There is NO WARRANTY.
    ) else if "!arg!"=="-V" (
        echo which for Kali in Batch 9.3
        echo This is GPL-2.0-only licensed free software. There is NO WARRANTY.
    )
)

for %%a in (%*) do (
    set "arg=%%a"
    set "first_char=!arg:~0,1!"
    if "!first_char!"=="-" (
        set "is_flag=true"
    )

    if not "!arg!"=="" (
        where "!arg!">"%TEMP%\out.txt" 2>>"%APPDATA%\kali_in_batch\errors.log"
        copy /y "%TEMP%\out.txt" "%TEMP%\out2.txt" >nul 2>>"%APPDATA%\kali_in_batch\errors.log"
        del /s /q "%TEMP%\out.txt" >nul 2>>"%APPDATA%\kali_in_batch\errors.log"
        rem Replace backslashes with forward slashes in out.txt
        for /f "tokens=* delims=" %%i in ('type "%TEMP%\out2.txt"') do (
            set "line=%%i"
            rem Replace backslashes with forward slashes
            set "line=!line:\=/!"
            echo !line! >>"%TEMP%\out.txt"
        )
        del /s /q "%TEMP%\out2.txt" >nul 2>>"%APPDATA%\kali_in_batch\errors.log"
        where "!arg!" >nul 2>>"%APPDATA%\kali_in_batch\errors.log"
        if errorlevel 1 (
            if "!is_flag!"=="false" (
                <nul set /p "=%~0: no !arg! in !PATH!"
                echo.
            )
        ) else (
            if "!show_all!"=="true" (
                type "%TEMP%\out.txt"
            ) else (
                set firstline=
                for /f "usebackq delims=" %%b in ("%TEMP%\out.txt") do (
                    if not defined firstline (
                        set "firstline=%%b"
                    )
                )
                echo !firstline!
            )
        )
        del /s /q "%TEMP%\out.txt" >nul 2>>"%APPDATA%\kali_in_batch\errors.log"
    )
    set "is_flag=false"
)
