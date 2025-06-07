param (
    [string]$bashexepath,
    [string]$kaliroot,
    [string]$echocommand,
    [string]$pkgcommand
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

function Convert-ToBashPath {
    param ([string]$path)
    $bashPath = $path.Replace('\', '/')
    # Replace drive letters with drive letters in Bash format
    if ($bashPath -match '^([A-Za-z]):/(.*)') {
        $drive = $matches[1].ToLower()
        $rest  = $matches[2]
        return "/$drive/$rest"
    }
    # Give the bash path back
    return $bashPath
}

function Convert-ToKaliPath {
    param ([string]$path)
    # Replace backslashes with slashes
    $kaliPath = $path.Replace('\', '/')
    # Replace occurrences of $kaliroot with /
    $kaliPath = $kaliPath.Replace("$kaliroot/", "/")
    return $kaliPath
}

function Get-OperatingSystem {
    Write-Host "Kali in Batch"
}

function Get-Kernel {
    Write-Host "KALI-IN-BATCH_WINNT"
}

function Get-Architecture {
    $architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
    Write-Host "$architecture"
}

function Get-UnameVersion {
    Write-Host "uname for Kali in Batch v3.3.2"
}

function Get-UnameHelp {
    Write-Host "Usage: uname [OPTION]..."
    Write-Host "OPTIONS:"
    Write-Host "  -a, --all: print all available information"
    Write-Host "  -o, --operating-system: print operating system name"
    Write-Host "  -s, --kernel-name, [no flag]: print kernel name"
    Write-Host "  -p,  --processor: print processor type"
    Write-Host "  --version: print uname version information"
    Write-Host "  -h, --help: display this help"
    Write-Host "====================================================="
    Write-Host "This uname is not associated with any other uname programs. It is a custom implementation of the uname command for Kali in Batch."
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
                if (Test-Path "$kaliroot\bin\$command.sh") {
                    # Execute the script
                    $bashBinPath = Convert-ToBashPath -path "$kaliroot\bin\$command.sh"
                    $substPath = (Get-Location).Path
                    # Workaround for WSL not mounting drives created with subst for some reason, which broke the elf-exec package
                    $substPath = $substPath.Replace("$kaliroot", "")
                    $substPath = Join-Path "$env:USERPROFILE\kali" "$substPath"
                    $bashPath = Convert-ToBashPath -path "$substPath"
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
                            $bashifiedHome = Convert-ToBashPath -path $homeDir
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
                        & $echocommand $shellargs
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
                        & $pkgcommand $shellargs
                        $commandSuccess = $?
                    }
                    'wsl' {
                        Write-Host "Please install the elf-exec package using pkg install elf-exec, then run it here by running: elf-exec"
                        $commandSuccess = $true
                    }
                    'uname' {
                        if ($shellargs.Count -eq 0) {
                            Get-Kernel
                            $commandSuccess = $true
                        } else {
                            if ($shellargs -eq '-a' -or $shellargs -eq '--all') {
                                Write-Host "OS: " -NoNewLine
                                Get-OperatingSystem
                                Write-Host "Kernel: " -NoNewLine
                                Get-Kernel
                                Write-Host "Architecture: " -NoNewLine
                                Get-Architecture
                                Write-Host "Version: " -NoNewLine
                                Get-UnameVersion
                                $commandSuccess = $true
                            }
                            if ($shellargs -eq '-o' -or $shellargs -eq '--operating-system') {
                                Get-OperatingSystem
                                $commandSuccess = $true
                            }
                            if ($shellargs -eq '-s' -or $shellargs -eq '--kernel-name') {
                                Get-Kernel
                                $commandSuccess = $true
                            }
                            if ($shellargs -eq '-p' -or $shellargs -eq '--processor') {
                                Get-Architecture
                                $commandSuccess = $true
                            }
                            if ($shellargs -eq '--version') {
                                Get-UnameVersion
                                $commandSuccess = $true
                            }
                            if ($shellargs -eq '-h' -or $shellargs -eq '--help') {
                                Get-UnameHelp
                                $commandSuccess = $true
                            }
                            # Check if the argument is unrecognized
                            if ($shellargs -ne '-a' -and $shellargs -ne '--all' -and $shellargs -ne '-o' -and $shellargs -ne '--operating-system' -and $shellargs -ne '-s' -and $shellargs -ne '--kernel-name' -and $shellargs -ne '-p' -and $shellargs -ne '--processor' -and $shellargs -ne '--version' -and $shellargs -ne '-h' -and $shellargs -ne '--help') {
                                Write-Host "Unrecognized argument: $shellargs"
                                Write-Host "Run uname --help for usage information."
                                $commandSuccess = $false
                            }
                        }
                    }
                    default {
                        if ($command -eq '') {
                            $commandSuccess = $true
                            continue
                        }

                        $bashPath = Convert-ToBashPath -path (Get-Location).Path
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
                                $bashifiedHome = Convert-ToBashPath -path $homeDir
                                $conv = $conv -replace '^~', $bashifiedHome
                            }

                            $convertedshellargs += $conv
                        }

                        $commandLine = "export HOME='$kaliroot/home/$env:USERNAME'; cd '$bashPath'; $command $($convertedshellargs -join ' ')"

                        if ($command -in 'ls', 'dir') {
                            $output = & $bashExe -c $commandLine
                            $output | ForEach-Object {
                                $_ -replace 'System\\ Volume\\ Information', '' `
                                   -replace '\$RECYCLE\.BIN', '' `
                                   -replace 'System Volume Information', '' `
                            } | ForEach-Object { $_.Trim() } | Where-Object { $_ } | ForEach-Object {
                                Write-Host $_
                            }
                            $commandSuccess = ($LASTEXITCODE -eq 0)
                        } else {
                            & $bashExe -c $commandLine
                            $commandSuccess = ($LASTEXITCODE -eq 0)
                        }
                    }
                }

                $success = $commandSuccess
            }
        }
    }
}

# Run the cmdlet
Get-Command