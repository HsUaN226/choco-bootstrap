# Combined Install and Update Script for Chocolatey Packages

# Temporarily bypass the execution policy to allow the script to run
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Ensure Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey is not installed. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Prompt user to choose between install or update
Write-Output "What would you like to do?"
Write-Output "[1] Install packages"
Write-Output "[2] Update packages"
$action = Read-Host "Enter the number of your choice"

switch ($action) {
    1 {
        Write-Output "You chose to install packages."
    }
    2 {
        Write-Output "You chose to update packages."
    }
    default {
        Write-Output "Invalid selection. Exiting."
        exit
    }
}

# Prompt user to select a configuration file
$packageConfigs = Get-ChildItem -Path "packages" -Filter "*.config"
if ($packageConfigs.Count -eq 0) {
    Write-Output "No configuration files found in the packages directory."
    exit
}

Write-Output "Select a configuration file:"
Write-Output "[0] All configuration files"
$packageConfigs | ForEach-Object -Begin { $i = 1 } -Process {
    Write-Output "[$i] $($_.Name)"
    $i++
}

$selection = Read-Host "Enter the number of your choice"
if (-not ($selection -as [int]) -or $selection -lt 0 -or $selection -gt $packageConfigs.Count) {
    Write-Output "Invalid selection. Exiting."
    exit
}

if ($selection -eq 0) {
    # Perform the selected action for all configuration files
    foreach ($configFile in $packageConfigs) {
        Write-Output "Processing $($configFile.FullName)..."
        Get-Content $configFile.FullName | ForEach-Object {
            if ($action -eq 1) {
                choco install $_ -y
            } elseif ($action -eq 2) {
                choco upgrade $_ -y
            }
        }
    }
} else {
    $configFile = $packageConfigs[$selection - 1].FullName

    # Perform the selected action for the chosen configuration file
    if ($action -eq 1 -and $configFile -like "*optional.config") {
        Write-Output "Installing packages from $configFile..."
        $packages = Get-Content $configFile
        while ($true) {
            Write-Output "Available packages:"
            $packages | ForEach-Object -Begin { $i = 1 } -Process {
                Write-Output "[$i] $_"
                $i++
            }
            Write-Output "[0] Stop selecting packages"

            $packageSelection = Read-Host "Enter the number of the package to install or 0 to stop"
            if (-not ($packageSelection -as [int]) -or $packageSelection -lt 0 -or $packageSelection -gt $packages.Count) {
                Write-Output "Invalid selection. Try again."
                continue
            }

            if ($packageSelection -eq 0) {
                Write-Output "Stopping package selection."
                break
            }

            $selectedPackage = $packages[$packageSelection - 1]
            Write-Output "Installing package: $selectedPackage"
            choco install $selectedPackage -y
        }
    } else {
        Write-Output "Processing packages from $configFile..."
        Get-Content $configFile | ForEach-Object {
            if ($action -eq 1) {
                choco install $_ -y
            } elseif ($action -eq 2) {
                choco upgrade $_ -y
            }
        }
    }
}