@echo off

rem Usage:
rem
rem call C:\path\to\colors.bat
rem
rem Then use any of the color variables defined.

set HASCOLORS=0

if defined ConEmuPID (
    set HASCOLORS=1
)

if defined WT_SESSION (
    set HASCOLORS=1
)

if defined MSYSTEM (
    set HASCOLORS=1
)

if %HASCOLORS%==1 (
    rem Ensure compatibility with older Windows builds by enabling ANSI escape codes manually

    reg add "HKCU\Console" /f >nul 2>&1

    reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

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
    set "COLOR_ERROR=[91m[1m"
    set "COLOR_WARNING=[93m[1m"
    set "COLOR_SUCCESS=[92m[1m"
    set "COLOR_INFO=[96m[1m"
    set "COLOR_DEBUG=[95m[1m"
    set "COLOR_PROMPT=[94m[1m"
) else (
    echo Warning: No color support. Please use a terminal that supports colors.
    echo Press any key to continue...
    pause >nul
)
