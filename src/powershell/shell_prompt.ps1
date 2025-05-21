param (
    [string]$bashexepath,
    [string]$installpart
)

$colorGreen = 'Green'
$colorBlue = 'Blue'
$colorCyan = 'Cyan'
$colorRed = 'Red'
$colorBlack = 'Black'
$colorReset = 'White'

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
        [string]$InstallPart
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

            $packagePath = Join-Path $InstallPart "bin\$package.sh"

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
                Write-Host ($scriptContent.Substring(0, [Math]::Min(100, $scriptContent.Length))) -ForegroundColor $colorReset -BackgroundColor $colorBlack
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

            $packagePath = Join-Path $InstallPart "bin\$package.sh"

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

            $packagePath = Join-Path $InstallPart "bin\$package.sh"
            $tempFile = Join-Path $InstallPart "tmp\output.txt"

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
                Write-Host ($latestContent.Substring(0, [Math]::Min(100, $latestContent.Length))) -ForegroundColor $colorReset -BackgroundColor $colorBlack
            } catch {
                Write-Host "Failed to download latest package $package." -ForegroundColor $colorRed
                return
            }

            if ($latestContent.Trim() -eq "Not found.") {
                Write-Host "Package $package is not available remotely." -ForegroundColor $colorRed
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
            $binDir = Join-Path $InstallPart "bin"
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
    # If it starts with DriveLetter + colon + slash, remove drive letter and colon, add leading slash
    if ($kaliPath -match '^([A-Za-z]):/(.*)') {
        $rest = $matches[2]
        return "/$rest"
    }
    # 
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
    Write-Host "uname for Kali in Batch v2.1.0"
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
        $kaliPath = Convert-ToKaliPath -path (Get-Location).Path
        # Set title to kali path
        $host.ui.RawUI.WindowTitle = "Kali in Batch - $kaliPath"
        Write-Host '╔══(' -NoNewline -ForegroundColor $colorGreen
        Write-Host "$env:USERNAME@$env:COMPUTERNAME" -NoNewline -ForegroundColor $colorBlue
        Write-Host ')-[' -NoNewline -ForegroundColor $colorGreen
        Write-Host $kaliPath -NoNewline -ForegroundColor $colorReset
        Write-Host ']' -ForegroundColor $colorGreen
        Write-Host '╚══' -NoNewline -ForegroundColor $colorGreen
        Write-Host '$ ' -ForegroundColor $colorBlue -NoNewline

        $inputLine = Read-Host

        # Parse the input line into command and arguments
        $tokens = $inputLine -split '\s+'
        $command = if ($tokens.Count -gt 0) { $tokens[0] } else { '' }
        $args = if ($tokens.Count -gt 1) { $tokens[1..($tokens.Count - 1)] } else { @() }

        # Execute the command
        switch ($command) {
            'exit' {
                exit
            }
            'echo' {
                Write-Host $args
            }
            'clear' {
                Clear-Host
            }
            'pwd' {
                Write-Host $kaliPath
            }
            'cd' {
                $cdPath = "$args"
                # Block Windows paths by checking if the second character is a colon
                if ($cdPath -match '^[A-Za-z]:') {
                    Write-Host "Cannot change directory to Windows path: $cdPath"
                    continue
                }

                # If the path starts with /, prepend installPart
                if ($cdPath -match '^/') {
                    $cdPath = "$installpart$cdPath" -replace '//+', '/'
                }

                # If the path starts with ~, replace with home dir
                if ($cdPath -match '^~') {
                    $homeDir = "$installpart\home\$env:USERNAME"
                    $cdPath = $homeDir + $cdPath.Substring(1)
                }
                # If the path is empty, change to home dir
                if ($cdPath -eq '') {
                    $cdPath = "$installpart\home\$env:USERNAME"
                }

                # Replace forward slashes with backslashes
                $cdPath = $cdPath.Replace('/', '\')

                Set-Location -Path $cdPath
            }
            'pkg' {
                Invoke-Pkg -PkgArgs $args -InstallPart $installpart
            }
            'pkg-exec' {
                # Check if $installpart\bin\$args.sh exists
                if (Test-Path "$installpart\bin\$args.sh") {
                    # Execute the script
                    $bashBinPath = Convert-ToBashPath -path "$installpart\bin\$args.sh"
                    $bashExe = $bashexepath
                    & "$bashExe" -c "cd $bashPath; source $bashBinPath"
                } else {
                    Write-Host "Package not found: $args"
                }
            }
            'wsl' {
                Write-Host "Please install the elf-exec package using pkg install elf-exec, then run it here by doing pkg-exec elf-exec."
            }
            'uname' {
                if ($args.Count -eq 0) {
                    Get-Kernel
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
                    }
                    if ($args -eq '-o' -or $args -eq '--operating-system') {
                        Get-OperatingSystem
                    }
                    if ($args -eq '-s' -or $args -eq '--kernel-name') {
                        Get-Kernel
                    }
                    if ($args -eq '-p' -or $args -eq '--processor') {
                        Get-Architecture
                    }
                    if ($args -eq '--version') {
                        Get-UnameVersion
                    }
                    if ($args -eq '-h' -or $args -eq '--help') {
                        Get-UnameHelp
                    }
                    # Check if the argument is unrecognized
                    if ($args -ne '-a' -and $args -ne '--all' -and $args -ne '-o' -and $args -ne '--operating-system' -and $args -ne '-s' -and $args -ne '--kernel-name' -and $args -ne '-p' -and $args -ne '--processor' -and $args -ne '--version' -and $args -ne '-h' -and $args -ne '--help') {
                        Write-Host "Unrecognized argument: $args"
                        Write-Host "Run uname --help for usage information."
                    }
                }
            }
            default {
                if ($command -eq '') {
                    # No command
                    # Loop automatically will continue, so we don't need the continue statement.
                } else {
                    $bashPath = Convert-ToBashPath -path (Get-Location).Path

                    # Fallback to git bash with full per-argument path conversion
                    $bashExe = $bashexepath

                    # Convert each arg separately
                    $convertedArgs = @()
                    foreach ($arg in $args) {
                        # Block Windows absolute paths
                        if ($arg -match '^[A-Za-z]:') {
                            Write-Host "Cannot access Windows path: $arg" -ForegroundColor $colorRed
                            continue
                        }

                        # Normalize slashes
                        $conv = $arg.Replace('\', '/')

                        # If it’s an absolute Kali path, prepend install part
                        if ($conv -match '^/') {
                            $conv = "$installpart$conv" -replace '//+', '/'
                        }

                        # Handle ~ → home dir
                        if ($conv -match '^~') {
                            $homeDir = "$installpart\home\$env:USERNAME"
                            $bashifiedHome = Convert-ToBashPath -path $homeDir
                            $conv = $conv -replace '^~', $bashifiedHome
                        }

                        $convertedArgs += $conv
                    }

                    # Run the command and capture output
                    $commandLine = "cd '$bashPath'; $command $($convertedArgs -join ' ')"
                    if ($command -eq 'ls' -or $command -eq 'dir') {
                        $output = & $bashExe -c $commandLine

                        # Filter out the directories
                        $output | ForEach-Object {
                            $_ -replace 'System\\ Volume\\ Information', '' `
                            -replace '\$RECYCLE\.BIN', '' `
                            -replace 'System Volume Information', '' `
                        } | ForEach-Object {
                            # Trim to clean up trailing spaces after removal
                            $_.Trim()
                        } | Where-Object {
                            # Skip empty lines
                            $_ -ne ''
                        } | ForEach-Object {
                            Write-Host $_
                        }
                    } else {
                        & $bashExe -c $commandLine # To not break things like vim or nvim
                    }
                }
            }
        }
    }
}

# Run the cmdlet
Get-Command