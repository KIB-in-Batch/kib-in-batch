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

function Invoke-Pkg {
    param (
        [string[]]$PkgArgs,
        [string]$kaliroot
    )

    if (-not $PkgArgs -or $PkgArgs.Count -eq 0) {
        Write-Host "Usage: pkg (install/remove/upgrade/search/list)" -ForegroundColor $colorCyan
        return
    }

    $command = $PkgArgs[0]
    $package = if ($PkgArgs.Count -gt 1) { $PkgArgs[1] } else { $null }

    switch ($command) {
        'install' {
            if (-not $package) {
                Write-Host "Usage: pkg install package" -ForegroundColor $colorCyan
                return
            }

            Write-Host "Checking if package $package is installed..." -ForegroundColor $colorCyan

            $packagePath = Join-Path $kaliroot "bin\$package.sh"

            if (Test-Path $packagePath) {
                Write-Host "Package $package is already installed." -ForegroundColor $colorRed
                return
            }

            # Check if package exists on the server by downloading script and checking content
            $packageUrl = "https://codeberg.org/Kali-in-Batch/pkg/raw/branch/main/packages/$package/$package.sh"

            Write-Host "Downloading package script for $package to check availability..." -ForegroundColor $colorCyan
            try {
                $scriptContent = Invoke-WebRequest -Uri $packageUrl -UseBasicParsing -ErrorAction Stop | Select-Object -ExpandProperty Content
                Write-Host "First 100 chars of script:" -ForegroundColor $colorCyan
                Write-Host ($scriptContent.Substring(0, [Math]::Min(100, $scriptContent.Length))) -BackgroundColor $colorBlack
            } catch {
                Write-Host "Failed to download package $package." -ForegroundColor $colorRed
                return
            }

            if ($scriptContent.Trim() -eq "Not found.") {
                Write-Host "Package $package is not available." -ForegroundColor $colorRed
                return
            }

            # Check if the script contains rm -rf or curl
            if ($scriptContent -match 'rm -rf' -or $scriptContent -match 'curl' -or $scriptContent -match 'http') {
                Write-Host "Package $package contains potentially dangerous commands. Do you want to continue? (y/n)" -ForegroundColor $colorCyan
                $confirmation = Read-Host
                if ($confirmation -eq "y") {
                    Write-Host "Continuing with installation of package $package..." -ForegroundColor $colorCyan
                } else {
                    Write-Host "Installation of package $package canceled." -ForegroundColor $colorRed
                    return
                }
            }

            # Check if the script tries to interact with other drives like /c/ or tries to interact with browsers
            if ($scriptContent -match '/c/' -or $scriptContent -match 'chrome' -or $scriptContent -match 'firefox' -or $scriptContent -match 'C:' -or $scriptContent -match '/c') {
                Write-Host "Package $package is likely malicious. Aborting..." -ForegroundColor $colorRed
                Write-Host "Malicious lines:" -ForegroundColor $colorRed
                $maliciousLines = $scriptContent -split '\n' | Where-Object { $_ -match 'rm -rf' -or $_ -match 'curl' -or $_ -match 'http' -or $_ -match '/c/' -or $_ -match 'chrome' -or $_ -match 'firefox' -or $_ -match 'C:' }
                Write-Host $maliciousLines
                return
            }

            Write-Host "Package $package is available. Installing..." -ForegroundColor $colorCyan

            # Save the script to file
            try {
                $scriptContent | Out-File -FilePath $packagePath -Encoding UTF8
                Write-Host "Package $package installed. Execute it by running: pkg-exec $package" -ForegroundColor $colorGreen
            } catch {
                Write-Host "Failed to save package $package." -ForegroundColor $colorRed
            }
        }

        'remove' {
            if (-not $package) {
                Write-Host "Usage: pkg remove package" -ForegroundColor $colorCyan
                return
            }

            $packagePath = Join-Path $kaliroot "bin\$package.sh"

            Write-Host "Checking if package $package is installed..." -ForegroundColor $colorCyan

            if (Test-Path $packagePath) {
                Remove-Item $packagePath
                Write-Host "Package $package removed." -ForegroundColor $colorGreen
            } else {
                Write-Host "Package $package is not installed." -ForegroundColor $colorRed
            }
        }

        'upgrade' {
            if (-not $package) {
                Write-Host "Usage: pkg upgrade package" -ForegroundColor $colorCyan
                return
            }

            $packagePath = Join-Path $kaliroot "bin\$package.sh"
            $tempFile = Join-Path $kaliroot "tmp\output.txt"

            Write-Host "Checking if package $package is installed..." -ForegroundColor $colorCyan

            if (-not (Test-Path $packagePath)) {
                Write-Host "Package $package is not installed." -ForegroundColor $colorRed
                return
            }

            Write-Host "Checking if package is up to date..." -ForegroundColor $colorCyan

            $packageUrl = "https://codeberg.org/Kali-in-Batch/pkg/raw/branch/main/packages/$package/$package.sh"

            # Download latest package script
            Write-Host "Downloading latest package script for $package..." -ForegroundColor $colorCyan
            try {
                $latestContent = Invoke-WebRequest -Uri $packageUrl -UseBasicParsing -ErrorAction Stop | Select-Object -ExpandProperty Content
                Write-Host "First 100 chars of script:" -ForegroundColor $colorCyan
                Write-Host ($latestContent.Substring(0, [Math]::Min(100, $latestContent.Length))) -BackgroundColor $colorBlack
            } catch {
                Write-Host "Failed to download latest package $package." -ForegroundColor $colorRed
                return
            }

            if ($latestContent.Trim() -eq "Not found.") {
                Write-Host "Package $package is not available remotely." -ForegroundColor $colorRed
                return
            }

            # Check if the script contains rm -rf or curl
            if ($latestContent -match 'rm -rf' -or $latestContent -match 'curl' -or $latestContent -match 'http') {
                Write-Host "Package $package contains potentially dangerous commands. Do you want to continue? (y/n)" -ForegroundColor $colorCyan
                $confirmation = Read-Host
                if ($confirmation -eq "y") {
                    Write-Host "Continuing with installation of package $package..." -ForegroundColor $colorCyan
                } else {
                    Write-Host "Installation of package $package canceled." -ForegroundColor $colorRed
                    return
                }
            }

            # Check if the script tries to interact with other drives like /c/ or tries to interact with browsers
            if ($latestContent -match '/c/' -or $latestContent -match 'chrome' -or $latestContent -match 'firefox' -or $latestContent -match 'C:' -or $latestContent -match '/c') {
                Write-Host "Package $package is likely malicious. Aborting..." -ForegroundColor $colorRed
                Write-Host "Malicious lines:" -ForegroundColor $colorRed
                $maliciousLines = $latestContent -split '\n' | Where-Object { $_ -match 'rm -rf' -or $_ -match 'curl' -or $_ -match 'http' -or $_ -match '/c/' -or $_ -match 'chrome' -or $_ -match 'firefox' -or $_ -match 'C:' }
                Write-Host $maliciousLines
                return
            }

            $localCode = Get-Content $packagePath -Raw

            if ($latestContent -eq $localCode) {
                Write-Host "Package $package is up to date." -ForegroundColor $colorCyan
            } else {
                Write-Host "Upgrading package $package..." -ForegroundColor $colorCyan
                try {
                    $latestContent | Out-File -FilePath $packagePath -Encoding UTF8
                    Write-Host "Package $package upgraded." -ForegroundColor $colorGreen
                } catch {
                    Write-Host "Failed to save upgraded package $package." -ForegroundColor $colorRed
                }
            }

            Remove-Item $tempFile -ErrorAction SilentlyContinue
        }

        'search' {
            Write-Host "Opening package database in your browser..." -ForegroundColor $colorCyan
            Start-Process "https://codeberg.org/Kali-in-Batch/pkg/src/branch/main/packages/"
        }

        'list' {
            $binDir = Join-Path $kaliroot "bin"
            if (Test-Path $binDir) {
                Get-ChildItem -Path $binDir -Filter '*.sh' | ForEach-Object {
                    $_.BaseName
                }
            } else {
                Write-Host "No packages installed." -ForegroundColor $colorCyan
            }
        }

        default {
            Write-Host "Unknown command: $command" -ForegroundColor $colorRed
            Write-Host "Usage: pkg (install/remove/upgrade/search/list)" -ForegroundColor $colorCyan
        }
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
    Write-Host "uname for Kali in Batch v3.0.1"
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
            $kalipathtwo = "/"
        }
        $kaliPaththree = "$kaliPath"
        if ($kaliPaththree -eq "$kaliroot") {
            $kaliPaththree = "/"
        }
        # Replace /home/$env:USERNAME in kalipathtwo with ~
        $kaliPathtwo = $kaliPathtwo.Replace("/home/$env:USERNAME", "~")
        # Set title to kali path
        $host.ui.RawUI.WindowTitle = "Kali in Batch - $kaliPath"
        Write-Host "$env:USERNAME@$env:COMPUTERNAME" -ForegroundColor $colorRed -NoNewline
        Write-Host ":" -NoNewline
        Write-Host "$kaliPathtwo" -NoNewline -ForegroundColor $colorBlue
        Write-Host "$ " -NoNewline

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
                $args = if ($tokens.Count -gt 1) { $tokens[1..($tokens.Count - 1)] } else { @() }

                $commandSuccess = $false

                switch ($command) {
                    'exit' {
                        exit
                        $commandSuccess = $true
                    }
                    'echo' {
                        Write-Host $args
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
                        $cdPath = "$args"
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
                        Invoke-Pkg -PkgArgs $args -kaliroot $kaliroot
                        $commandSuccess = $?
                    }
                    'pkg-exec' {
                        if (Test-Path "$kaliroot\bin\$args.sh") {
                            $bashBinPath = Convert-ToBashPath -path "$kaliroot\bin\$args.sh"
                            $bashExe = $bashexepath
                            $bashPath = Convert-ToBashPath -path (Get-Location).Path
                            & "$bashExe" -c "cd $bashPath; source $bashBinPath"
                            $commandSuccess = ($LASTEXITCODE -eq 0)
                        } else {
                            Write-Host "Package not found: $args"
                            $commandSuccess = $false
                        }
                    }
                    'wsl' {
                        Write-Host "Please install the elf-exec package using pkg install elf-exec, then run it here by doing pkg-exec elf-exec."
                        $commandSuccess = $true
                    }
                    'uname' {
                        if ($args.Count -eq 0) {
                            Get-Kernel
                            $commandSuccess = $true
                        } else {
                            if ($args -eq '-a' -or $args -eq '--all') {
                                Write-Host "OS: " -NoNewline
                                Get-OperatingSystem
                                Write-Host "Kernel: " -NoNewline
                                Get-Kernel
                                Write-Host "Architecture: " -NoNewline
                                Get-Architecture
                                Write-Host "Version: " -NoNewline
                                Get-UnameVersion
                                $commandSuccess = $true
                            }
                            if ($args -eq '-o' -or $args -eq '--operating-system') {
                                Get-OperatingSystem
                                $commandSuccess = $true
                            }
                            if ($args -eq '-s' -or $args -eq '--kernel-name') {
                                Get-Kernel
                                $commandSuccess = $true
                            }
                            if ($args -eq '-p' -or $args -eq '--processor') {
                                Get-Architecture
                                $commandSuccess = $true
                            }
                            if ($args -eq '--version') {
                                Get-UnameVersion
                                $commandSuccess = $true
                            }
                            if ($args -eq '-h' -or $args -eq '--help') {
                                Get-UnameHelp
                                $commandSuccess = $true
                            }
                            # Check if the argument is unrecognized
                            if ($args -ne '-a' -and $args -ne '--all' -and $args -ne '-o' -and $args -ne '--operating-system' -and $args -ne '-s' -and $args -ne '--kernel-name' -and $args -ne '-p' -and $args -ne '--processor' -and $args -ne '--version' -and $args -ne '-h' -and $args -ne '--help') {
                                Write-Host "Unrecognized argument: $args"
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
                        $convertedArgs = @()

                        foreach ($arg in $args) {
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

                            $convertedArgs += $conv
                        }

                        $commandLine = "cd '$bashPath'; $command $($convertedArgs -join ' ')"

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