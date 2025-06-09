param (
    [string]$bashexepath,
    [string]$kaliroot
)

# Replace backslashes with slashes in $kaliroot
$kaliroot = $kaliroot.Replace('\', '/')

$colorGreen = 'Green'
$colorBlue = 'Blue'
$colorCyan = 'Cyan'
$colorRed = 'Red'
$colorBlack = 'Black'

<# shell_prompt.ps1
    * Shell prompt for the Kali in Batch project.
    * Called from kali_in_batch.bat
    * License:

======================================================================================
MIT License

Copyright (c) 2025 benja2998

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
=======================================================================================
#>

chcp 65001 >$null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Read-ShellPrompt {
    param (
        [string]$kaliPathtwo
    )
    # See if $kaliroot\home\$env:USERNAME\.kibprompt exists
    $promptFile = Join-Path $kaliroot "home\$env:USERNAME\.kibprompt"
    if (Test-Path $promptFile) {
        # For writing .kibprompt files, just use powershell syntax.
        # To get current path, use $kaliPathtwo
        Get-Content $promptFile | ForEach-Object {
            Invoke-Expression $_
        }
    } else {
        # Write the default prompt
        Write-Host "$env:USERNAME@$env:COMPUTERNAME" -ForegroundColor $colorRed -NoNewLine
        Write-Host ":" -NoNewLine
        Write-Host "$kaliPathtwo" -NoNewLine -ForegroundColor $colorBlue
        Write-Host "$ " -NoNewLine
    }
}

function Convert-ToKaliPath {
    param ([string]$path)
    # Replace backslashes with slashes
    $kaliPath = $path.Replace('\', '/')
    # Replace occurrences of $kaliroot with /
    $kaliPath = $kaliPath.Replace("$kaliroot/", "/")
    return $kaliPath
}

function Convert-ToWindowsPath {
    param ([string]$path)
    # Replace slashes with backslashes
    $windowsPath = $path.Replace('/', '\')
    # If the first character is a slash, replace that with $kaliroot
    if ($windowsPath[0] -eq '\') {
        $windowsPath = "$kaliroot\$windowsPath"
    }
    return $windowsPath
}

function Convert-ShellArgs {
    param (
        [string[]]$shellargs
    )
    # Loop for every word in $shellargs
    $convertedshellargs = @()
    foreach ($arg in $shellargs) {
        # Check if the first two characters of $arg are a drive letter
        if ($arg -match '^[A-Za-z]:') {
            Write-Host "Cannot list Windows path: $arg"
            return 1
            continue
        }
        if ($arg -match '^/') {
            $arg = "$kaliroot$arg" -replace '//+', '/'
        }
        if ($arg -match '^~') {
            $homeDir = "$kaliroot\home\$env:USERNAME"
            $arg = $homeDir + $arg.Substring(1)
        }
        $arg.Replace('/', '\')
        $convertedshellargs += $arg
    }
    return $convertedshellargs
}

function Get-Command {
    while ($true) {
        $windowsPath = (Get-Location).Path
        $kaliPath = Convert-ToKaliPath -path (Get-Location).Path
        $kaliPathtwo = "$kaliPath"
        if ($kaliPathtwo -eq "$kaliroot") {
            $kaliPathtwo = "/"
        }
        $kaliPaththree = "$kaliPath"
        if ($kaliPaththree -eq "$kaliroot") {
            $kaliPaththree = "/"
        }
        # Replace /home/$env:USERNAME in kalipathtwo with ~
        $kaliPathtwo = $kaliPathtwo.Replace("/home/$env:USERNAME", "~")
        # Set title to kali path
        $host.ui.RawUI.WindowTitle = "Kali in Batch - $kaliPath"
        Read-ShellPrompt -kaliPathtwo $kaliPathtwo

        $inputLine = Read-Host

        # Split the input line into command groups separated by ';'
        $commandGroups = $inputLine -split ';'

        foreach ($group in $commandGroups) {
            $group = $group.Trim()
            if (-not $group) { continue }

            # Split each group into subcommands separated by '&&' and '&'
            $subCommands = $group -split '\s*&&\s*'
            $subCommands = $subCommands -split '\s*&\s*'
            $success = $true

            foreach ($subCmd in $subCommands) {
                if (-not $success) { break }

                $tokens = $subCmd.Trim() -split '\s+'
                if ($tokens.Count -eq 0) { continue }

                $command = $tokens[0]
                $shellargs = if ($tokens.Count -gt 1) { $tokens[1..($tokens.Count - 1)] } else { @() }

                $commandSuccess = $false

                # Check if $kaliroot\bin\$command.sh exists
                if (Test-Path "$kaliroot\usr\bin\$command.sh") {
                    # Execute the script
                    $bashBinPath = Convert-ToKaliPath -path "$kaliroot\usr\bin\$command.sh"
                    $substPath = (Get-Location).Path
                    # Workaround for WSL not mounting drives created with subst for some reason, which broke the elf-exec package
                    $substPath = $substPath.Replace("$kaliroot", "")
                    $substPath = Join-Path "$env:USERPROFILE\kali" "$substPath"
                    $bashPath = Convert-ToKaliPath -path "$substPath"
                    $bashExe = $bashexepath
                    $convertedshellargs = @()

                    foreach ($arg in $shellargs) {
                        if ($arg -match '^[A-Za-z]:') {
                            Write-Host "Cannot access Windows path: $arg" -ForegroundColor $colorRed
                            $commandSuccess = $false
                            continue
                        }

                        $conv = $arg.Replace('\', '/')

                        if ($conv -match '^/') {
                            $conv = "$kaliroot$conv" -replace '//+', '/'
                        }

                        if ($conv -match '^~') {
                            $homeDir = "$kaliroot\home\$env:USERNAME"
                            $bashifiedHome = Convert-ToKaliPath -path $homeDir
                            $conv = $conv -replace '^~', $bashifiedHome
                        }

                        $convertedshellargs += $conv
                    }

                    $commandLine = "export HOME='$kaliroot/home/$env:USERNAME'; cd '$bashPath'; source $bashBinPath $convertedshellargs"
                    & $bashExe -c $commandLine
                    # Avoid running the switch statements
                    $commandSuccess = $?
                    continue
                }
                switch ($command) {
                    'exit' {
                        exit $shellargs
                        $commandSuccess = $?
                    }
                    'echo' {
                        & $kaliroot/usr/bin/echo.bat $shellargs
                        $commandSuccess = $?
                    }
                    'clear' {
                        Clear-Host
                        $commandSuccess = $?
                    }
                    'pwd' {
                        Write-Host $kaliPaththree
                        $commandSuccess = $?
                    }
                    'cd' {
                        $cdPath = "$shellargs"
                        $kalirootwin = $kaliroot.Replace('/', '\')

                        if ($cdPath -match '\.\.') {
                            # Check if this .. equals to changing to C:\Users\$env:USERNAME
                            $cdPathtest = Convert-Path (Join-Path $windowsPath "$cdPath")
                            # Check if $cdPathtest doesn't start with $kalirootwin
                            if ($cdPathtest.StartsWith($kalirootwin)) {
                                # Don't do anything
                            } else {
                                Write-Host "Cannot change directory to Windows path: $cdPathtest"
                                $commandSuccess = $false
                                continue
                            }
                        }
                        if ($cdPath -match '^[A-Za-z]:') {
                            Write-Host "Cannot change directory to Windows path: $cdPath"
                            $commandSuccess = $false
                            continue
                        }

                        if ($cdPath -match '^/') {
                            $cdPath = "$kaliroot$cdPath" -replace '//+', '/'
                        }

                        if ($cdPath -match '^~') {
                            $homeDir = "$kaliroot\home\$env:USERNAME"
                            $cdPath = $homeDir + $cdPath.Substring(1)
                        }

                        if ($cdPath -eq '') {
                            $cdPath = "$kaliroot\home\$env:USERNAME"
                        }

                        $cdPath = $cdPath.Replace('/', '\')

                        try {
                            Set-Location -Path $cdPath -ErrorAction Stop
                            $commandSuccess = $true
                        } catch {
                            Write-Host "Error changing directory: $_" -ForegroundColor $colorRed
                            $commandSuccess = $false
                        }
                    }
                    'pkg' {
                        & "$kaliroot\usr\bin\pkg.bat" $shellargs
                        $commandSuccess = $?
                    }
                    'wsl' {
                        Write-Host "Please install the elf-exec package using pkg install elf-exec, then run it here by running: elf-exec"
                        $commandSuccess = $true
                    }
                    'uname' {
                        & "$kaliroot\usr\bin\uname.bat" $shellargs
                        $commandSuccess = $?
                    }
                    'whoami' {
                        & "$kaliroot\usr\bin\whoami.bat"
                        $commandSuccess = $?
                    }
                    'touch' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\touch.bat" $convertedshellargs
                        $commandSuccess = $?
                    }
                    'wget' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" wget $convertedshellargs
                        $commandSuccess = $?
                    }
                    'ls' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot/usr/bin/ls.bat" $convertedshellargs
                        $commandSuccess = $?
                    }
                    'whois' {
                        & "$kaliroot\usr\bin\busybox.exe" whois $convertedshellargs
                        $commandSuccess = $?
                    }
                    'nc' {
                        # It wouldn't be acceptable to make a Kali Linux environment without netcat.

                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" nc $convertedshellargs
                        $commandSuccess = $?
                    }
                    'netcat' {
                        # It wouldn't be acceptable to make a Kali Linux environment without netcat.

                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" nc $convertedshellargs
                        $commandSuccess = $?
                    }
                    'printf' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" printf $convertedshellargs
                        $commandSuccess = $?
                    }
                    'awk' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" awk $convertedshellargs
                        $commandSuccess = $?
                    }
                    'sed' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" sed $convertedshellargs
                        $commandSuccess = $?
                    }
                    'grep' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" grep $convertedshellargs
                        $commandSuccess = $?
                    }
                    'find' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" find $convertedshellargs
                        $commandSuccess = $?
                    }
                    'tee' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" tee $convertedshellargs
                        $commandSuccess = $?
                    }
                    'which' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" which $convertedshellargs
                        $commandSuccess = $?
                    }
                    'dir' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot/usr/bin/ls.bat" $convertedshellargs
                        $commandSuccess = $?
                    }
                    'cat' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\cat.bat" $convertedshellargs
                        $commandSuccess = $?
                    }
                    'ps' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" ps $convertedshellargs
                        $commandSuccess = $?
                    }
                    'kill' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" kill $convertedshellargs
                        $commandSuccess = $?
                    }
                    'killall' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" killall $convertedshellargs
                        $commandSuccess = $?
                    }
                    'pkill' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" pkill $convertedshellargs
                        $commandSuccess = $?
                    }
                    'rm' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" rm $convertedshellargs
                        $commandSuccess = $?
                    }
                    'rmdir' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" rmdir $convertedshellargs
                        $commandSuccess = $?
                    }
                    'mkdir' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" mkdir $convertedshellargs
                        $commandSuccess = $?
                    }
                    'cp' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" cp $convertedshellargs
                        $commandSuccess = $?
                    }
                    'mv' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" mv $convertedshellargs
                        $commandSuccess = $?
                    }
                    'ln' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" ln $convertedshellargs
                        $commandSuccess = $?
                    }
                    'chmod' {
                        $convertedshellargs = Convert-ShellArgs -shellArgs $shellargs

                        & "$kaliroot\usr\bin\busybox.exe" chmod $convertedshellargs
                        $commandSuccess = $?
                    }
                    default {
                        if ($command -eq '') {
                            $commandSuccess = $true
                            continue
                        }

                        $bashPath = Convert-ToKaliPath -path (Get-Location).Path
                        $bashExe = $bashexepath
                        $convertedshellargs = @()

                        foreach ($arg in $shellargs) {
                            if ($arg -match '^[A-Za-z]:') {
                                Write-Host "Cannot access Windows path: $arg" -ForegroundColor $colorRed
                                $commandSuccess = $false
                                continue
                            }

                            $conv = $arg.Replace('\', '/')

                            if ($conv -match '^/') {
                                $conv = "$kaliroot$conv" -replace '//+', '/'
                            }

                            if ($conv -match '^~') {
                                $homeDir = "$kaliroot\home\$env:USERNAME"
                                $bashifiedHome = Convert-ToKaliPath -path $homeDir
                                $conv = $conv -replace '^~', $bashifiedHome
                            }

                            $convertedshellargs += $conv
                        }

                        $commandLine = "export HOME='$kaliroot/home/$env:USERNAME'; cd '$bashPath'; $command $($convertedshellargs -join ' ')"
                        
                        & $bashExe -c $commandLine
                        $commandSuccess = ($LASTEXITCODE -eq 0)
                    }
                }

                $success = $commandSuccess
            }
        }
    }
}

# Run the cmdlet
Get-Command